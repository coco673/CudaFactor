/*
 * TestFill.cu
 *
 *  Created on: 3 avr. 2014
 *      Author: groupeDev
 */

#include "fillEns.h"
#include "fillEnsemble.h"
#include "prime.h"
#include <unistd.h>
int TestfillEnsG(){
	int k = 0;
	int nbr = 201;
	int borne = ceil(exp(sqrt(2 * log(nbr) * log(log(nbr)))));

	int sqrtNRB = (int)sqrt(nbr);
	int *rand = (int *) malloc(k*sizeof(int));
	int *dev_rand;
	int *p = generatePrimeList(borne,&k);
	printf("k = %i\n",k);
	printf("sqrt = %i\n",sqrtNRB);
	int *dev_p;
	curandState_t *state = (curandState_t *)malloc(k*sizeof(curandState_t));
	curandState_t *dev_state ;
	int sizeR= 0;
	int *dev_sizeR;
	int sizeDiv = 0;
	int *dev_sizeDiv;
	int *matrix =(int *)malloc((k*k)*sizeof(int));
	int *dev_matrix;
	ensemble R;
	ensemble dev_R;
	ensemble Div ;
	ensemble dev_Div;


	R = (ensemble)malloc(k*sizeof(struct cell));
	Div = (ensemble) malloc(sizeof(struct cell));
	cudaMalloc(&dev_R,k*sizeof(struct cell));
	cudaMalloc(&dev_Div,sizeof(struct cell));
	cudaMalloc(&dev_p,k*sizeof(int));
	cudaMalloc(&dev_rand,k*sizeof(int));
	cudaMalloc(&dev_sizeR,sizeof(int));
	cudaMalloc(&dev_matrix,(k*k)*sizeof(int));

	cudaMalloc(&dev_state,k*sizeof(curandState_t));
	cudaMalloc(&dev_sizeDiv,sizeof(int));

	cudaMemcpy(dev_sizeR,&sizeR,sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_p,p,k*sizeof(int),cudaMemcpyHostToDevice);
	//cudaMemcpy(dev_state,state,k*sizeof(curandState_t),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_R,R,k*sizeof(struct cell),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_Div,Div,sizeof(struct cell),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_sizeDiv,&sizeDiv,sizeof(int),cudaMemcpyHostToDevice);


	Generation<<<1,k>>>(dev_state,nbr, sqrtNRB,dev_rand);

	cudaMemcpy(rand,dev_rand,k*sizeof(int),cudaMemcpyDeviceToHost);
	for(int i = 0;i<k;i++){
		printf("blahaza %i\n",rand[i]);
	}
	printf("size Div = %i\n",sizeDiv);
	fillEnsR<<<1,k>>>(dev_state,dev_R,dev_sizeR,dev_Div,dev_sizeDiv,dev_p,k,dev_rand,nbr,dev_matrix);

	cudaMemcpy(&sizeR,dev_sizeR,sizeof(int),cudaMemcpyDeviceToHost);
	cudaMemcpy(R,dev_R,k*sizeof(struct cell),cudaMemcpyDeviceToHost);
	cudaMemcpy(matrix,dev_matrix,(k*k)*sizeof(int),cudaMemcpyDeviceToHost);


	for(int i = 0;i<k;i++){
		printf("x a la fin = %i y a la fin = %i\n",R[i].ind.couple.x,R[i].ind.couple.y);
	}
	for(int i = 0;i<k*k;i++){
		printf("mat = %i\n",matrix[i]);
	}
	/*cudaFree(dev_R);
	cudaFree(dev_Div);
	cudaFree(dev_p);
	cudaFree(dev_rand);
	cudaFree(dev_sizeR);
	cudaFree(dev_matrix);
	free(R);
	free(Div);
	free(rand);
	free(p);
	free(matrix);*/
}
