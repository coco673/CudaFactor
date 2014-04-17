#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "../Src/header/prime.h"

int TestPrime() {
	int k;
	uint64_t borne = 100;
	uint64_t *res = generatePrimeList(borne,&k);



	assert(k == 23);

	return 1;
}
