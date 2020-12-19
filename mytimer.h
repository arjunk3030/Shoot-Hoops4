#ifndef MYTIMER_H
#define MYTIMER_H

#include <QObject>
#include <QTimer>
class MyTimer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int elapsed READ elapsed WRITE setElapsed NOTIFY elapsedChanged);
    Q_PROPERTY(int original READ original WRITE setOriginal NOTIFY originalChanged)
    Q_PROPERTY(bool running READ running WRITE setRunning NOTIFY runningChanged)

public:
    explicit MyTimer(QObject *parent = nullptr, int interval1=1000);
    QTimer* m_timer;
    int m_elapsed;
    int m_original;
    bool m_running;
    int original() const;
    void setOriginal(int original);

    int elapsed() const;
    void setElapsed(int elapsed);

    bool running() const;
    void setRunning(bool running);


public slots:
    void start();
    void pause();
    void restart();

signals:
    void elapsedChanged(int elapsed);
    void runningChanged(bool running);
    void originalChanged(int original);
//    void m_timerChanged(QTimer timer);
    void timedOut();
};

#endif // MYTIMER_H
