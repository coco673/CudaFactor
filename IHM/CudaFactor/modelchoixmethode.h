#ifndef MODELCHOIXMETHODE_H
#define MODELCHOIXMETHODE_H


#define CUDA 0
#define SAGE 1

class ModelChoixMethode
{
public:
    ModelChoixMethode();
    int getMethode();
    void setMethode(int m);

private:
    int methode;

};

#endif // MODELCHOIXMETHODE_H
