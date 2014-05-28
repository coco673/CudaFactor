#!/bin/sh

path=${PWD}

if [ -x ${path}/CudaFactor ]; then
	rm CudaFactor
	cd ${path}/Cuda/Release/
	make clean
fi
if [ -x ${path}/IHM/ ];then
	cd ${path}/IHM
	make clean
fi

exit 0

