#include <stdlib.h>
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
//#include "TestFillEnsemble.h"
#include "TestPgcd.h"
#include "TestStructure.h"
#include "TestInitU.h"
#include "Dixon.h"
#include "TestFill.h"
int main(){
	int val = 62;
	int valx = 44;
	int valy = 32;

	/*if(TestPgcd() == 0){
		printf("Test Pgcd -> passed\n");
	} else{
		printf(" Test Pgcd **** Not Passed\n");
	}
	if(TestPgcdG() == 0){
		printf("Test PgcdG -> passed\n");
	} else{
		printf(" Test PgcdG **** Not Passed\n");
	}
	if(TestInitU() == 0){
		printf("Test InitU -> passed\n");
	} else{
		printf(" Test InitU **** Not Passed\n");
	}
	if(testInitEns()== 0){
		printf("Test InitEns -> passed\n");
	} else{
		printf(" Test InitEns **** Not Passed\n");
	}
	if(testAddVal(val)== 0){
		printf("Test AddVal -> passed\n");
	} else{
		printf("Test AddVa **** Not Passed\n");
	}
	if(testAddCouple(valx,valy)== 0){
		printf("Test AddCouple -> passed\n");
	} else{
		printf("Test AddCouple **** Not Passed\n");
	}
	if(TestIsBSmooth() == 0){
		printf("Test BSmooth -> passed\n");
	} else{
		printf("Test BSmooth **** Not Passed\n");
	}
	if(TestIsInEnsemble()== 0){
		printf("Test IsInEnsemble -> passed\n");
	} else{
		printf("Test IsInEnsemble **** Not Passed\n");
	}
	if(TestIsInf()== 0){
		printf("Test isinf -> passed\n");
	} else{
		printf("Test isinf **** Not Passed\n");
	}
	if(TestIsBSmoothG()== 0){
		printf("Test BSmoothG -> passed\n");
	} else{
		printf("Test BSmoothG **** Not Passed\n");
	}
	if(TestIsInEnsembleG()== 0){
		printf("Test IsInEnsembleG -> passed\n");
	} else{
		printf("Test IsInEnsembleG **** Not Passed\n");
	}
	if(TestfillEnsemble() == 0){
		printf("Test fillEnsemble -> passed\n");
	} else{
		printf("Test fillEnsemble **** Not Passed\n");
	}
	if(TestGenerateOnce()== 0){
		printf("Test TestGenerateOnce -> passed\n");
	} else{
		printf(" Test TestGenerateOnce**** Not Passed\n");
	}
	if(TestfillEnsembleG() == 0){
		printf("Test fillEnsembleG -> passed\n");
	} else{
		printf("Test fillEnsembleG **** Not Passed\n");
	}*/
	/*if(TestfillEnsG() == 0){
		printf("Test fillEnsemblR -> passed\n");
	} else{
		printf("Test fillEnsembleG **** Not Passed\n");
	}*/
	int size;
	ensemble Div = Dixon2(2103,&size);
	for(int i = 0; i< size; i++){
		printf("%i\n",Div[i].ind.val);
	}
printf("goodbye my lover\n");
	return 0;
}
