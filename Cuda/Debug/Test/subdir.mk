################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Test/CuTest.c 

CU_SRCS += \
../Test/TestFillEnsemble.cu \
../Test/TestPgcd.cu \
../Test/TestStructure.cu \
../Test/testPrime.cu 

CU_DEPS += \
./Test/TestFillEnsemble.d \
./Test/TestPgcd.d \
./Test/TestStructure.d \
./Test/testPrime.d 

OBJS += \
./Test/CuTest.o \
./Test/TestFillEnsemble.o \
./Test/TestPgcd.o \
./Test/TestStructure.o \
./Test/testPrime.o 

C_DEPS += \
./Test/CuTest.d 


# Each subdirectory must supply rules for building sources it contributes
Test/%.o: ../Test/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tony/CudaFactor/Cuda/Src/mpz" -G -g -lineinfo -pg -O0 -gencode arch=compute_20,code=sm_20 -odir "Test" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tony/CudaFactor/Cuda/Src/mpz" -G -g -lineinfo -pg -O0 --compile  -x c -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

Test/%.o: ../Test/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tony/CudaFactor/Cuda/Src/mpz" -G -g -lineinfo -pg -O0 -gencode arch=compute_20,code=sm_20 -odir "Test" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc --device-c -G -I"/home/tony/CudaFactor/Cuda/Src/mpz" -O0 -g -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_20 -lineinfo -pg  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


