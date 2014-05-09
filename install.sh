#!/bin/sh

echo "export PATH= Sage/libSage:$PATH" >> ~/.bashrc 
path=${PWD}

if [ -e ${path}/Cuda/Debug/makefile ];then
	cd ${path}/Cuda/Debug
	make
fi

if [ -e ${path}/IHM/Makefile ]; then
	cd ${path}/IHM/
	qmake
	make
fi

mv ${path}/IHM/CUDAFactor ${path}/CudaFactor

exit 0

