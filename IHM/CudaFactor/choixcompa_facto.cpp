#include "choixcompa_facto.h"

choixCompa_facto::choixCompa_facto(int* chx, ModelFenPrinc* m)
{
    chxCompFact = chx;
    model = m;

    setStyleSheet("background-color: rgb(1,74,111);");

    //Taille de la fenetre
    setFixedSize(800, 600);

    // Construction du Label
    label = new QLabel("CUDA Factor", this);
    label->move(250, 70);
    label->setStyleSheet("color: white; font-family:\"Arial\",Georgia,Serif; font-size: 50px;");
    // Construction des boutons

    FactIcon = new QIcon("images/boutonFactorisation.png");
    CompIcon = new QIcon("images/boutonComparaison.png");

    FactButton = new QPushButton(this);
    CompButton = new QPushButton(this);

    FactButton->setFixedSize(190, 150);
    FactButton->move(171, 250);
    FactButton->setCursor(Qt::PointingHandCursor);
    FactButton->raise(); //au premier plan
    FactButton->setStyleSheet("border-radius: 10px;");
    FactButton->setIcon(*FactIcon);
    FactButton->setIconSize(QSize(190, 150));

    CompButton->setFixedSize(190, 150);
    CompButton->move(439, 250);
    CompButton->setCursor(Qt::PointingHandCursor);
    CompButton->raise(); //au premier plan
    CompButton->setStyleSheet("border-radius: 10px;");
    CompButton->setIcon(*CompIcon);
    CompButton->setIconSize(QSize(190, 150));

    //Connection SLOTS-SIGNAUX
    QObject::connect(FactButton, SIGNAL(clicked()), this, SLOT(pressFact()));
    QObject::connect(CompButton, SIGNAL(clicked()), this, SLOT(pressComp()));

}

void choixCompa_facto::actualiser() {

}

void choixCompa_facto::check() {

}

bool choixCompa_facto::boutonSuivant() {
    return false;
}

void choixCompa_facto::pressFact() {
    *chxCompFact = factorisation;
    model->next();
}

void choixCompa_facto::pressComp() {
    *chxCompFact = Comparaison;
    model->next();
}
