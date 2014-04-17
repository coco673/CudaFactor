################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Cuda/Debug/Test/CuTest.c 

OBJS += \
./Cuda/Debug/Test/CuTest.o 

C_DEPS += \
./Cuda/Debug/Test/CuTest.d 


# Each subdirectory must supply rules for building sources it contributes
Cuda/Debug/Test/%.o: ../Cuda/Debug/Test/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -G -g -lineinfo -pg -O0 --use_fast_math -v -gencode arch=compute_20,code=sm_20 -odir "Cuda/Debug/Test" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -G -g -lineinfo -pg -O0 --use_fast_math -v --compile  -x c -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


