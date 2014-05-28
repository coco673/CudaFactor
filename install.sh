#!/bin/sh
grep libSage ~/.bashrc
if [ $? != 0];then
	echo "export PATH=$PWD/Sage/libSage:$PATH" >> ~/.bashrc 
fi

path=${PWD}

if [ -e ${path}/Cuda/Release/makefile ];then
	cd ${path}/Cuda/Release
	make
fi

if [ -e ${path}/IHM/Makefile ]; then
	cd ${path}/IHM/
	qmake
	make
fi

mv ${path}/IHM/CUDAFactor ${path}/CudaFactor

exit 0

