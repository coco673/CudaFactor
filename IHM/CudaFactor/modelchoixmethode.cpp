#include "modelchoixmethode.h"

ModelChoixMethode::ModelChoixMethode()
{
    methode = CUDA;
}

int ModelChoixMethode::getMethode() {
    return methode;
}

void ModelChoixMethode::setMethode(int m) {
    methode = m;
}
