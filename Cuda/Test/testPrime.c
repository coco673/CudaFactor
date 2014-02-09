#include <stdio.h>
#include <stdlib.h>
#include "header/prime.h"

int main(int argc, char **argv) {
	int borne;
	if (argc < 2) {
		borne = 100;
	} else {
		borne = atoi(argv[1]);
	}
	int res = generatePrimeList(borne);
	return res;
}
