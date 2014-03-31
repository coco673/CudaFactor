/*
 *  TestStructure.c
 *  
 *
 *  Created by Tony on 21/02/2014.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */

#include "TestStructure.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>


int testInitEns(){
	int size;
	ensemble t = (ensemble) initEns(&size);

	assert(t != NULL);
	assert(size == 0);

	return 0;
}
int testAddVal(int val){
	int size;
	ensemble e = (ensemble) initEns(&size);
	int res =	addVal(&e,val,&size);

	assert(res == 1);

	assert(e[0].ind.val == val);
	assert(size == 1);
	val++;
	res =	addVal(&e,val,&size);

	assert(res == 1);
	assert(e[1].ind.val == val);
	assert(size == 2);

	val++;
	res =	addVal(&e,val,&size);

	assert(res == 1);
	assert(e[2].ind.val == val);
	assert(size == 3);
	return 0;
}

int testAddCouple(int valx,int valy){
	int size;
	ensemble e = (ensemble) initEns(&size);
	int res =	addCouple(&e,valx,valy,&size);


	assert(res == 1);

	assert(e[0].ind.couple.x == valx);
	assert(e[0].ind.couple.y == valy);
	assert(size == 1);

	valx++;
	valy++;
	res =	addCouple(&e,valx,valy,&size);


	assert(res == 1);
	assert(e[1].ind.couple.x == valx);
	assert(e[1].ind.couple.y == valy);
	assert(size == 2);

	return 0;
}

