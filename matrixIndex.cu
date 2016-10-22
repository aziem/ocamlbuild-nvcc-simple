#include <stdio.h>
#include <sys/time.h>
#include <cuda_runtime.h>
#include <math.h>

void initialData(float *ip, int size) {
  for (int i=0; i < size; i++) {
    ip[i] = (float)rand()/(float)(RAND_MAX/10.0);
  }
}

void print_matrix(float *c, const int nx, const int ny) {
  float *ic = c;
  for (int iy=0; iy<ny; iy++) {
    for (int ix=0; ix<nx; ix++) {
      printf("%6.2f", ic[ix]);
    }
    ic += nx;
    printf("\n");
  }
  printf("\n");
}


__global__ void print_thread_index(float* a, const int nx, const int ny) {
  int ix = threadIdx.x + blockIdx.x * blockDim.x;
  int iy = threadIdx.y + blockIdx.y * blockDim.y;

  unsigned int idx = iy*nx + ix;

  printf("thread_id (%d, %d) block_id (%d, %d) coordinate (%d, %d)"
	 "global index %2d ival %2d\n",
	 threadIdx.x, threadIdx.y, blockIdx.x, blockIdx.y, ix, iy, idx, a[idx]);
  
}

void test() {
  int dev = 0;
  cudaSetDevice(dev);

  int nx = 4;
  int ny = 4;

  int nxy = nx*ny;
  int nbytes = nxy * sizeof(float);

  float *h_A;
  h_A = (float *) malloc(nbytes);

  initialData(h_A, nx*ny);
  print_matrix(h_A, nx, ny);

  float *d_A;
  cudaMalloc((void **) &d_A, nbytes);

  cudaMemcpy(d_A, h_A, nbytes, cudaMemcpyHostToDevice);

  dim3 block(4, 2);
  dim3 grid ((nx+block.x-1)/block.x, (ny+block.y-1)/block.y);
  
  print_thread_index <<< grid, block >>>(d_A, nx, ny);
  cudaDeviceSynchronize();

  cudaFree(d_A);
  free(h_A);
  cudaDeviceReset();
}