/*
 * pgcd.cu
 */

#include "header/pgcd.h"
#include <string.h>

#include <time.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

uint64_t pgcdUint(uint64_t u, uint64_t v) {
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

uint64_t pgcdRec(uint64_t u, uint64_t v) {
 if (u == v) return u;
 if (u == 0) return v;
 if (v == 0) return u;
 if (~u & 1) {
   if (v & 1) return pgcdRec(u >> 1, v);
   else return pgcdRec(u >> 1, v >> 1) << 1;
 }
 if (~v & 1) return pgcdRec(u, v >> 1);
 if (u > v) return pgcdRec((u - v) >> 1, v);
 return pgcdRec((v - u) >> 1, u);
}
