#include <QApplication>
#include "fenetreprincipale.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    FenetrePrincipale w;
    w.show();

    return app.exec();
}
