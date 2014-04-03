/*
 * Dixon.h
 *
 *  Created on: 1 avr. 2014
 *      Author: didelify
 */

#ifndef DIXON_H_
#define DIXON_H_

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "structure.h"
#include "prime.h"
#include "pgcd.h"
#include "initV.h"
#include "initU.h"
#include "fillEns.h"
#include "gauss.h"

int produit(ensemble div, int sizeDiv);
ensemble Dixon(int n);
ensemble Dixon2(int n,int *sizeFinal);

#endif /* DIXON_H_ */
