/*
 * Frame permettant à l'utilisateur de comparer deux rapports
 */

#ifndef COMPARAISONXML_H
#define COMPARAISONXML_H

#include "model.h"
#include "Frame.h"
#include "modelcomparaison.h"
#include <QtCore>
#include <QTextEdit>
#include <QLabel>
#include <QPushButton>

class comparaisonXml: public Frame
{
    Q_OBJECT

public:
    comparaisonXml(modelComparaison* m);
    void actualiser();
    bool boutonSuivant();
    void check();
    void actualiseApresAffichage();

public slots:
    void ouvrirFichier1();
    void ouvrirFichier2();

private:
    bool isComparable();
    void comparaison();
    void remplirText1();
    void remplirText2();
    void lecturefichierXML1();
    void lecturefichierXML2();
    QPushButton* boutonOpen1;
    QPushButton* boutonOpen2;
    QTextEdit* text1;
    QTextEdit* text2;
    QLabel * label;
    modelComparaison* modelComp;
    QString methode1;
    QString nombre1;
    QList<QString> listFacteursPremiers1;
    QString temps1;
    QString methode2;
    QString nombre2;
    QList<QString> listFacteursPremiers2;
    QString temps2;

};

#endif // COMPARAISONXML_H
