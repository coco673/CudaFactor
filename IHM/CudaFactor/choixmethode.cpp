#include "choixmethode.h"

ChoixMethode::ChoixMethode(ModelChoixMethode *m)
{
    model = m;
    setStyleSheet("background-color: orange;");

    //Taille de la fenetre
    setFixedSize(800, 600);

    // Construction des boutons

    cudaButton = new QPushButton("CUDA", this);
    sageButton = new QPushButton("SAGE", this);

    cudaButton->setFixedSize(100, 100);
    cudaButton->move(175, 250);
    cudaButton->setCursor(Qt::PointingHandCursor);
    cudaButton->raise(); //au premier plan
    cudaButton->setStyleSheet("background-color: white; border: 5px solid white");

    sageButton->setFixedSize(100, 100);
    sageButton->move(525, 250);
    sageButton->setCursor(Qt::PointingHandCursor);
    sageButton->raise(); //au premier plan
    sageButton->setStyleSheet("background-color: white; border: 5px solid white");

    //Connection SLOTS-SIGNAUX
    QObject::connect(cudaButton, SIGNAL(clicked()), this, SLOT(pressCUDA()));
    QObject::connect(sageButton, SIGNAL(clicked()), this, SLOT(pressSAGE()));

}

void ChoixMethode::pressCUDA() {
    model->setMethode(CUDA);
    sageButton->setStyleSheet("background-color: white; border: 5px solid white");
    cudaButton->setStyleSheet("background-color: white; border: 5px solid red");
}

void ChoixMethode::pressSAGE() {
    model->setMethode(SAGE);
    cudaButton->setStyleSheet("background-color: white; border: 5px solid white");
    sageButton->setStyleSheet("background-color: white; border: 5px solid red");
}
