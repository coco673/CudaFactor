#ifndef ATTENTE_H
#define ATTENTE_H

#include "model.h"
#include <QFrame>
#include <QLabel>
#include <QXmlStreamWriter>

class Attente: public QFrame
{
public:
    Attente(Model *m);
    void actualiser();
    void creerXml();

private:
    Model * model;
    QLabel * label;
    QString fileName;

};

#endif // ATTENTE_H
