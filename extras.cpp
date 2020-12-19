#include "extras.h"
#include <QDebug>
Extras::Extras(QObject *parent) : QObject(parent), m_volume(0.0), m_isOpen(false), m_numCoins(5),
    m_ballSource("file:///Users/arjun/Documents/All_Qt_Projects/Qt Quick/Qt Fundamentals Udemy Course/10-6AnimationDemo/images/basket_ball.png"),m_personalBest(0), m_datastore(""), m_miniStore(""), m_myMissionsRn(""), m_endingPage(""), m_sound(0.0)
{

}

double Extras::volume() const
{
    return m_volume;
}
void Extras::setVolume(double volume)
{
    if (m_volume == volume)
        return;

    m_volume = volume;

    emit volumeChanged(m_volume);
}


bool Extras::isOpen() const
{
    return m_isOpen;
}
void Extras::setIsOpen(bool isOpen)
{
    if (m_isOpen == isOpen)
        return;

    m_isOpen = isOpen;
    emit isOpenChanged(m_isOpen);
}


int Extras::numCoins() const
{
    return m_numCoins;
}
void Extras::setNumCoins(int numCoins)
{
    if (m_numCoins == numCoins)
        return;

    m_numCoins = numCoins;
    emit numCoinsChanged(m_numCoins);
}


QString Extras::ballSource() const
{
    return m_ballSource;
}
void Extras::setBallSource(QString ballSource)
{
    if (m_ballSource == ballSource)
        return;

    m_ballSource = ballSource;
    emit ballSourceChanged(m_ballSource);
}


int Extras::personalBest() const
{
    return m_personalBest;
}
void Extras::setPersonalBest(int personalBest)
{
    if (m_personalBest == personalBest)
        return;

    m_personalBest = personalBest;
    emit personalBestChanged(m_personalBest);
}


QString Extras::datastore() const
{
    return m_datastore;
}
void Extras::setDatastore(QString datastore)
{
    if (m_datastore == datastore)
        return;

    m_datastore = datastore;
    emit datastoreChanged(m_datastore);
}


QString Extras::miniStore() const
{
    return m_miniStore;
}
void Extras::setMiniStore(QString miniStore)
{
    if (m_miniStore == miniStore)
        return;

    m_miniStore = miniStore;
    emit miniStoreChanged(m_miniStore);
}

QString Extras::myMissionsRn() const
{
    return m_myMissionsRn;
}

void Extras::setMyMissionsRn(QString myMissionsRn)
{
    if (m_myMissionsRn == myMissionsRn)
        return;
    
    m_myMissionsRn = myMissionsRn;
    emit myMissionsRnChanged(m_myMissionsRn);
}

//no uso
void Extras::emittingSwitchFilesSignal(){
    emit somethingCompetitiveChanged();
}
void Extras::emittingSpaceInCompSignal(){
    emit spaceClickedInComp();
}
void Extras::emittingSpaceInCustSignal(){
    emit spaceClickedInComp();
}
void Extras::emittingGoToHalftimeSignal(){
    emit goToHalftime();
}
void Extras::emittingGoBackFromHalftimeSignal(int points1=0){
    emit goBackFromHalftime(points1);
}
//void Extras::emittingChaosSliderNeedsChange(){
//    emit chaosSliderNeedsChange();
//}
double Extras::sound() const
{
    return m_sound;
}

void Extras::setSound(double sound)
{
    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(m_sound, sound))
        return;

    m_sound = sound;
    emit soundChanged(m_sound);
}

QString Extras::endingPage() const
{
    return m_endingPage;
}

void Extras::setEndingPage(QString endingPage)
{
    if (m_endingPage == endingPage)
        return;

    m_endingPage = endingPage;
    emit endingPageChanged(m_endingPage);
}
