/**
 * intList.cu
 */
#include "header/intList.h"

__device__ void copyTabDev(uint64_t *src, uint64_t *dest, int size) {
	if (blockIdx.x == 0) {
		int tid = threadIdx.x;
		if (tid < size) {
			dest[tid] = src[tid];
		}
	}
}

//1 block ; size thread
__global__ void copyTabGPU(uint64_t *src, uint64_t *dest, int size) {
	int tid = threadIdx.x;
	if (tid < size) {
		 dest[tid] = src[tid];
	}
}

__host__ Int_List_GPU *createIntList() {
	Int_List_GPU *l = new Int_List_GPU[1];
	l->Size = 0;
	l->List = NULL;
	return l;
}

__host__ void addInt(Int_List_GPU **list, int v) {
	Int_List_GPU *l = new Int_List_GPU[1];
	l->List = new uint64_t[(*list)->Size + 1];
	l->Size = (*list)->Size + 1;
	uint64_t *dev_list_dest, *dev_list_src;

	cudaMalloc((void **)&dev_list_src, (*list)->Size * sizeof(uint64_t));
	cudaMemcpy(dev_list_src, (*list)->List, (*list)->Size * sizeof(uint64_t), cudaMemcpyHostToDevice);
	cudaMalloc((void **)&dev_list_dest, ((*list)->Size + 1) * sizeof(uint64_t));
	
	copyTabGPU<<<1, (*list)->Size>>>(dev_list_src, dev_list_dest, (*list)->Size);
	
	cudaMemcpy(l->List, dev_list_dest, (*list)->Size * sizeof(uint64_t), cudaMemcpyDeviceToHost);
	cudaFree(dev_list_src);
	cudaFree(dev_list_dest);
	
	l->List[(*list)->Size] = v;

	delete[]((list[0])->List);
	delete[](list[0]);
	list[0] = l;
}

__device__ void addIntGPU(uint64_t **list, int size, int v) {
	if (blockIdx.x == 0) {
		__shared__ uint64_t *l;
		if (threadIdx.x == 0) {
			l = new uint64_t[size + 1];
		}
		copyTabDev((*list), l, size);
		l[size] = v;
		*list = l;
	}
}

__host__ uint64_t getVal(Int_List_GPU l, int index) {
	return l.List[index];
}

__device__ uint64_t getValGPU(uint64_t *l, int index) {
	return l[index];
}

__host__ void removeLastInt(Int_List_GPU **list) {
	Int_List_GPU *l = new Int_List_GPU[1];
	l->List = new uint64_t[(*list)->Size - 1];
	int *dev_list_dest, *dev_list_src;
	
	cudaMalloc((void **)&dev_list_src, (*list)->Size * sizeof(int));
	cudaMemcpy(dev_list_src, (*list)->List, (*list)->Size * sizeof(int), cudaMemcpyHostToDevice);
	cudaMalloc((void **)&dev_list_dest, ((*list)->Size - 1) * sizeof(int));
	
	copyTabGPU<<<1, (*list)->Size - 1>>>((*list)->List, l->List, (*list)->Size - 1);
	
	cudaMemcpy(l->List, dev_list_dest, ((*list)->Size - 1) * sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(dev_list_src);
	cudaFree(dev_list_dest);
	
	l->Size = (*list)->Size - 1;
	*list = l;
}

__device__ void removeLastInt(uint64_t **list, uint64_t size) {
	if (blockIdx.x == 0) {
		__shared__ uint64_t *l;
		if (threadIdx.x == 0) {
			l = new uint64_t[size - 1];
		}
		copyTabDev((*list), l, size - 1);
		*list = l;
	}
}

__host__ void resetIntList(Int_List_GPU **list) {
	while ((*list)->Size > 0) {
		removeLastInt(list);
	}
}

__device__ void resetIntListGPU(uint64_t **list, uint64_t size) {
	if (blockIdx.x == 0) {
		for (int i = 0; i < size; i++) {
			removeLastInt(list, size);
		}
	}
}

__host__ void printIntList(Int_List_GPU l) {
	printf("%i\n", l.Size);
	char* tmp = (char *) malloc (1000*sizeof(char));
	char *tmptmp = (char *) malloc (1000*sizeof(char));
	sprintf(tmp,"%s ","facteurs");
	for (int i = 0; i < l.Size; i++) {
		sprintf(tmptmp,"%lu ", getVal(l, i));
		strcat(tmp, tmptmp);
		sprintf(tmptmp,"%s", "");
	}
	printf("%s\n",tmp);
	free(tmptmp);
	free(tmp);
}

uint64_t produitDiv(Int_List_GPU Div) {
	uint64_t res = 1;
	for (int i = 0; i < Div.Size; i++) {
		res *= getVal(Div, i);
	}
	return res;
}

int notIn(Int_List_GPU Div, uint64_t val) {
	for (int i = 0; i < Div.Size; i++) {
		if (getVal(Div, i) == val) {
			return 1;
		}
	}
	return 0;
}

Int_List_GPU *mergeDiv(Int_List_GPU *src1, Int_List_GPU *src2) {
	Int_List_GPU *result = createIntList();
	for (int i = 0; i < src1->Size; i++) {
		addInt(&result, src1->List[i]);
	}
	for (int i = 0; i < src2->Size; i++) {
		addInt(&result, src2->List[i]);
	}
	free(src1);
	free(src2);
	return result;
}
