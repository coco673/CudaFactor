/****************************************************************************
** Meta object code from reading C++ file 'fenetreprincipale.h'
**
** Created: Tue Apr 8 14:47:38 2014
**      by: The Qt Meta Object Compiler version 63 (Qt 4.8.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../fenetreprincipale.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'fenetreprincipale.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_FenetrePrincipale[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      19,   18,   18,   18, 0x0a,
      26,   18,   18,   18, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_FenetrePrincipale[] = {
    "FenetrePrincipale\0\0next()\0prev()\0"
};

void FenetrePrincipale::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        FenetrePrincipale *_t = static_cast<FenetrePrincipale *>(_o);
        switch (_id) {
        case 0: _t->next(); break;
        case 1: _t->prev(); break;
        default: ;
        }
    }
    Q_UNUSED(_a);
}

const QMetaObjectExtraData FenetrePrincipale::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject FenetrePrincipale::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_FenetrePrincipale,
      qt_meta_data_FenetrePrincipale, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &FenetrePrincipale::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *FenetrePrincipale::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *FenetrePrincipale::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_FenetrePrincipale))
        return static_cast<void*>(const_cast< FenetrePrincipale*>(this));
    return QWidget::qt_metacast(_clname);
}

int FenetrePrincipale::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
