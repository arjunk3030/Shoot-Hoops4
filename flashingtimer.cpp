#include "flashingtimer.h"
#include <stdlib.h>
#include <time.h>
#include <QDateTime>
#include <string>
#include <sstream>
#include <QDebug>
FlashingTimer::FlashingTimer(QDateTime tomorrow1,QObject *parent)
    :QObject(parent), tomorrow(tomorrow1),timer(new QTimer(this)),difference(0),m_whatToPrint("Getting ready..."){
    //fix tomorrow
    QDateTime now1 = QDateTime::currentDateTime();
    if(tomorrow<now1){
        while(tomorrow<now1)
            tomorrow=tomorrow.addSecs(86399);
        emit callUpdateMissions();
    }
    //Intialize the timer
    srand(time(NULL));
    connect(timer,&QTimer::timeout, [=](){
        QDateTime now = QDateTime::currentDateTime();
        difference = now.secsTo(tomorrow);
        display();
        if(difference == 0){
            tomorrow=tomorrow.addSecs(86399);
            emit callUpdateMissions();
        }
    });

    timer->start(1000);
}

QString FlashingTimer::whatToPrint() const
{
    return m_whatToPrint;
}

void FlashingTimer::setWhatToPrint(QString whatToPrint)
{
    if (m_whatToPrint == whatToPrint)
        return;

    m_whatToPrint = whatToPrint;
    emit whatToPrintChanged(m_whatToPrint);
};

void FlashingTimer::display(){
    int differenceC = difference;
    int seconds = differenceC%60;
    differenceC/=60;
    int minutes = differenceC%60;
    differenceC/=60;
    int hours = differenceC%24;
    QString x = "";
    if(hours<10)
        x="0";
    x+=QString::number(hours)+":";
    if(minutes<10)
        x+="0";
    x+=QString::number(minutes)+":";
    if(seconds<10)
        x+="0";
    x+=QString::number(seconds);
    setWhatToPrint(x);
}

FlashingTimer::FlashingTimer(const FlashingTimer &source)
    :QObject{nullptr},tomorrow{source.tomorrow}{
}

FlashingTimer &FlashingTimer::operator=(const FlashingTimer &rhs){
    if(this==&rhs)
        return *this;
    tomorrow=rhs.tomorrow;
    return *this;
}
