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

typedef unsigned long long uint64;

/*
 * Debut d'algorithme de Kannan-Miller-Rudolph pour obtenir le pgcd de manière parallelisée
 */
/*int pgcd(long double a, long double b){
	int n;
	if(a<b){
		n=strlen(convert(b));
	} else {
		n =strlen(convert(a));
	}

	int i = 0;
	long double *tab=malloc(n*sizeof(long double));
	switch(fork()){
		case -1 :
			exit(EXIT_FAILURE);
		case 0 :

			while(i <= n){
				tab[i] =fmodl((i*a),b);

				printf("1:%i:%s\n",i,convert(tab[i]));
				i=i+2;
			}
			break;
		default :

			i = 1;
			while(i <= n){
				tab[i] =fmodl((i*a),b);
				printf("2:%i:%s\n",i,convert(tab[i]));
				i=i+2;
			}
	}
}*/
/*
 * Change la taille de representation du binaire en size bits
 */
char *equalNBit(char *res,int size){
	int i ;
	if(strlen(res) != size){
		int n = size - strlen(res);
		char *tp = (char *)malloc(size*sizeof(char));

		for(i=0;i<n;i++){
			strcat(tp,"0");
		}
		strcat(tp,res);
		res =(char *) malloc(size*sizeof(char));
		strcpy(res,tp);
		free(tp);
	}
	return res;
}
/*
 *  Converti un entier representé sous la forme d'un long double en binaire.
 */
char *convert(long double a){
	long double n;
	long double tp[N];
	int i=0;
	n=a;


	do {
		tp[i]=fmodl(n,2);
		n=floorl(n/2);
		i++;

	} while (n>=1);


	char *res;
	res=(char *)malloc(i*sizeof(char));
	i--;

	while (i >= 0){

		char *tmp = (char *)malloc(sizeof(char));
		sprintf(tmp,"%i",(int)tp[i]);
		strcat(res,tmp);

		i--;
		free(tmp);
	}

	return res;
}

/*
 * calcule du pgcd selon l'algorithme d'euclide pour les grands entiers.
 */
int pgcd(int a,int b){

	int r,q;
	if(a<b){
		int c = a;
		a=b;
		b=c;
	}
	r = fmod(a, b);
	while (r != 0){
		if(a > b){
			a = b;
			b = r;
			r = fmod(a, b);
		}
	}
	q = b;
return q;
}

uint64 pgcdUint(uint64 u, uint64 v) {
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
			uint64 t = v;
			v = u;
			u = t;
		}
		v = v - u;
	} while (v != 0);

  uint64 res = u << shift;
  return res;
}
