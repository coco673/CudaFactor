################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../Src/Dixon.cu \
../Src/fillEns.cu \
../Src/gauss.cu \
../Src/initU.cu \
../Src/initV.cu \
../Src/main.cu \
../Src/pgcd.cu \
../Src/prime.cu \
../Src/structure.cu 

CU_DEPS += \
./Src/Dixon.d \
./Src/fillEns.d \
./Src/gauss.d \
./Src/initU.d \
./Src/initV.d \
./Src/main.d \
./Src/pgcd.d \
./Src/prime.d \
./Src/structure.d 

OBJS += \
./Src/Dixon.o \
./Src/fillEns.o \
./Src/gauss.o \
./Src/initU.o \
./Src/initV.o \
./Src/main.o \
./Src/pgcd.o \
./Src/prime.o \
./Src/structure.o 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/groupeDev/CudaFactor/Cuda/Src/header" -I"/home/groupeDev/CudaFactor/Cuda/Test" -G -g -O0 -gencode arch=compute_20,code=sm_20 -odir "Src" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc --device-c -G -I"/home/groupeDev/CudaFactor/Cuda/Src/header" -I"/home/groupeDev/CudaFactor/Cuda/Test" -O0 -g -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_20  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


