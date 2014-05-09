#include "attente.h"

#include <sstream>
#include <QTextStream>
#include <iomanip>
#include <QApplication>

// Initialisation de la Frame
Attente::Attente(Model *m)
{
    model = m;

    boolBoutonSuiv = false;

    label = new QLabel("Execution", this);
    label->move(290, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");

    // Bouton de lancement de l'execution
    execButton = new QPushButton(this);
    execButton->setFixedSize(250, 50);
    execButton->move(260, 500);
    execButton->setCursor(Qt::PointingHandCursor);
    execButton->setText("Lancer l'execution");

    text = new QTextEdit(this);

    text->setFixedSize(750, 300);
    text->setReadOnly(true);
    text->move(25, 135);
    text->setStyleSheet("background-color: white; border: 2px solid gray");

    setStyleSheet("background-color: rgb(1,74,111);");

    QObject::connect(execButton, SIGNAL(clicked()), this, SLOT(lancerExec()));
}

//Réinitialisation de la frame
void Attente::actualiser() {
    text->clear();
}

//Actualisation de la frame après qu'elle soit show
void Attente::actualiseApresAffichage() {

}

//Lance l'execution de l'algorithme
void Attente::lancerExec() {
    text->clear();
    boolBoutonSuiv = false;
    if (model->getMethode() == SAGE) {
        execSAGE();
    } else if (model->getMethode() == CUDA) {
        execCUDA();
    }
    boolBoutonSuiv = true;
}

//Lance l'algorithme sous Sage
void Attente::execSAGE() {
    FILE * sage_output;
    std::ostringstream strs;
    int pres = 2000;
    strs << std::setprecision(pres) << model->getNombre();
    std::string stest = strs.str();
    std::string cmds = "sage ../Sage/dixon14.sage ";
    printf("%s\n",getenv("PWD"));
    char boom [50];
    strcpy(boom, cmds.c_str());
    char booom [25];
    strcpy(booom, stest.c_str());
    strcat(boom,booom);
    sage_output = popen(boom,"r");
    int MAXLEN = 100;
    char *ret_str = (char*)malloc((MAXLEN+1)*sizeof(char));
    int line_count = 0;
    char *tmp;
    int nbFact = 0;
    long fact;
    char *tab = new char[100];
    while(fgets(ret_str,MAXLEN+1,sage_output) != NULL){
        tmp = (char*)malloc((MAXLEN+1)*sizeof(char));
        strncpy(tmp,ret_str,MAXLEN+1);
        text->append(tmp);
        switch (line_count) {
        case 0: // nombre
            {
                break;
            }

        case 1 : //nbFacteurs
            {
                QString s(tmp);
                bool ok;
                nbFact = s.toInt(&ok,10);
                break;
            }
        case 2: // facteurs
            {
                 QList<mpz_class> l;
                 tab = strsep(&tmp," ");
                 tab = strsep(&tmp," ");
                 for (int j = 0; j < nbFact; j++) {
                     QString s(tab);
                     bool ok;
                     fact = s.toLongLong(&ok,10);
                     l.append(fact);
                     tab = strsep(&tmp," ");
                 }
                 model->setListFacteursPremiers(l);
                 break;
            }
        case 3 : //temps d'exécution
            {
                tab = strsep(&tmp, " ");
                QString s(tmp);
                bool ok;
                model->setTempsExecution(s.toDouble(&ok));
                tmp = NULL;
                break;
            }

        default:
            break;
        }

        text->repaint();
        line_count++;
    }
    pclose(sage_output);
    free(ret_str);
    free(tmp);
}

//Lance algorithme sous Cuda
void Attente::execCUDA() {
   // std::stringstream strs;
    FILE * cuda_output;
    std::ostringstream strs;
    int pres = 2000;
    strs << std::setprecision(pres) << model->getNombre();
    std::string stest = strs.str();
    std::string cmds = " ../Cuda/Debug/CudaFactor ";
    char boom [50];
    strcpy(boom, cmds.c_str());
    char booom [25];
    strcpy(booom, stest.c_str());
    strcat(boom,booom);
    cuda_output = popen(boom,"r");
    int MAXLEN = 100;
    char *ret_str = (char*)malloc((MAXLEN+1)*sizeof(char));
    int line_count = 0;
    char *tmp;
    int nbFact = 0;
    long fact;
    char *tab = new char[100];
    while(fgets(ret_str,MAXLEN+1,cuda_output) != NULL){
        tmp = (char*)malloc((MAXLEN+1)*sizeof(char));
        strncpy(tmp,ret_str,MAXLEN+1);
        text->append(tmp);
        switch (line_count) {
        case 0: // nombre
            {
                break;
            }
        case 1 : //nbFacteurs
            {
                QString s(tmp);
                bool ok;
                nbFact = s.toInt(&ok,10);
                break;
            }
        case 2: // facteurs
            {
                 QList<mpz_class> l;

                 tab = strsep(&tmp," ");
                 tab = strsep(&tmp," ");
                 for (int j = 0; j < nbFact; j++) {
                     QString s(tab);
                     bool ok;
                     fact = s.toLongLong(&ok,10);
                     l.append(fact);
                     tab = strsep(&tmp," ");
                 }
                 model->setListFacteursPremiers(l);
                 break;
            }
        case 3 : //temps d'exécution
            {
                tab = strsep(&tmp, " ");
                QString s(tmp);
                bool ok;
                model->setTempsExecution(s.toDouble(&ok));
                tmp = NULL;
                break;
            }

        default:
            break;
        }

        text->repaint();
        line_count++;
    }
    pclose(cuda_output);
    free(ret_str);
    free(tmp);
}

//Verifie la validité des éléments mais inutile dans cette frame
void Attente::check() {

}

//Bouton suivant affiché ou non
bool Attente::boutonSuivant() {
    //return boolBoutonSuiv;
    return true;
}
