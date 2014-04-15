#include "attente.h"

#include <sstream>
#include <QTextStream>
#include <iomanip>

Attente::Attente(Model *m)
{
    model = m;

    boolBoutonSuiv = false;

    label = new QLabel("Execution", this);
    label->move(290, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    text = new QTextEdit(this);

    text->setFixedSize(750, 300);
    text->setReadOnly(true);
    text->move(25, 135);
    text->setStyleSheet("background-color: white; border: 2px solid gray");

    setStyleSheet("background-color: rgb(1,74,111);");
}

void Attente::actualiser() {
    text->clear();
    boolBoutonSuiv = false;

    FILE * sage_output;
    std::ostringstream strs;
    int precision = 2000;
    strs << std::setprecision(precision) << model->getNombre();
    std::string stest = strs.str();
    //std::string cmds = "/home/etendard/Téléchargements/sage-6.1.1-x86_64-Linux/sage -sh; python /home/etendard/CudaFactor/IHM/CudaFactor/test.py ";
    std::string cmds = "python /home/etendard/CudaFactor/Sage/dixon.py ";
    char boom [50];
    strcpy(boom, cmds.c_str());
    char booom [25];
    strcpy(booom, stest.c_str());
    //strcat(boom,booom);
    printf("commande popen : %s\n",boom);
    sage_output = popen(boom,"r");
    printf("après popen\n");
    int MAXLEN=100;
    char ret_str[MAXLEN + 1];
    int line_count = 0;
    char tmp[1000];
    while(fgets(ret_str,MAXLEN+1,sage_output)!=NULL){
        line_count++;
        strcpy(tmp, ret_str);
        text->append(tmp);
        text->repaint();

    }
    pclose(sage_output);
}

void Attente::actualiseApresAffichage() {

}

void Attente::check() {

}


bool Attente::boutonSuivant() {
    return boolBoutonSuiv;
}
