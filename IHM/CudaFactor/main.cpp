#include <QApplication>
#include <QPushButton>
#include <QtGui>
#include <QFrame>
#include <list>
#include "mainwindow.h"


int main(int argc, char *argv[])
{
    using namespace std;
    QApplication app(argc, argv);

    // Création d'un widget qui servira de fenêtre
    QFrame frame;

    frame.setFixedSize(800, 600);

    // Affichage de la fenêtre
    frame.show();

    return app.exec();
}
