#include "fenetreprincipale.h"
#include <QApplication>
#include <iostream>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QString path = QDir::currentPath(); //Permet d'obtenir le chemin courant de l'exécutable
    path.append("/IHM/");
    QDir::setCurrent(path);//Initialise le chemin relatif au paramètre path

    FenetrePrincipale w;
    w.show();

    return a.exec();
}
