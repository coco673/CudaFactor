#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "../src/header/fillMatrix.h"

int main(int argc, char **argv) {
	int *yList = (int *) malloc(3 * sizeof(int));
	yList[0] = 3;
	yList[1] = 5;
	yList[2] = 8;

}
