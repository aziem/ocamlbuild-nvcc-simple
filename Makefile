matrixIndex.o: matrixIndex.cu
	ocamlbuild matrixIndex.o

clean:
	ocamlbuild -clean
