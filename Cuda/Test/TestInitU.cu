
/*
 * TestInitU.cu
 *
 *  Created on: 28 mars 2014
 *      Author: Clement
 */


#include "TestInitU.h"

int TestInitU(){
	int m;
	int n = 99;
	int x[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
ensemble r = initEns(&m);

	//ensemble r = (ensemble) malloc(10*sizeof(struct cell));
	for (int i=0; i<10; i++) {
		r[i].ind.couple.x = x[i];
		r[i].ind.couple.y = 0;
		m++;
		//addCouple(&r, x[i], 1, &m);
	}
	int e[] = {1, 0, 0, 1, 1, 0, 1, 0, 0, 1};

	int c = initU(r, m, e, n);
	int res = 97;
	assert(c == res);
delEns(r);
	return 0;
}
