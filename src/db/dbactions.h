#ifndef DBACTIONS_H
#define DBACTIONS_H

#include <QObject>
#include "db.h"

class DBActions : public DB
{
        Q_OBJECT
    public:
        explicit DBActions(QObject *parent = nullptr);
        ~DBActions();

        PIX::DB_LIST getDBData(const QString &queryTxt);

        bool execQuery(const QString &queryTxt);

        void addPic(const PIX::DB &img);

        /* utils */
        Q_INVOKABLE QVariantList getFolders();
        Q_INVOKABLE QVariantList get(const QString &queryTxt);


};

#endif // DBACTIONS_H
