/*
 * pgcd.c
 *
 *  Created on: 30 janv. 2014
 *      Author: tony
 */



#include "header/pgcd.h"

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
		char *tp = malloc(size*sizeof(char));

		for(i=0;i<n;i++){
			strcat(tp,"0");
		}
		strcat(tp,res);
		res = malloc(size*sizeof(char));
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
	res=malloc(i*sizeof(char));
	i--;

	while (i >= 0){

		char *tmp = malloc(sizeof(char));
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
long double pgcd(long double a,long double b){

	long double r,q;
	if(a<b){
		long double c = a;
		a=b;
		b=c;
	}
	r = fmodl(a, b);
	while (r != 0){
		if(a > b){
			a = b;
			b = r;
			r = fmodl(a, b);
		}
	}
	q = b;
return q;
}
