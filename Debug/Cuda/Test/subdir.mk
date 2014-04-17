################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Cuda/Test/CuTest.c 

CU_SRCS += \
../Cuda/Test/TestFillEnsemble.cu \
../Cuda/Test/TestFillMatrix.cu \
../Cuda/Test/TestInitU.cu \
../Cuda/Test/TestPgcd.cu \
../Cuda/Test/TestStructure.cu \
../Cuda/Test/testPrime.cu 

CU_DEPS += \
./Cuda/Test/TestFillEnsemble.d \
./Cuda/Test/TestFillMatrix.d \
./Cuda/Test/TestInitU.d \
./Cuda/Test/TestPgcd.d \
./Cuda/Test/TestStructure.d \
./Cuda/Test/testPrime.d 

OBJS += \
./Cuda/Test/CuTest.o \
./Cuda/Test/TestFillEnsemble.o \
./Cuda/Test/TestFillMatrix.o \
./Cuda/Test/TestInitU.o \
./Cuda/Test/TestPgcd.o \
./Cuda/Test/TestStructure.o \
./Cuda/Test/testPrime.o 

C_DEPS += \
./Cuda/Test/CuTest.d 


# Each subdirectory must supply rules for building sources it contributes
Cuda/Test/%.o: ../Cuda/Test/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -G -g -lineinfo -pg -O0 --use_fast_math -v -gencode arch=compute_20,code=sm_20 -odir "Cuda/Test" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -G -g -lineinfo -pg -O0 --use_fast_math -v --compile  -x c -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

Cuda/Test/%.o: ../Cuda/Test/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -G -g -lineinfo -pg -O0 --use_fast_math -v -gencode arch=compute_20,code=sm_20 -odir "Cuda/Test" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc --device-c --use_fast_math -G -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -O0 -g -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_20 -lineinfo -pg -v  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


