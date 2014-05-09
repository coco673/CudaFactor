#include "choixmethode.h"
#include <QTextStream>

// Initialisation de la Frame
ChoixMethode::ChoixMethode(Model *m, ModelFenPrinc *mfp)
{
    model = m;
    modelFen = mfp;

    setStyleSheet("background-color: rgb(1,74,111);");

    //Taille de la fenetre
    //setMinimumSize(800, 600);

    // Construction du Label
    label = new QLabel("Choix de la methode d'execution", this);
    label->move(40, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");
    // Construction des boutons

    cudaIcon = new QIcon("images/boutonCUDA.png");
    sageIcon = new QIcon("images/boutonSAGE.png");

    cudaButton = new QPushButton(this);
    sageButton = new QPushButton(this);

    model->setMethode(CUDA);

    cudaButton->setFixedSize(190, 150);
    cudaButton->move(171, 250);
    cudaButton->setCursor(Qt::PointingHandCursor);
    cudaButton->raise(); //au premier plan
    cudaButton->setStyleSheet("border-radius: 10px;");
    cudaButton->setIcon(*cudaIcon);
    cudaButton->setIconSize(QSize(190, 150));

    sageButton->setFixedSize(190, 150);
    sageButton->move(439, 250);
    sageButton->setCursor(Qt::PointingHandCursor);
    sageButton->raise(); //au premier plan
    sageButton->setStyleSheet("border-radius: 10px;");
    sageButton->setIcon(*sageIcon);
    sageButton->setIconSize(QSize(190, 150));

    //Connection SLOTS-SIGNAUX
    QObject::connect(cudaButton, SIGNAL(clicked()), this, SLOT(pressCUDA()));
    QObject::connect(sageButton, SIGNAL(clicked()), this, SLOT(pressSAGE()));

}

//Réinitialisation de la frame
void ChoixMethode::actualiser() {

}

//Actualisation de la frame après qu'elle soit show
void ChoixMethode::actualiseApresAffichage() {

}

//Verifie la validité des éléments mais inutile dans cette frame
void ChoixMethode::check() {

}

//Bouton suivant affiché ou non
bool ChoixMethode::boutonSuivant() {
    return false;
}

//Execution lorsque le bouton CUDA est pressé
void ChoixMethode::pressCUDA() {
    model->setMethode(CUDA);
    modelFen->next();
}

//Execution lorsque le bouton SAGE est pressé
void ChoixMethode::pressSAGE() {
    model->setMethode(SAGE);
    printf("set methode : SAGE %d\n",SAGE);
    modelFen->next();
}
