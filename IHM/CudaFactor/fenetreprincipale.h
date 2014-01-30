#ifndef FENETREPRINCIPALE_H
#define FENETREPRINCIPALE_H

#include <QApplication>
#include <QtGui>
#include <QFrame>
#include <QPushButton>

class FenetrePrincipale : public QWidget // On hérite de QWidget (IMPORTANT)
{
    Q_OBJECT

public:
    FenetrePrincipale();

private slots:
    void next();
    void prev();

private:
    QPushButton * suivant;
    QPushButton * precedent;
    QFrame * frame;
    int page;

};

#endif // FENETREPRINCIPALE_H
