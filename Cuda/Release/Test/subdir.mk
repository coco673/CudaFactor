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
	/opt/cuda/bin/nvcc -O3 -gencode arch=compute_20,code=sm_20  -odir "Test" -M -o "$(@:%.o=%.d)" "$<"
	/opt/cuda/bin/nvcc -O3 --compile  -x c -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

Test/%.o: ../Test/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/opt/cuda/bin/nvcc -O3 -gencode arch=compute_20,code=sm_20  -odir "Test" -M -o "$(@:%.o=%.d)" "$<"
	/opt/cuda/bin/nvcc --device-c -O3 -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_20  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


