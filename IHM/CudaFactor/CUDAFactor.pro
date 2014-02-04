#-------------------------------------------------
#
# Project created by QtCreator 2014-02-04T11:54:19
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CUDAFactor
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    fenetreprincipale.cpp \
    model.cpp \
    choixnombre.cpp \
    modelchoixnombre.cpp \
    choixmethode.cpp \
    modelchoixmethode.cpp \
    attente.cpp \
    modelattente.cpp \
    resultat.cpp \
    modelresultat.cpp

HEADERS  += mainwindow.h \
    fenetreprincipale.h \
    model.h \
    choixnombre.h \
    modelchoixnombre.h \
    choixmethode.h \
    modelchoixmethode.h \
    attente.h \
    modelattente.h \
    resultat.h \
    modelresultat.h

FORMS    += mainwindow.ui
