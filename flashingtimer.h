#ifndef FLASHINGTIMER_H
#define FLASHINGTIMER_H

#include <QObject>
#include <QTimer>
#include <QDateTime>
class FlashingTimer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString whatToPrint READ whatToPrint WRITE setWhatToPrint NOTIFY whatToPrintChanged)
public:
    explicit FlashingTimer(QDateTime tomorrow=QDateTime::currentDateTime(),QObject *parent=nullptr);
    QString whatToPrint() const;
    void setWhatToPrint(QString whatToPrint);
    void display();
    void setQmlRootObject(QObject *value);

    //copy contructor and copy assignment
    FlashingTimer(const FlashingTimer &source);
    FlashingTimer& operator=(const FlashingTimer &rhs);

private:
    QDateTime tomorrow;
    QTimer *timer;
    int difference;
    QString m_whatToPrint;

signals:
    void callUpdateMissions();
    void whatToPrintChanged(QString whatToPrint);
};

#endif // FLASHINGTIMER_H
