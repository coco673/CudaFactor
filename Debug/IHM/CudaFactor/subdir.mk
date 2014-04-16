################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../IHM/CudaFactor/attente.o \
../IHM/CudaFactor/choixcompa_facto.o \
../IHM/CudaFactor/choixmethode.o \
../IHM/CudaFactor/choixnombre.o \
../IHM/CudaFactor/comparaisonxml.o \
../IHM/CudaFactor/fenetreprincipale.o \
../IHM/CudaFactor/main.o \
../IHM/CudaFactor/mainwindow.o \
../IHM/CudaFactor/moc_Frame.o \
../IHM/CudaFactor/moc_attente.o \
../IHM/CudaFactor/moc_choixcompa_facto.o \
../IHM/CudaFactor/moc_choixmethode.o \
../IHM/CudaFactor/moc_choixnombre.o \
../IHM/CudaFactor/moc_comparaisonxml.o \
../IHM/CudaFactor/moc_fenetreprincipale.o \
../IHM/CudaFactor/moc_mainwindow.o \
../IHM/CudaFactor/moc_resultat.o \
../IHM/CudaFactor/model.o \
../IHM/CudaFactor/modelcomparaison.o \
../IHM/CudaFactor/modelfenprinc.o \
../IHM/CudaFactor/resultat.o 

CPP_SRCS += \
../IHM/CudaFactor/attente.cpp \
../IHM/CudaFactor/choixcompa_facto.cpp \
../IHM/CudaFactor/choixmethode.cpp \
../IHM/CudaFactor/choixnombre.cpp \
../IHM/CudaFactor/comparaisonxml.cpp \
../IHM/CudaFactor/fenetreprincipale.cpp \
../IHM/CudaFactor/main.cpp \
../IHM/CudaFactor/mainwindow.cpp \
../IHM/CudaFactor/moc_Frame.cpp \
../IHM/CudaFactor/moc_attente.cpp \
../IHM/CudaFactor/moc_choixcompa_facto.cpp \
../IHM/CudaFactor/moc_choixmethode.cpp \
../IHM/CudaFactor/moc_choixnombre.cpp \
../IHM/CudaFactor/moc_comparaisonxml.cpp \
../IHM/CudaFactor/moc_fenetreprincipale.cpp \
../IHM/CudaFactor/moc_mainwindow.cpp \
../IHM/CudaFactor/moc_resultat.cpp \
../IHM/CudaFactor/model.cpp \
../IHM/CudaFactor/modelcomparaison.cpp \
../IHM/CudaFactor/modelfenprinc.cpp \
../IHM/CudaFactor/resultat.cpp 

OBJS += \
./IHM/CudaFactor/attente.o \
./IHM/CudaFactor/choixcompa_facto.o \
./IHM/CudaFactor/choixmethode.o \
./IHM/CudaFactor/choixnombre.o \
./IHM/CudaFactor/comparaisonxml.o \
./IHM/CudaFactor/fenetreprincipale.o \
./IHM/CudaFactor/main.o \
./IHM/CudaFactor/mainwindow.o \
./IHM/CudaFactor/moc_Frame.o \
./IHM/CudaFactor/moc_attente.o \
./IHM/CudaFactor/moc_choixcompa_facto.o \
./IHM/CudaFactor/moc_choixmethode.o \
./IHM/CudaFactor/moc_choixnombre.o \
./IHM/CudaFactor/moc_comparaisonxml.o \
./IHM/CudaFactor/moc_fenetreprincipale.o \
./IHM/CudaFactor/moc_mainwindow.o \
./IHM/CudaFactor/moc_resultat.o \
./IHM/CudaFactor/model.o \
./IHM/CudaFactor/modelcomparaison.o \
./IHM/CudaFactor/modelfenprinc.o \
./IHM/CudaFactor/resultat.o 

CPP_DEPS += \
./IHM/CudaFactor/attente.d \
./IHM/CudaFactor/choixcompa_facto.d \
./IHM/CudaFactor/choixmethode.d \
./IHM/CudaFactor/choixnombre.d \
./IHM/CudaFactor/comparaisonxml.d \
./IHM/CudaFactor/fenetreprincipale.d \
./IHM/CudaFactor/main.d \
./IHM/CudaFactor/mainwindow.d \
./IHM/CudaFactor/moc_Frame.d \
./IHM/CudaFactor/moc_attente.d \
./IHM/CudaFactor/moc_choixcompa_facto.d \
./IHM/CudaFactor/moc_choixmethode.d \
./IHM/CudaFactor/moc_choixnombre.d \
./IHM/CudaFactor/moc_comparaisonxml.d \
./IHM/CudaFactor/moc_fenetreprincipale.d \
./IHM/CudaFactor/moc_mainwindow.d \
./IHM/CudaFactor/moc_resultat.d \
./IHM/CudaFactor/model.d \
./IHM/CudaFactor/modelcomparaison.d \
./IHM/CudaFactor/modelfenprinc.d \
./IHM/CudaFactor/resultat.d 


# Each subdirectory must supply rules for building sources it contributes
IHM/CudaFactor/%.o: ../IHM/CudaFactor/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -G -g -lineinfo -pg -O0 --use_fast_math -v -gencode arch=compute_20,code=sm_20 -odir "IHM/CudaFactor" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc -I"/home/tim/CudaFactorMaster/Cuda/Src/header" -I"/home/tim/CudaFactorMaster/Cuda/Test" -G -g -lineinfo -pg -O0 --use_fast_math -v --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


