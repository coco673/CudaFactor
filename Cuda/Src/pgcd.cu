/*
 * pgcd.c
 *
 *  Created on: 30 janv. 2014
 *      Author: tony
 */

#include "header/pgcd.h"
#include <string.h>

#include <time.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

__host__ __device__ uint64_t pgcdUint(uint64_t u, uint64_t v) {
	int shift;
	if (u == 0) {
		return v;
	}
	if (v == 0) {
		return u;
	}
	for (shift = 0; ((u | v) & 1) == 0; ++shift) {
		u >>= 1;
		v >>= 1;
	}

	while ((u & 1) == 0) {
		u >>= 1;
	}

	do {
		while ((v & 1) == 0)
			v >>= 1;
		if (u > v) {
			uint64_t t = v;
			v = u;
			u = t;
		}
		v = v - u;
	} while (v != 0);

	uint64_t res = u << shift;
	return res;
}
