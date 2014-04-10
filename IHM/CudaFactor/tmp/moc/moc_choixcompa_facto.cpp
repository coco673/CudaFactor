/****************************************************************************
** Meta object code from reading C++ file 'choixcompa_facto.h'
**
** Created: Tue Apr 8 14:47:42 2014
**      by: The Qt Meta Object Compiler version 63 (Qt 4.8.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../choixcompa_facto.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'choixcompa_facto.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_choixCompa_facto[] = {

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
      18,   17,   17,   17, 0x0a,
      30,   17,   17,   17, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_choixCompa_facto[] = {
    "choixCompa_facto\0\0pressFact()\0pressComp()\0"
};

void choixCompa_facto::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        choixCompa_facto *_t = static_cast<choixCompa_facto *>(_o);
        switch (_id) {
        case 0: _t->pressFact(); break;
        case 1: _t->pressComp(); break;
        default: ;
        }
    }
    Q_UNUSED(_a);
}

const QMetaObjectExtraData choixCompa_facto::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject choixCompa_facto::staticMetaObject = {
    { &Frame::staticMetaObject, qt_meta_stringdata_choixCompa_facto,
      qt_meta_data_choixCompa_facto, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &choixCompa_facto::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *choixCompa_facto::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *choixCompa_facto::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_choixCompa_facto))
        return static_cast<void*>(const_cast< choixCompa_facto*>(this));
    return Frame::qt_metacast(_clname);
}

int choixCompa_facto::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = Frame::qt_metacall(_c, _id, _a);
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
