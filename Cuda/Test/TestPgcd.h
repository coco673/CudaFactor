/*
 *  TestPgcd.h
 *  
 *
 *  Created by Tony on 21/02/2014.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include "../Src/header/pgcd.h"


int TestPgcd();
int TestPgcdG();

uint64_t pgcdUint(uint64_t u, uint64_t v);
uint64_t pgcdRec(uint64_t u, uint64_t v);
