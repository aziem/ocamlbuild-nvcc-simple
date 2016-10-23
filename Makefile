matrixIndex.o: matrixIndex.cu
	ocamlbuild matrixIndex.o

test.native: test.ml matrixIndex.o
	ocamlbuild -use-ocamlfind test.native

clean:
	ocamlbuild -clean
