#ifndef ATTENTE_H
#define ATTENTE_H

#include "model.h"
#include <QFrame>
#include <QLabel>
#include <QXmlStreamWriter>
#include <QPushButton>

class Attente: public QFrame
{
    Q_OBJECT
public:
    Attente(Model *m);
    void actualiser();
    void creerXml();

public slots:
    void enregistrer();

private:
    Model * model;
    QLabel * label;
    QString fileName;
    QPushButton * sauvegarder;
    QIcon * icon;

};

#endif // ATTENTE_H
