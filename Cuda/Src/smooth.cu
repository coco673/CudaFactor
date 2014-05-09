/**
 * smooth.cu
 */
#include "header/smooth.h"

int isBSmoothG(int *primeList, int size, uint64_t y) {
	int i = 0;
	if (i < size) {
		int y1 = y;
		if (y1 == 0) {
			return 0;
		} else {
			for (int j = 0; j < size;j++) {
				while (y1 % primeList[j] == 0) {
					y1 = y1/primeList[j];
				}
			}
			if (y1 == 1) {
				return 1;
			} else {
				return 0;
			}
		}
	}
	return -1;
}
