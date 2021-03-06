################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../Src/coupleList.cu \
../Src/dixon.cu \
../Src/fillEns.cu \
../Src/gauss.cu \
../Src/intList.cu \
../Src/main.cu \
../Src/matrix.cu \
../Src/pgcd.cu \
../Src/prime.cu \
../Src/rabin-miller.cu \
../Src/smooth.cu \
../Src/structure.cu \
../Src/vector.cu 

CU_DEPS += \
./Src/coupleList.d \
./Src/dixon.d \
./Src/fillEns.d \
./Src/gauss.d \
./Src/intList.d \
./Src/main.d \
./Src/matrix.d \
./Src/pgcd.d \
./Src/prime.d \
./Src/rabin-miller.d \
./Src/smooth.d \
./Src/structure.d \
./Src/vector.d 

OBJS += \
./Src/coupleList.o \
./Src/dixon.o \
./Src/fillEns.o \
./Src/gauss.o \
./Src/intList.o \
./Src/main.o \
./Src/matrix.o \
./Src/pgcd.o \
./Src/prime.o \
./Src/rabin-miller.o \
./Src/smooth.o \
./Src/structure.o \
./Src/vector.o 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/opt/cuda/bin/nvcc -O3 -gencode arch=compute_20,code=sm_20  -odir "Src" -M -o "$(@:%.o=%.d)" "$<"
	/opt/cuda/bin/nvcc --device-c -O3 -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_20  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


