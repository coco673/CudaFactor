#include "fenetreprincipale.h"
#include <QApplication>
#include <iostream>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QString path = QDir::currentPath();
    path.append("/IHM/");
    QDir::setCurrent(path);

    FenetrePrincipale w;
    w.show();

    return a.exec();
}
