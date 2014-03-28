
/*
 * TestInitU.cu
 *
 *  Created on: 28 mars 2014
 *      Author: Clement
 */


#include "TestInitU.h"

int TestInitU(){
	int m = 10;
	int x[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	int e[] = {1, 0, 0, 1, 1, 0, 1, 0, 0, 1};

	int c = initU(x, m, e);

	int res = 1960000;
	assert(c == res);

	return 0;
}
