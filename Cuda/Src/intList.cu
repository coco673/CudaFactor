#include "header/intList.h"

/*
__device__ __host__ Int_List *createIntList() {
	Int_List *list = (Int_List *) malloc(sizeof(Int_List));
	list->list = NULL;
	list->size = 0;
	return list;
}

__device__ __host__ void addInt(Int_List *list, int c) {
	if (list->size == 0) {
		list->list = (struct IL*) malloc(sizeof(struct IL));
		list->list->val = c;
		list->list->suiv = NULL;
	} else {
		struct IL *cl = (struct IL*) malloc(sizeof(struct IL));
		cl->val = c;
		cl->suiv = list->list;
		list->list = cl;
	}
	list->size++;
}

__device__ __host__ int getVal(const Int_List list, int index) {
	int i = 0;
	Int_List tmp = list;
	if (index > list.size - 1 || index < 0) {
		return -1;
	} else {
		while (i != index) {
			tmp.list = tmp.list->suiv;
			i++;
		}
		return tmp.list->val;
	}
}

__device__ __host__ void removeLastInt(Int_List *list) {
	if (list->size != 0) {
		struct IL *ptr;
		ptr = list->list;
		while (ptr->suiv != NULL) {
			if (ptr->suiv->suiv == NULL) {
				struct IL *tmp;
				tmp = ptr;
				ptr = ptr->suiv;
				tmp->suiv = NULL;
			} else {
				ptr = ptr->suiv;
			}
		}
		free(ptr);
		list->size--;
	}
}

__device__ __host__ void resetIntList(Int_List *list) {
	while (list->size != 0) {
		removeLastInt(list);
	}
}

void printIntList(const Int_List list) {
	printf("Taille de la liste : %i\n", list.size);
	for (int i = 0; i < list.size; i++) {
		printf("val : %i\n", getVal(list, i));
	}
}
*/

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
		//delete(list);
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
	//delete(list->List);
	//delete(list);
	*list = l;
}

__device__ void removeLastInt(uint64_t **list, uint64_t size) {
	if (blockIdx.x == 0) {
		__shared__ uint64_t *l;
		if (threadIdx.x == 0) {
			l = new uint64_t[size - 1];
		}
		copyTabDev((*list), l, size - 1);
		//delete(list);
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
		//printf("valeur : %ld\n", getVal(l, i));
		sprintf(tmptmp," %llu", getVal(l, i));
		strcat(tmp, tmptmp);
		sprintf(tmptmp,"%s", "");
	}
	printf("%s\n",tmp);
	free(tmptmp);
	free(tmp);
}
