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

    // Bouton de lancement de l'execution
    execButton = new QPushButton(this);
    execButton->setFixedSize(250, 50);
    execButton->move(260, 500);
    execButton->setCursor(Qt::PointingHandCursor);
    execButton->setText("Lancer l'exécution");
    execButton->setIconSize(QSize(100, 100));

    text = new QTextEdit(this);

    text->setFixedSize(750, 300);
    text->setReadOnly(true);
    text->move(25, 135);
    text->setStyleSheet("background-color: white; border: 2px solid gray");

    setStyleSheet("background-color: rgb(1,74,111);");

    QObject::connect(execButton, SIGNAL(clicked()), this, SLOT(lancerExec()));
}

void Attente::actualiser() {
    text->clear();
}

void Attente::actualiseApresAffichage() {

}
void Attente::lancerExec() {
    printf("execution\n");
    text->clear();
    boolBoutonSuiv = false;
    printf("methode : %d\n", model->getMethode());
    if (model->getMethode() == SAGE) {
        printf("methode == SAGE\n");
        execSAGE();
    } else if (model->getMethode() == CUDA) {
        printf("methode == CUDA\n");
        execCUDA();
    }
    boolBoutonSuiv = true;
    printf("fin execution\n");
}

void Attente::execSAGE() {
    printf("ici\n");
   // std::stringstream strs;
    FILE * sage_output;
    std::ostringstream strs;
    int pres = 2000;
    strs << std::setprecision(pres) << model->getNombre();
    std::string stest = strs.str();
    std::string cmds = "sage ../../Sage/dixon14.sage ";
    char boom [50];
    strcpy(boom, cmds.c_str());
    char booom [25];
    strcpy(booom, stest.c_str());
    strcat(boom,booom);
    printf("commande popen : %s\n",boom);
    sage_output = popen(boom,"r");
    printf("après popen\n");
    int MAXLEN = 100;
    char *ret_str = (char*)malloc((MAXLEN+1)*sizeof(char));
    int line_count = 0;
    char *tmp;
    int nbFact = 0;
    long fact;
    char *tab = new char[100];
    while(fgets(ret_str,MAXLEN+1,sage_output) != NULL){
        printf("hello\n");
        tmp = (char*)malloc((MAXLEN+1)*sizeof(char));
        printf("ret_str debut while fgets = %s\n",ret_str);
        strncpy(tmp,ret_str,MAXLEN+1);
        //strcpy(tmp, ret_str);
        printf("tmp debut while fgets = %s\n",tmp);
        text->append(tmp);
        switch (line_count) {
        case 0: // nombre
            {
                printf("tmp debut case 0 = %s\n",tmp);
                break;
            }

        case 1 : //nbFacteurs
            {
                printf("tmp debut case 1 = %s\n",tmp);
                QString s(tmp);
                bool ok;
                nbFact = s.toInt(&ok,10);
                break;
            }
        case 2: // facteurs
            {
                 QList<long double> l;
                 printf("tmp debut case 2 = %s\n",tmp);
                 tab = strsep(&tmp," ");
                 tab = strsep(&tmp," ");
                 for (int j = 0; j < nbFact; j++) {
                     printf("tab debut while : %s \t \n",tab);
                     QString s(tab);
                     bool ok;
                     fact = s.toLongLong(&ok,10);
                     printf("facteur : %ld\n",fact);
                     l.append(fact);
                     tab = strsep(&tmp," ");
                     printf("tmp fin while : %s \t \n",tmp);
                 }
                 model->setListFacteursPremiers(l);
                 printf("fin case 2 %s\n",tmp);
                 break;
            }
        case 3 : //temps d'exécution
            {
                printf("tmp debut case 3 = %s\n",tmp);
                tab = strsep(&tmp, " ");
                printf("tab1 case 3 = %s\n",tab);
                printf("tmp1 case 3 = %s\n",tmp);
                //tab = strsep(&tmp, " ");
                //printf("tab2 case 3 = %s\n",tab);
                QString s(tmp);
                bool ok;
                model->setTempsExecution(s.toDouble(&ok));
                printf("temps : %f\n",model->getTempsExecution());
                tmp = NULL;
                break;
            }

        default:
            printf("default\n");
            break;
        }

        text->repaint();
        line_count++;
        printf("linecount %i\n", line_count);
        printf("ret_str fin while fgets = %s\n",ret_str);
        printf("tmp fin while fgets = %s\n",tmp);
    }
    pclose(sage_output);
    free(ret_str);
    free(tmp);
}

void Attente::execCUDA() {
    printf("ici\n");
   // std::stringstream strs;
    FILE * cuda_output;
    std::ostringstream strs;
    int pres = 2000;
    strs << std::setprecision(pres) << model->getNombre();
    std::string stest = strs.str();
    std::string cmds = "../../Cuda/Debug/CudaFactor ";
    char boom [50];
    strcpy(boom, cmds.c_str());
    char booom [25];
    strcpy(booom, stest.c_str());
    strcat(boom,booom);
    printf("commande popen : %s\n",boom);
    cuda_output = popen(boom,"r");
    printf("après popen\n");
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
                printf("tmp debut case 0 = %s\n",tmp);
                break;
            }
        case 1 : //nbFacteurs
            {
                printf("tmp debut case 1 = %s\n",tmp);
                QString s(tmp);
                bool ok;
                nbFact = s.toInt(&ok,10);
                break;
            }
        case 2: // facteurs
            {
                 QList<long double> l;
                 printf("tmp debut case 2 = %s\n",tmp);

                 tab = strsep(&tmp," ");
                 tab = strsep(&tmp," ");
                 for (int j = 0; j < nbFact; j++) {
                     printf("tab debut while : %s \t \n",tab);
                     QString s(tab);
                     bool ok;
                     fact = s.toLongLong(&ok,10);
                     printf("facteur : %ld\n",fact);
                     l.append(fact);
                     tab = strsep(&tmp," ");
                     printf("tmp fin while : %s \t \n",tmp);
                 }
                 model->setListFacteursPremiers(l);
                 printf("fin case 2 %s\n",tmp);
                 break;
            }
        case 3 : //temps d'exécution
            {
                printf("tmp debut case 3 = %s\n",tmp);
                tab = strsep(&tmp, " ");
                printf("tab1 case 3 = %s\n",tab);
                printf("tmp1 case 3 = %s\n",tmp);
                //tab = strsep(&tmp, " ");
                //printf("tab2 case 3 = %s\n",tab);
                QString s(tmp);
                bool ok;
                model->setTempsExecution(s.toDouble(&ok));
                printf("temps CUDA : %f\n",model->getTempsExecution());
                tmp = NULL;
                break;
            }

        default:
            printf("default\n");
            break;
        }

        text->repaint();
        line_count++;
    }
    pclose(cuda_output);
    free(ret_str);
    free(tmp);
}


void Attente::check() {

}


bool Attente::boutonSuivant() {
    //return boolBoutonSuiv;
    return true;
}
