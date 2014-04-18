#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "../Src/header/prime.h"

int TestPrime() {
	int k;
	int borne = 100;
	int *res = generatePrimeList(borne,&k);



	assert(k == 23);

	return 1;
}
