#include <stdlib.h>
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "TestFillEnsemble.h"
#include "TestPgcd.h"
#include "TestStructure.h"


int main(){
	int val = 62;
	int valx = 44;
	int valy = 32;

	testInitEns();
	printf("Test InitEns -> passed\n");

	testAddVal(val);
	printf("Test AddVal -> passed\n");

	testAddCouple(valx,valy);
	printf("Test AddCouple -> passed\n");

	TestIsBSmooth();
	printf("Test BSmooth -> passed\n");

	TestIsInEnsemble();
	printf("Test IsInEnsemble -> passed\n");

	TestIsInf();
	printf("Test isinf -> passed\n");

	TestIsBSmoothG();
	printf("Test BSmoothG -> passed\n");

	TestIsInEnsembleG();
	printf("Test IsInEnsembleG -> passed\n");

	TestfillEnsemble();
	printf("Test fillEnsemble -> passed\n");

	TestfillEnsembleG();
	printf("Test fillEnsembleG -> passed\n");

	TestPgcd();
	printf("Test Pgcd -> passed\n");
	return 0;
}
