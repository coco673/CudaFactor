/*
 * init.cu
 *
 *  Created on: 27 mars 2014
 *      Author: clement
 */



#include "header/initU.h"


int initU(ensemble r, int m, int *e, int n) {
	int res = 1;
	for (int i = 0; i < m; i++) {
		if (e[i] != 0) {
			res = res * (r[i].ind.couple.x * r[i].ind.couple.x);
		}
	}
	res = res%n;
	return res;
}
