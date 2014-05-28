/*
 * Class dont toutes les frames héritent
 */

#ifndef FRAME_H
#define FRAME_H

#include <QFrame>

class Frame : public QFrame
{
  Q_OBJECT
public:
  virtual void actualiser() = 0;
  virtual void check() = 0;
  virtual bool boutonSuivant() = 0;
  virtual void actualiseApresAffichage() = 0;

};

#endif // FRAME_H
