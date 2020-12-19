#include "mytimer.h"
#include <QDebug>
#include <stdlib.h>
#include <time.h>
#include <QDateTime>
#include <string>
#include <sstream>
MyTimer::MyTimer(QObject *parent, int interval1) : QObject(parent), m_timer(new QTimer(this)), m_running(false)
{
    m_original = interval1;
    if (m_original<0){
        m_original=m_original-m_original*2;
    }
    srand(time(NULL));

    m_timer->setSingleShot(true);

}

int MyTimer::original() const
{
    return m_original;
}

int MyTimer::elapsed() const
{
    return m_elapsed;
}

void MyTimer::start()
{
    m_running=true;
    if(m_elapsed==0||m_elapsed>m_original){
        m_timer->setInterval(m_original);
    }
    else{
        m_timer->setInterval(m_original-m_elapsed);
    }
    m_elapsed=0;
    m_timer->start();
    connect(m_timer,&QTimer::timeout, [=](){
        if(m_elapsed==0){
            emit timedOut();
            m_running=false;
        }
    });
}

void MyTimer::pause()
{
    m_running=false;
    m_elapsed=m_original - m_timer->remainingTime();
    connect(m_timer,&QTimer::timeout, [=](){
        if(m_elapsed==0){
            emit timedOut();
            m_running=false;
        }
    });
}

void MyTimer::restart()
{
    m_running=true;
    m_elapsed=0;
    m_timer->start();
    connect(m_timer,&QTimer::timeout, [=](){
        if(m_elapsed==0){
            emit timedOut();
            m_running=false;
        }
    });
}

void MyTimer::setRunning(bool running)
{
    if (m_running == running)
        return;

    m_running = running;
    emit runningChanged(m_running);
}

void MyTimer::setOriginal(int original)
{
    if (m_original == original)
        return;

    m_original = original;
    m_timer->setInterval(m_original);
    emit originalChanged(m_original);
}

void MyTimer::setElapsed(int elapsed)
{
    if (m_elapsed == elapsed)
        return;

    m_elapsed = elapsed;
    emit elapsedChanged(m_elapsed);
}

bool MyTimer::running() const
{
    return m_running;
}
