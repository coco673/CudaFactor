################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../Cuda/Src/coupleList.cu \
../Cuda/Src/dixon.cu \
../Cuda/Src/fillEns.cu \
../Cuda/Src/fillMatrix.cu \
../Cuda/Src/gauss.cu \
../Cuda/Src/intList.cu \
../Cuda/Src/main.cu \
../Cuda/Src/matrix.cu \
../Cuda/Src/pgcd.cu \
../Cuda/Src/prime.cu \
../Cuda/Src/rabin-miller.cu \
../Cuda/Src/smooth.cu \
../Cuda/Src/vector.cu 

CU_DEPS += \
./Cuda/Src/coupleList.d \
./Cuda/Src/dixon.d \
./Cuda/Src/fillEns.d \
./Cuda/Src/fillMatrix.d \
./Cuda/Src/gauss.d \
./Cuda/Src/intList.d \
./Cuda/Src/main.d \
./Cuda/Src/matrix.d \
./Cuda/Src/pgcd.d \
./Cuda/Src/prime.d \
./Cuda/Src/rabin-miller.d \
./Cuda/Src/smooth.d \
./Cuda/Src/vector.d 

OBJS += \
./Cuda/Src/coupleList.o \
./Cuda/Src/dixon.o \
./Cuda/Src/fillEns.o \
./Cuda/Src/fillMatrix.o \
./Cuda/Src/gauss.o \
./Cuda/Src/intList.o \
./Cuda/Src/main.o \
./Cuda/Src/matrix.o \
./Cuda/Src/pgcd.o \
./Cuda/Src/prime.o \
./Cuda/Src/rabin-miller.o \
./Cuda/Src/smooth.o \
./Cuda/Src/vector.o 


# Each subdirectory must supply rules for building sources it contributes
Cuda/Src/%.o: ../Cuda/Src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/cudaFactorRelease/Cuda/Src/header" -O3 -gencode arch=compute_20,code=sm_20 -odir "Cuda/Src" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc --device-c -I"/home/tim/cudaFactorRelease/Cuda/Src/header" -O3 -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_20  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


