#include "fenetreprincipale.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QDir::setCurrent(QDir::currentPath());
    FenetrePrincipale w;
    w.show();

    return a.exec();
}
