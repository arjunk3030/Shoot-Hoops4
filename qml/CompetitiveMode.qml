import Felgo 3.0
import QtQml.Models 2.2
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.0
import QtMultimedia 5.8
//import Qt.labs.qmlmodels 1.0
import QtQuick.Dialogs 1.2
import otherArjun2 1.2
Page {
    //do stuff in main yay
    function onGoToHalftime(){
        navigationStack.push(halftimeModeComponent)
    }
    function switchFileSignal(){
        navigationStack.pop()
        //starting timer
        thePauseTimer.start()
    }
    visible: true

    width: parent.width
    height: parent.height
    anchors.fill: parent
    title:"Game Mode"
    property int duration: 1000
    id: root2
    property bool isNewColor: false
    property var gradientGround1: "#00FF00"
    property var gradientGround2: "#00803F"
    property bool whatToDoWhenClicked: false
    property int counterr1 : 0;
    property var manyMisses : 0;
    property var manyMakes: 0;
    property var extraPoints: 0;
    property int level: 1
    property int levelIndicator: 1
    property var sliderEasingType: Easing.Linear
    property var firstTime: true;
    property var levelIndicatorDown:levelIndicatorSetter ()
    property var animationWhichIsRunning:1
    property var wasSecRunning: false;
    property var makingStreakColor: "red"
    property var colors: ["#cf3732","#db8d44","#e3d430","#29c910", "#e3d430", "#db8d44", "#cf3732"]
    property bool haveRandomlyChoosenIfCoinAppears: false;
    property int coinProb: 0;
    property int counterio: 0;
    property bool firstTime2: true
    property bool firstTime3: true
    property bool newRun: false;
    property var currentRandomOrder5: []
    property var currentIndexForRandom: 0;
    property var mIsOpen: Extra.isOpen
    property var coinsThisRound: 0
    property int beforeHalftimeScore: 0;
    //for going back after halftime
    property bool shouldStartThirdLevel: shouldBeginThirdLevel
    property bool adScreenHappeningHere: adScreenHappening
    property bool backButtonClickedWhenAdScreenHere: backButtonClickedWhenAdScreen
    property bool adUsed: false

    //easingThings
    property var mDuration: 1400
    property var mDurationEasy: -1
    property var mDurationMedium: -1
    property var mDurationHard: -1
    property var easyTypes: [Easing.BezierCurve, Easing.OutInBack, Easing.InQuad, Easing.OutQuad,Easing.InOutCubic, Easing.InCubic, Easing.InOutQuint, Easing.InSine, Easing.OutSine, Easing.OutInExpo, Easing.OutInCirc]
    property var mediumTypes: [Easing.OutInBounce, Easing.InOutBounce,Easing.OutCubic, Easing.InQuart, Easing.OutQuart, Easing.OutQuint, Easing.InExpo, Easing.InCirc,  Easing.OutCirc]
    property var hardTypes: [Easing.OutBounce, Easing.InBounce, Easing.OutElastic, Easing.OutBack, Easing.InBack]
    property bool scoresSaved: false; /* currently not used */
    function levelIndicatorSetter (){
        if(level==1)
            return 16-levelIndicator
        else if (level == 2)
            return 18 - levelIndicator
        else if (level==3)
            return 16-levelIndicator
        else if (level == 4)
            return 100-levelIndicator;
    }

    onBackButtonClickedWhenAdScreenHereChanged: {
        afterGameIsActuallyOver();
    }
    Connections{
        target: Extra
        function onGoBackFromHalftime(addedPoints){
            points+=addedPoints
            levelRectangleAnimation.start();
            dayNightStateRectId.state= "night"
            seqAnimationId.pause()
            handleId.visible=false;
        }
    }
    Component.onCompleted: {
        points=0;
    }
    Component.onDestruction: {
        afterGameIsActuallyOver();
    }

    //sound effects start here - coin clink
    Audio{
        id: coinClinkSoundEffect
        source:"../assets/sounds/coinSound.mp3"
        volume: root.sound*1
    }
    //for dynamic object creatin
    property  var component;
    property var sprite;

    function afterGameIsActuallyOver(){
        //this used to be above
        if(true){
            //7
            if(counter7>mMissionModel.get(7).currentThings&&!(mMissionModel.get(7).currentThings>=mMissionModel.get(7).neededThings)&&checkIfCurrentMission(7)){
                mMissionModel.get(7).currentThings=counter7
            }
            counter7=0;
            //8
            if(counter8>mMissionModel.get(8).currentThings&&!(mMissionModel.get(8).currentThings>=mMissionModel.get(8).neededThings)&&checkIfCurrentMission(8)){
                mMissionModel.get(8).currentThings=counter8
            }
            counter8=0;
            //10
            if(coinsThisRound===4){
                if(!(mMissionModel.get(10).currentThings>=mMissionModel.get(10).neededThings)&&checkIfCurrentMission(10)){
                    mMissionModel.get(10).currentThings++
                }
            }
            //
            if(coinsThisRound===0&&level===3){
                if(!(mMissionModel.get(11).currentThings>=mMissionModel.get(10).neededThings)&&checkIfCurrentMission(11)){
                    mMissionModel.get(11).currentThings++
                }
            }

            if(points>=mMissionModel.get(16).neededThings&&checkIfCurrentMission(16)){
                mMissionModel.get(16).currentThings=mMissionModel.get(16).neededThings
            }
            else if((points>mMissionModel.get(16).currentThings&&checkIfCurrentMission(16))){
                mMissionModel.get(16).currentThings=points
            }
            if (checkIfCurrentMission(14)&&!(mMissionModel.get(14).currentThings>=mMissionModel.get(14).neededThings)){
                let x = false
                for(let i = 0; i < counter14.length; i++){
                    if(ballSource===counter14[i]){
                        x=true;
                        break;
                    }
                }
                if(x===false){
                    counter14.push(ballSource);
                    if(counter14.length===mMissionModel.get(14).neededThings){
                        mMissionModel.get(14).currentThings=mMissionModel.get(14).neededThings
                    }
                    if(counter14.length>=mMissionModel.get(14).currentThings){
                        mMissionModel.get(14).currentThings=counter14.length
                    }
                }
            }
        }
        //if this doesnt work kick it
        if(true){
            if(counter0>mMissionModel.get(0)&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                mMissionModel.get(0).currentThings=(counter0>mMissionModel.get(0).neededThings)?mMissionModel.get(0).neededThings:counter0
            }
            if(counter1>mMissionModel.get(1)&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings)&&checkIfCurrentMission(1)){
                mMissionModel.get(1).currentThings=(counter1>mMissionModel.get(1).neededThings)?mMissionModel.get(1).neededThings:counter1
            }
            if(counter2>mMissionModel.get(2)&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                mMissionModel.get(2).currentThings=(counter2>mMissionModel.get(2).neededThings)?mMissionModel.get(2).neededThings:counter2
            }
            if(counter3>mMissionModel.get(3)&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                mMissionModel.get(3).currentThings=(counter3>mMissionModel.get(3).neededThings)?mMissionModel.get(3).neededThings:counter3
            }
            if(counter4>mMissionModel.get(4)&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)&&checkIfCurrentMission(4)){
                mMissionModel.get(4).currentThings=(counter4>mMissionModel.get(4).neededThings)?mMissionModel.get(4).neededThings:counter4
            }
            if(counter5>mMissionModel.get(5)&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)&&checkIfCurrentMission(5)){
                mMissionModel.get(5).currentThings=(counter5>mMissionModel.get(5).neededThings)?mMissionModel.get(5).neededThings:counter5
            }
            if(counter6>mMissionModel.get(6)&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                mMissionModel.get(6).currentThings=(counter6>mMissionModel.get(6).neededThings)?mMissionModel.get(6).neededThings:counter6
            }
            if(counter9>mMissionModel.get(9)&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                mMissionModel.get(9).currentThings=(counter9>mMissionModel.get(9).neededThings)?mMissionModel.get(9).neededThings:counter9
            }
            if(counter13>mMissionModel.get(13)&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                mMissionModel.get(13).currentThings=(counter13>mMissionModel.get(13).neededThings)?mMissionModel.get(13).neededThings:counter13
            }
        }
        if(true){
            //make all counters zero
            counter0= 0;
            counter1= 0;
            counter2= 0;
            counter3= 0;
            counter0= 0;
            counter0= 0;
            counter6= 0;
            counter7= 0;
            counter8= 0;
            counter9= 0;
            counter10= 0;
            counter11= 0;
            counter12= 0;
            counter13= 0;
            counterLast=0;
        }
        coinsThisRound=0;
        //Just resetting somethings
        feedbackLabel.visible = false;
        flashingScoreText.color="black"
        flashingScoreText.visible = false
        insideRectangleMouseArea.enabled = true; insideTheSliderRectangleMouseArea.enabled = true
        if(points>personalBest)
        {
            personalBest=points;
        }
        points = 0;
        level= 1;
        levelIndicator=0;
        extraPoints=0;
        manyMisses=0;
        manyMakes = 0;
        mDuration=1200
        sliderEasingType = Easing.Linear
        adUsed = false
        //used to be above ended
    }


    property bool mvpSoundEffectPlaying: false
    Audio{
        id: mvpSoundEffect
        source:"../assets/sounds/mvpSoundEffect.mp3"
        loops:Audio.Infinite
        volume: 0.0
        playbackRate: 1.2
        onPlaying:{
            if(volume===0.0){
                fadeIn.start();
                mvpSoundEffectPlaying= true
            }
            else{
                volume=0.0
            }
        }
    }
    //sound effects start here - fans cheering
    function whatToDoInsideRectangleMA(){
        //        if(!retryBox.visible){
        if((!newRetryCircle.visible&&!retryBox.visible)){
            if(stateRectId.state==="notPaused" && level!==3){
                if(!seqAnimationId.running&&!pointingFinger.visible){
                    seqAnimationId.start();
                    whatToDoWhenClicked=true
                }
                else{
                    seqAnimationId.stop();
                    insideContainerId.sliderStopped(sliderId.value);
                }
            }
            pointingFinger.visible=false;
            firstTime2=false;
        }
    }
    function checkIfCurrentMission(num){
        for(let i =0; i< 3; i++){
            if(presentMissions[i]==num){    //THIS WARNING IS INTENTIONAL DO NOT CHANGE THIS OR IT WILLLLLLL BREAK
                //THE CODE AND I WILL BE MAD EVEN THOUGH IT IS ME WHO IS READING THIS BUT I CAN BE MAD AT MYSELF
                return true;
            }
        }
        return false;
    }
    property var counter0: 0;
    property var counter1: 0;
    property var counter2: 0;
    property var counter3: 0;
    property var counter4: 0;
    property var counter5: 0;
    property var counter6: 0;
    property var counter7: 0;
    property var counter8: 0;
    property var counter9: 0;
    property var counter10: 0;
    property var counter11: 0;
    property var counter12: 0;
    property var counter13: 0;
    property var counterLast: 0;

    onMIsOpenChanged:{
        if(Extra.isOpen===false){
            if(stateRectId.state=="paused")
                whatToDoWhenDoubleClicked()
        }
        else{
            if(stateRectId.state!="paused")
                whatToDoWhenDoubleClicked()
        }
    }
    function newRandomColors3(){
        for(var i =0; i< 5; i++){
            let mArray = ["#cf3732","#cf3732","#db8d44","#db8d44","#e3d430","#e3d430","#29c910"]
            for(let i = mArray.length - 1; i > 0; i--){
                const j = Math.floor(Math.random() * i)
                const temp = mArray[i]
                mArray[i] = mArray[j]
                mArray[j] = temp
            }
            currentRandomOrder5.push(mArray);
        }
    }
    function figureOutShotWithColor(value){
        if(level!==3){
            return "null";
        }
        //red
        if(figureOutColor(value)==="#cf3732"){
            let random = Math.random()*3;
            if(random<=1)
                return "airball"
            else
                return "backboardMiss"
        }
        //orange
        else if(figureOutColor(value)==="#db8d44"){
            let random = Math.random()*7;
            if(random<=2)
                return "backboardMiss"
            else if(random<=6)
                return "rimMiss"
        }
        //yellow
        else if(figureOutColor(value)==="#e3d430"){
            let random = Math.random()*10;
            if(random<=5)
                return "backboardMake"
            else if(random<=9)
                return "rimMake"
        }
        //green
        else if(figureOutColor(value)==="#29c910"){
            let random = Math.random()*10;
            if(random<=1)
            {
                return "rimMake"
            }
            else if(random<=6)
            {
                return "splash"
            }
            else if(random<=9)
            {
                return "extraSplash"
            }
        }
    }
    function figureOutColor(value){
        if(value<142.9){
            return colors[0];
        }
        else if(value<285.8){
            return colors[1];
        }
        else if(value<428.7){
            return colors[2];
        }
        else if(value<571.5){
            return colors[3];
        }
        else if(value<714.4){
            return colors[4];
        }
        else if(value<857.2){
            return colors[5]
        }
        else{
            return colors[6]
        }
    }
    property var timerToCheck: [splashSoundEffectTimer, backboardMakeSoundEffectTimer, backboardMakeSoundEffectTimer2, backboardMissSoundEffectTimer,rimMissSoundEffectTimer,rimMissSoundEffectTimer2, rimMakeSoundEffectTimer, coinClinkSoundEffectForRimMakeTimer];
    property var theAudios: [/*mvpSoundEffect,*//*fansSoundEffect,*/splashSoundEffect, backboardMakeSoundEffect, backboardMakeSoundEffect2, backboardMissSoundEffect, rimMakeSoundEffect, rimMissSoundEffect, rimMissSoundEffect2, coinClinkSoundEffect]
    property var timersToReplay:[];
    property var animationsToCheck: [levelRectangleAnimation,airBallAnimation,splashAnimation,rimMakeAnimation,rimMissAnimation,backboardMissAnimation,backboardAnimation,coinAnim,mPauseAnim];
    property var animationsToReplay:[]
    function whatToDoWhenDoubleClicked(){
        function pauseAllAnim()
        {
            animationsToReplay=[]
            for (let k = 0; k< animationsToCheck.length; k++){
                if(animationsToCheck[k].running){
                    animationsToCheck[k].pause();
                    animationsToReplay.push(animationsToCheck[k])
                }
            }
            wasSecRunning=false;
            if(seqAnimationId.running){
                seqAnimationId.pause()
                wasSecRunning=true
            }
            //se
            timersToReplay=[]
            for (let q = 0; q< timerToCheck.length; q++){
                if(timerToCheck[q].running){
                    timerToCheck[q].pause();
                    timersToReplay.push(timerToCheck[q])
                }
            }
            for (let z = 0; z< theAudios.length; z++){
                if(theAudios[z].playbackState===Audio.PlayingState){
                    theAudios[z].pause();
                }
            }
        }
        function resumeAllAnim()
        {
            if(wasSecRunning)
                seqAnimationId.resume()
            for (let k = 0; k< animationsToReplay.length; k++){
                animationsToReplay[k].resume();
            }
            for (let q = 0; q< timersToReplay.length; q++){
                timersToReplay[q].start();
            }
            //se
            for (let z = 0; z< theAudios.length; z++){
                if(theAudios[z].playbackState===Audio.PausedState){
                    theAudios[z].play();
                }
            }

        }
        if(stateRectId.state==="notPaused")
        {
            stateRectId.state="paused"
            //mMusic1.play()
            pauseAllAnim();
        }
        else
        {
            if(!levelRectangleAnimationPause.running){
                stateRectId.state="notPaused"
                //mMusic1.play()
                resumeAllAnim();
            }
        }
    }
    //Pause button
    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(!newFadedRed.visible){
                if(levelRectangleAnimationPause.running)
                {
                    levelRectangleAnimationPause.complete()
                }
                else if(levelRectangleAnimation.running){
                    levelRectangleAnimation.complete()
                    levelRectangleAnimationPause.complete()
                }
                else {
                    whatToDoInsideRectangleMA()
                }
            }
        }

        onDoubleClicked:{
            whatToDoWhenDoubleClicked();
        }
    }
    //Pause state rectangle
    Rectangle{
        anchors.fill: parent
        id: pauseRectangle
        z: 100
        visible: true
        color: "#000000"
        opacity: 0.81
        anchors.centerIn: parent
        onVisibleChanged: {
            if(visible&&(retryBox.visible||newRetryCircle.visible)){
                visible=false
            }
        }

        Image{
            width: 552*4/5*1.45
            height: 452*4/5*1.45
            anchors.centerIn: parent
            source: "../assets/images/symbols/pause.png"
        }
    }
    onShouldStartThirdLevelChanged: {
        if(shouldStartThirdLevel===true){
            handleId.visible=false;
            whatToDoWhenAnimFinished.whatToDoForNextLevel();
            dayNightStateRectId.state= "night"
            sliderId.enabled=true;
            shouldBeginThirdLevel=false
        }
    }
    function checkIfSwitchNightToDay(){
        if(levelIndicator%15==0 && levelIndicator!=0){
            dayNightStateRectId.state = (dayNightStateRectId.state==="day")?"night":"day"
        }
    }

    property int easingNumber:-1;

    function whatToDoWhenAnimFinished()
    {
        //variable declaration
        haveRandomlyChoosenIfCoinAppears = false;
        //this is the random prob for the coin
        //function for what to do when going to next level
        function whatToDoForNextLevel()
        {
            level++;
            levelIndicator=0;
            tally1.visible =false; tally2.visible =false; tally3.visible =false;
            tally4.visible =false; tally5.visible =false; tally6.visible =false;
            tally7.visible =false; tally3.visible =false; tally8.visible =false;
            tally9.visible =false; tally10.visible =false; plus11.visible=false;
            x1.visible=false;
            x2.visible=false;
            x3.visible=false;
            feedbackLabel.text=""
            flashingScoreText.color = "black"
            insideRectangleMouseArea.enabled = true; insideTheSliderRectangleMouseArea.enabled = true
            manyMakes=0;
            manyMisses=0;
            levelRectangleAnimation.start();
            seqAnimationId.pause()
        }
        whatToDoWhenAnimFinished.whatToDoForNextLevel = whatToDoForNextLevel;
        //fix ball
        basketBall.width=140
        basketBall.height=140
        basketBall.y = root2.height-basketBall.height-50;
        basketBall.x=33;
        basketBall.rotation = 0

        //general check
        flashingScoreText.opacity=0;
        //        if(mvpSoundEffectPlaying){
        //            fadeOut.start();
        //            mvpSoundEffectPlaying=false
        //        }
        //Check if three misses- if game is over
        //If you lose it all...
        if(manyMisses==3)
        {
            if(seqAnimationId.running)
                seqAnimationId.pause()
            if(mPauseAnim.running)
                mPauseAnim.pause()
            sliderId.enabled=false;
            insideRectangleMouseArea.enabled=false
            insideTheSliderRectangleMouseArea.enabled=false
            //            retryBox.visible= true;
            if(!adUsed&&numCoins>10)
                newRetryCircle.visible=true
            //            fadedRED.visible=true;
            else{
                retryBox.visible=true
            }

            newFadedRed.visible=true
            adScreenHappening=true;
            return;
            // mMusic1.stop()
        }
        //General thing to do if MAKE for AFTER THE ANIMATION IS FINISHED
        if(manyMakes>0){
            //            if(manyMakes>=10&&manyMakes%5===0){
            //                mvpSoundEffect.play()
            //            }
            if(flipable.visible){
                haveRandomlyChoosenIfCoinAppears=true;
                coinAnim.start()
            }
        }
        //Level one stuff
        if(level===1)
        {
            coinProb = 6;
            sliderId.value=Math.random()*820;
            mDuration-=40 /*41*/
            insideRectangleMouseArea.enabled = true; insideTheSliderRectangleMouseArea.enabled = true
            if(levelIndicator > 15)
             {
                whatToDoForNextLevel()
                //set mDuration
                mDurationEasy=1200
                mDurationMedium= 1500
                mDurationHard= 2250
                mDuration=1500
                if(true){
                    //7
                    if(counter7===21&&!(mMissionModel.get(7).currentThings>=mMissionModel.get(7).neededThings)&&checkIfCurrentMission(7)){
                        mMissionModel.get(7).currentThings=21
                    }
                    if(counter7>mMissionModel.get(7).currentThings&&!(mMissionModel.get(7).currentThings>=mMissionModel.get(7).neededThings)&&checkIfCurrentMission(7)){
                        mMissionModel.get(7).currentThings=counter7
                    }
                    counter7=0;
                }
            }
            else{
                //have to have on all three, only restart thing if not going to next level
                if(stateRectId.state!="paused")
                    seqAnimationId.restart();
            }
        }
        //Level two stuff
        else if(level===2)
        {
            coinProb = 4;
            easingNumber = Math.floor((Math.random() * 25));
            if(easingNumber<12){
                //easy
                //               start: mDurationEasy=1200;
                mDurationEasy-=42
                mDuration=mDurationEasy
                sliderEasingType= easyTypes[easingNumber]
            }
            else if(easingNumber<21){
                //medium
                mDurationMedium-=32
                mDuration=mDurationMedium
                sliderEasingType= mediumTypes[easingNumber-11]
            }
            else{
                //hard
                mDurationHard-=18
                mDuration=mDurationHard
                sliderEasingType= hardTypes[easingNumber-20]
            }


            sliderId.value=200;
            insideRectangleMouseArea.enabled = true;insideTheSliderRectangleMouseArea.enabled = true
            if(levelIndicator >17)
            {
                sliderId.enabled=false;
                if(true){
                    //8
                    if(counter8===21&&!(mMissionModel.get(8).currentThings>=mMissionModel.get(8).neededThings)&&checkIfCurrentMission(8)){
                        mMissionModel.get(8).currentThings=21
                    }
                    if(counter8>mMissionModel.get(8).currentThings&&!(mMissionModel.get(8).currentThings>=mMissionModel.get(8).neededThings)&&checkIfCurrentMission(8)){
                        mMissionModel.get(8).currentThings=counter8
                    }
                    counter8=0;
                }
                mDuration=1000;
                //head to halftime yay!
                Extra.endingPage="HalftimeMode.qml"
                onGoToHalftime()
            }
            else{
                //have to have on all three, only restart thing if not going to next level
                if(stateRectId.state!="paused")
                    seqAnimationId.restart();
            }
        }
        //Level three stuff
        else if(level===3)
        {
            coinProb = 4;
            mPauseAnim.duration-=45;
            //clearling the last times random order
            currentRandomOrder5=[];
            //making sure it starts at the first index (index 0);
            currentIndexForRandom = 0;
            newRandomColors3();
            if(levelIndicator >19)
            {
                whatToDoForNextLevel()
                handleId.visible=false;
                sliderId.enabled=true;

                mDurationEasy=1200
                mDurationMedium= 1500
                mDurationHard= 2250
                mDuration=1500

                mPauseAnim.pause()
                handleId.visible=true;
                onSunLevelText1.text=levelIndicator
            }
            else{
                //have to have on all three, only restart thing if not going to next level
                delayTimer.start()
                if(stateRectId.state!="paused")
                    mPauseAnim.restart();
            }
        }
        //Level four stuff
        else if(level===4)
        {
            checkIfCurrentMission();
            coinProb = 3;
            easingNumber = Math.floor((Math.random() * 25));
            if(easingNumber<12){
                //easy
                //               start: mDurationEasy=1200;
                if(mDurationEasy>700)
                    mDurationEasy-=42
                mDuration=mDurationEasy
                sliderEasingType= easyTypes[easingNumber]
            }
            else if(easingNumber<21){
                //medium
                if(mDurationMedium>850)
                    mDurationMedium-=32
                mDuration=mDurationMedium
                sliderEasingType= mediumTypes[easingNumber-11]
            }
            else{
                //hard
                if(mDurationHard>1010)
                    mDurationHard-=18
                mDuration=mDurationHard
                sliderEasingType= hardTypes[easingNumber-20]
            }
            insideRectangleMouseArea.enabled = true;insideTheSliderRectangleMouseArea.enabled = true

            //            if(levelIndicator >15)
            //            {
            //               whatToDoForNextLevel()
            ////                 spontaneouslyProduceSliders()
            //            }
            //            else{
            //have to have on all three, only restart thing if not going to next level
            if(stateRectId.state!="paused")
                seqAnimationId.restart();
            //            }
        }
        //        //Level five stuff
        //        else if(level===5)
        //        {
        //            coinProb = 3;
        //            Extra.emittingChaosSliderNeedsChange();
        //            insideRectangleMouseArea.enabled = true;

        //            if(levelIndicator >4)
        //            {
        //               whatToDoForNextLevel()
        ////                insideContainerId.visible=false
        //            }
        //            else{
        //                //have to have on all three, only restart thing if not going to next level
        //                if(stateRectId.state!="paused")
        //                    seqAnimationId.restart();
        //            }
        //        }
        //other variables stuff for everything
        //So basically we needed this to only happen AFTER the animation appears, so  if the animation doesnt appear this runs but if it does then it will run at the end of it
        if(!haveRandomlyChoosenIfCoinAppears){
            if (Math.floor((Math.random()*coinProb))==0){
                flipable.visible=true;
                flipable.flipped = !flipable.flipped;
            }
            else
                flipable.visible=false;
        }
    }
    //delay timer
    Timer{
        id: delayTimer
        interval: 1000
        onTriggered: {
            handleId.visible=false;
            sliderId.enabled=true;
        }
    }

    //../assets/images start here
    //Sky
    Rectangle {
        Component.onCompleted: {
            //Used to show level one message
            levelRectangleAnimation.start()
        }
        id: sky
        anchors.top: parent.top
        anchors.bottom: ground.top
        width: parent.width
        color:"blue"
        gradient: Gradient {
            GradientStop { id: skyStartGradient ;position: 0.0; color: "#0080FF" }
            GradientStop { id: skyEndGradient ;position: 1.0; color: "#66CCFF"}
        }
    }
    //pointing finger
    //pointer finger associated text
    Text{
        id: explanationTutorialText
        text: "Click anywhere in the white"
        wrapMode: Text.Wrap
        font.pointSize: textMultiplier* 14
        color: "black"
        font.bold: true
        font.family: centuryGothic.name
        width: 170
        horizontalAlignment: Text.AlignHCenter
        //        visible: pointingFinger.visible
        visible: false
        anchors.horizontalCenter: pointingFinger.horizontalCenter
        z:5
        y:0                 //doesnt matter
        Component.onCompleted: {
            this.y= pointingFinger.y-width+15
        }
    }
    Image{
        visible: false;
        z:5
        id: pointingFinger
        width: 414*1/6*1.6;
        height: 600*1/6*1.6;
        x: insideContainerId.x+insideContainerId.width/2-width/2
        y: insideContainerId.y+50-height;
        source: "../assets/images/symbols/pointingPicture.png"
        onVisibleChanged: {
            //start the animation once it is visible
            pointingFingerAnim.start()
        }
        onYChanged: {
            if(y===(insideContainerId.y+25-height-2)||y===(insideContainerId.y+25-height+32))
                pointingFingerAnim.restart()
        }

        SequentialAnimation{
            id: pointingFingerAnim
            NumberAnimation {
                id: pointingFingerAnimFront
                target: pointingFinger
                property: "y"
                to:insideContainerId.y+25-pointingFinger.height+20;
                duration: 300
                easing.type: Easing.Linear
            }
            NumberAnimation {
                id: pointingFingerAnimBack
                target: pointingFinger
                property: "y"
                to:(insideContainerId.y+25-pointingFinger.height-2)
                duration: 300
                easing.type: Easing.Linear
            }
        }
    }
    //Ground
    Rectangle{
        id: ground
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 500
        width: parent.width
        gradient: Gradient {
            GradientStop { id: groundStartGradient; position: 0.0; color: "#00FF00"}
            GradientStop {id: groundEndGradient; position: 1.0; color: "#00803F"}
        }
    }
    //Hoop
    Rectangle{
        z:4
        y:200
        id: backboard;
        height: 160*1.38;
        width:12*1.38
        color: "darkgray"
        border.width: 1
        border.color: "black"
        anchors.right: parent.right
    }
    Image{
        z:4
        id: rim
        source: "../assets/images/basketballHoop.png"
        anchors.right: backboard.left
        y: backboard.y+(backboard.height*2/3)
        width: 150*1.38
        height: 110*1.38
    }
    //Sun
    Rectangle{
        visible: true
        id: sun
        radius: 130
        x:100
        y:100
        width:180
        height:180
        color: "yellow"
        Image{
            visible: false
            id: moonInSun
            anchors.fill: parent
            source: "../assets/images/moon.png"
        }
        Text{
            id: onSunLevelText
            font.pointSize: textMultiplier* 22
            text: "Level: " + level;
            anchors.centerIn: parent
            color: "black"
            font.bold: true
            font.underline: true
            font.family: centuryGothic.name
            wrapMode: Text.Wrap
        }
        Text{
            id: onSunLevelText1
            font.pointSize: textMultiplier* 23
            text: levelIndicatorDown;
            y: onSunLevelText.y+onSunLevelText.height+5
            color: "black"
            font.family: stencil.name
            wrapMode: Text.Wrap
            anchors.horizontalCenter: onSunLevelText.horizontalCenter
        }
    }
    //Coin counter thingy
    Rectangle{
        Row{
            spacing: 20;
            x: 10
            y:10
            Image{
                width: 35
                height: 35
                source: "../assets/images/coinFront.png"
            }
            Text{
                id: coinInTheCornerText
                property int theText: numCoins
                text: theText
                font.family: stencil.name
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: textMultiplier*21
            }
        }
    }
    //the coin with anim
    Flipable {
        visible: false
        x: rim.x+90
        y:rim.y+17
        id: flipable
        property bool flipped: false
        front: Image { //--> collapse
            width: 62.5
            height: 62.5
            anchors.centerIn: parent
            source: "../assets/images/coinFront.png"
        }
        back: Image { //--> collapse
            width: 62.5
            height: 62.5
            anchors.centerIn: parent
            source: "../assets/images/coinBack.png"
        } //<-- collapse

        transform: Rotation {
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: flipable.flipped ? 180 : 0
            onAngleChanged: {
                if(angle === 180 || angle ===0){
                    if(flipable.visible)
                        flipable.flipped = !flipable.flipped
                }
            }

            Behavior on angle {
                NumberAnimation {
                    duration: 500
                }
            }
        }

        ParallelAnimation{
            id: coinAnim
            onFinished:{
                flipable.visible = false;
                flipable.x= rim.x+90
                flipable.y = rim.y+17
                flipable.back.height = 62.5;
                flipable.back.width = 62.5;
                flipable.front.width = 62.5;
                flipable.front.height = 62.5;
                numCoins++;
                coinsThisRound++;
                //So basically we needed this to only happen AFTER the animation appears, so  if the animation doesnt appear this runs but if it does then it will run at the end of it
                if (Math.floor((Math.random()*coinProb))==0){
                    flipable.visible=true;
                    flipable.flipped = !flipable.flipped;
                }
                else
                    flipable.visible=false;
            }

            NumberAnimation {
                target: flipable.back
                property: "width"
                duration: 500
                to:35
            }
            NumberAnimation {
                target: flipable.back
                property: "height"
                duration: 500
                to:35
            }
            NumberAnimation {
                target: flipable.front
                property: "width"
                duration: 500
                to:35
            }
            NumberAnimation {
                target: flipable.front
                property: "height"
                duration: 500
                to:35
            }
            PathAnimation {
                id: pathAnim
                duration: 1000
                target: flipable
                orientation: PathAnimation.TopFirst
                anchorPoint: Qt.point(flipable.width/2,
                                      flipable.height/2)
                path: Path {
                    startX:rim.x+90 ; startY: rim.y+17
                    PathCurve {
                        x: 22
                        y: 22
                    }
                }
            }
        }

    }
    //basketball
    Image{
        z:3
        id: basketBall
        y:root2.height-basketBall.height-50
        x:33;
        width: 140
        height: 140
        source: ballSource
    }
    //feedback label
    Label{
        id: feedbackLabel
        font.family: centuryGothic.name
        text: "<>"
        z: 2
        width: 250
        wrapMode: Label.Wrap
        //        x: parent.width - width-20
        //        y: 20
        x: 60
        y:parent.width/2+15
        font.pointSize: textMultiplier* 22
        visible: false
    }
    //level animation/rectangle
    Rectangle{
        id: levelRectangle
        anchors.centerIn: parent
        width: 1
        height: 1
        z:100;
        color: "#f7fafc"
        radius: 20;
        visible: false;

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            id: levelRectangleText1
            text: "Level " + level
            font.pointSize: textMultiplier* 1;
            font.family: bodoniMTBlack.name
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
        Text{
            function levelTextFunc(level)
            {
                if(level===1){
                    levelRectangleText.text = "     Don't miss three. It gets harder as you go!"
                }
                else if(level===2){
                    levelRectangleText.text = "     Don't miss three. Watch for the crazy patterns!"
                }
                else if(level===3){
                    levelRectangleText.text = "     Don't miss three. Watch for the switching colors"
                }
                else if(level===4){
                    levelRectangleText.text = "     Don't miss three. Watch for the crazier patterns!"
                }
            }
            id: levelRectangleText
            text: levelTextFunc(level)
            font.pointSize: textMultiplier* 18;
            font.family: centuryGothic.name
            wrapMode: Text.Wrap
            width: parent.width-30
            lineHeight: 1.32
            y: levelRectangleText1.y+levelRectangleText1.implicitHeight+30
            anchors.horizontalCenter: parent.horizontalCenter
            visible:false
        }

        ParallelAnimation {
            id: levelRectangleAnimation
            onStarted: {
                levelRectangle.visible = true;
                seqAnimationId.pause();
            }
            onFinished: {
                //Making bottom text appear
                levelRectangleText.visible=true
                levelRectangleAnimationPause.start()

            }
            NumberAnimation {
                target: levelRectangleText1
                property: "font.pointSize"
                duration: 800
                easing.type: Easing.Linear
                to:36
            }
            NumberAnimation {
                target: levelRectangle
                property: "width"
                duration: 800
                easing.type: Easing.Linear
                to: (root2.width*4/5)*7/10
            }
            NumberAnimation {
                target: levelRectangle
                property: "height"
                duration: 800
                easing.type: Easing.Linear
                to: root2.height*3/7
            }
        }
        PauseAnimation {
            id: levelRectangleAnimationPause
            onStarted: {
                stateRectId.state = "paused"
            }
            onFinished: {
                //resetting everything to defaults
                stateRectId.state = "notPaused";
                levelRectangle.visible = false;
                levelRectangle.width=1;
                levelRectangle.height = 1;
                levelRectangleText1.font.pointSize=1
                levelRectangleText.visible=false
                if (level===3){
                    sliderId.enabled=true;
                    newRandomColors3();
                    mPauseAnim.start();
                }
                else{
                    insideRectangleMouseArea.enabled = true; insideTheSliderRectangleMouseArea.enabled = true
                    seqAnimationId.start()
                }
            }
            duration: 8000
        }
    }
    //faded Red
    Rectangle{
        id:fadedRED
        z:19
        anchors.fill: parent
        color: "red"
        opacity: 0.20
        visible: false
    }
    //new faded fadedRED
    //faded Red
    Rectangle{
        id:newFadedRed
        z:10
        anchors.fill: parent
        color: "#b07979"
        opacity: 0.4
        visible: false
    }
    property bool quitButtonWasClicked: false
    //newRetryCircle
    Rectangle{
        z:30
        visible: false
        id: newRetryCircle
        color: "transparent"
        anchors.centerIn: parent
        CircularProgress{
            id: circularProgress
            y: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -150
        }
        Button{
            //these are the rewarded ad stuff IGNORE ERRORS FOR NOW
            //                        AdMobRewardedVideo {
            //                            id: myRewardedVideo
            //                            // test ad for rewarded videos
            //                            adUnitId: "ca-app-pub-3940256099942544/5224354917"

            //                            onRewardedVideoRewarded: {
            //                                updateMissions();
            //                            }
            //                            // load rewarded video at app start to cache it
            //                            Component.onCompleted: {
            //                                loadRewardedVideo()
            //                            }
            //                        }
            onClicked: {
                if(numCoins>=10){
                    numCoins=numCoins-10;
                    adUsed=true
                    quitButtonWasClicked=true
                    newRetryCircle.visible=false
                    newFadedRed.visible=false
                    adScreenHappening=false
                    //                    // show the new video if user is below 10 credits
                    //                    myRewardedVideo.showRewardedVideoIfLoaded()
                    //                    // load a new video every time it got shown, to give the user a fresh ad
                    //                    myRewardedVideo.loadRewardedVideo()
                    //all of this should be after onRewardedVideoRewarded but this is for testing
                    sliderId.enabled=true;
                    insideRectangleMouseArea.enabled=true
                    insideTheSliderRectangleMouseArea.enabled=true
                    flashingScoreText.color="black"
                    manyMisses=0
                    x1.visible=false
                    x2.visible=false
                    x3.visible=false
                    whatToDoWhenAnimFinished()
                }
            }
            y: circularProgress.y+circularProgress.height+50
            id: newMissionsAdButton
            anchors.horizontalCenter: parent.horizontalCenter
            height: 55*1.3
            width: 140*2*1.3
            z:5
            Rectangle{
                anchors.fill: parent
                //                color: (numCoins>=10)?"#2e8ddb":"#6e7a85"
                color: "#2e8ddb"
            }
            Row{
                x:10
                anchors.verticalCenter: parent.verticalCenter
                anchors.centerIn: parent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    color: "White"
                    font.family: centuryGothic.name
                    font.bold: true
                    font.pointSize: textMultiplier* 28
                    text:"Continue"
                }
                Rectangle{
                    width: 15*1.3
                    height: 2*1.3
                    color: "transparent"
                }
                //                //video pic
                //                Image{
                //                    anchors.verticalCenter: parent.verticalCenter
                //                    width: 50*1.3
                //                    height: 35*1.3
                //                    source: "../assets/images/PlayAdVideo.png"
                //                }
                //coin pic
                Row{
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 15;
                    Image{
                        anchors.verticalCenter: parent.verticalCenter
                        width: height
                        height: (50+35)/2*1.3
                        source: "../assets/images/coinFront.png"
                    }
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: "10"
                        font.family: stencil.name
                        font.pointSize: textMultiplier*23
                    }
                }
            }
        }
        Rectangle{
            z:4
            visible: newMissionsAdButton.visible;
            id: newMissionsAdButtonFade
            width: newMissionsAdButton.width
            height: newMissionsAdButton.height
            y: newMissionsAdButton.y+5
            x: newMissionsAdButton.x-5
            color: "#18549e"
        }
        Button{
            onClicked: {
                afterGameIsActuallyOver()
                quitButtonWasClicked=true
                seqAnimationId.stop()
                levelRectangleAnimation.start()
                x1.visible=false; x2.visible = false; x3.visible = false;
                newRetryCircle.visible=false
                newFadedRed.visible=false
                adScreenHappening=false
            }
            y: newMissionsAdButton.y+newMissionsAdButton.height+50
            id: quitRetryCircleButton
            anchors.horizontalCenter: parent.horizontalCenter
            height: newMissionsAdButton.height
            width: newMissionsAdButton.width
            z:5
            Rectangle{
                anchors.fill: parent
                color: "#a8aeb3"
            }
            Row{
                x:10
                anchors.verticalCenter: parent.verticalCenter
                anchors.centerIn: parent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    color: "White"
                    font.family: centuryGothic.name
                    font.bold: true
                    font.pointSize: textMultiplier* 28

                    text:"Retry"
                }
                Rectangle{
                    width: 15*1.3
                    height: 2*1.3
                    color: "transparent"
                }
                //undo button
                Icon{
                    anchors.verticalCenter: parent.verticalCenter
                    size: 45*1.3
                    icon: IconType.undo
                }
            }
        }
        Rectangle{
            z:4
            visible: quitRetryCircleButton.visible;
            id: quitRetryCircleButtonFade
            width: quitRetryCircleButton.width
            height: quitRetryCircleButton.height
            y: quitRetryCircleButton.y+5
            x: quitRetryCircleButton.x-5
            color: "#656a6e"
        }
    }
    //retry box
    signal quitButtonClicked
    Rectangle{
        onVisibleChanged: {
            seqAnimationId.stop()
            if(visible)
                newFadedRed.visible=true
            else
                newFadedRed.visible=false
        }

        visible: false
        width: parent.width*2/3
        height:parent.height*1/3
        anchors.centerIn: parent
        z:20
        id: retryBox
        radius:20
        gradient: Gradient{
            GradientStop{position: 0.0; color: "#2e8ddb"/*"#f52a2a"*/}
            GradientStop{position: 0.5; color: "#ffffff"}
            GradientStop{position: 1.0; color: "#2e8ddb"/*"#f52a2a"*/}
        }
        Column{
            x:0
            y:0
            width:parent.width
            spacing:10
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: bodoniMTBlack.name
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: textMultiplier* 34
                width: parent.width
                text: "You lost!"
            }
            Text{
                x:10
                width: parent.width-20
                font.family: centuryGothic.name
                font.pointSize: textMultiplier* 17.5
                wrapMode: Text.Wrap
                text:"     Please try again! Remember 3 missed shots and you are out"
            }
            Rectangle{
                width: 20
                height: 30
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row{
                spacing:25
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle{
                        anchors.fill: parent
                        color: okButton.pressed?"#233ab8" :"#2f44ba"
                    }
                    Text{
                        anchors.centerIn: parent
                        font.pointSize: textMultiplier* 20
                        text: "Retry"
                        color: "white"
                        font.family: centuryGothic.name
                    }
                    id: okButton
                    height: 115
                    width: 200
                    onClicked: {
                        afterGameIsActuallyOver()
                        seqAnimationId.stop()
                        levelRectangleAnimation.start()
                        x1.visible=false; x2.visible = false; x3.visible = false;
                        retryBox.visible=false
                        fadedRED.visible=false
                        adScreenHappening=false
                        retryScreenHappening=false
                    }
                }
                Button {
                    Rectangle{
                        anchors.fill: parent
                        color: cancelButton.pressed?"#5d71de" : "#758bff"
                    }
                    Text{
                        anchors.centerIn: parent
                        font.pointSize: textMultiplier* 20
                        text: "Quit"
                        color: "black"
                        font.family: centuryGothic.name
                    }
                    id: cancelButton
                    width: okButton.width*0.7
                    height: okButton.height*0.7
                    onClicked: {
                        retryBox.visible=false
                        fadedRED.visible=false
                        afterGameIsActuallyOver()
                        seqAnimationId.stop()
                        levelRectangleAnimation.start()
                        x1.visible=false; x2.visible = false; x3.visible = false;
                        adScreenHappening=false
                        retryScreenHappening=false
                        switchFileSignal()
                    }
                }
                //                Button{

                //                    height: 150
                //                    width: 220
                //                    Text{
                //                        color: "#ed912f"
                //                        text: "RETRY"
                //                        font.bold: true
                //                        font.pointSize: textMultiplier* 23
                //                        anchors.centerIn: parent
                //                    }
                //                    onClicked: {
                //                        seqAnimationId.stop()
                //                        levelRectangleAnimation.start()
                //                        x1.visible=false; x2.visible = false; x3.visible = false;
                //                        retryBox.visible=false
                //                        retryScreenHappening=false
                //                    }
                //                }
                //                Button{
                //                    id: quitButton
                //                    anchors.verticalCenter: parent.verticalCenter
                //                    width: 140
                //                    Text{
                //                        color: "#ed912f"
                //                        text: "QUIT"
                //                        font.pointSize: textMultiplier* 20
                //                        anchors.centerIn: parent
                //                    }
                //                    onClicked: {
                //                        retryBox.visible=false
                //                        fadedRED.visible=false
                //                        switchFileSignal()
                //                    }
                //                }
            }
        }
    }

    //    //Giant x
    //    Image{
    //        visible: false
    //        z:20
    //        id: giantX;
    //        anchors.centerIn: parent
    //        source: "../assets/images/xSymbol.png"
    //        height: 600*1.3;
    //        width: 515*1.3;
    //    }
    BackgroundMusic{
        id: mMusic1
        source:"../assets/sounds/backgroundMusic.mp3"
        volume: root.volume*6/11
        autoPlay: true;
    }
    //All three of the x's
    Row{
        id: threeMissesX
        //        anchors.bottom: scoreId.top
        //        x: scoreId.x +35
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
        Image{
            visible: false;
            id: x1
            height: 45*1.4;
            width: 30*1.4;
            source: "../assets/images/symbols/curvedX.png"
        }
        Image{
            visible: false
            id: x2
            height: 45*1.4;
            width: 30*1.4;
            source: "../assets/images/symbols/curvedX.png"
        }
        Image{
            visible: false
            id: x3
            height: 45*1.4;
            width: 30*1.4;
            source: "../assets/images/symbols/curvedX.png"
        }
    }
    //All ten of the lines
    Row{
        id: allMakeTallies11
        anchors.bottom: scoreId.top
        x: scoreId.x +35
        Image{
            visible: false;
            id: tally1
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false
            id: tally2
            //            height: 50;
            //            width: 10;
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false
            id: tally3
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false;
            id: tally4
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false
            id: tally5
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
            transform: Rotation{
                id: rotateImagePhoto
                angle: 326
                origin.x: tally5.width/2
                origin.y: tally5.height
            }
        }
        Image{
            visible: false
            id: tally6
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false;
            id: tally7
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false
            id: tally8
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false
            id: tally9
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
        }
        Image{
            visible: false
            id: tally10
            height: 250/3.7*1.3;
            width: 37/3.7*1.3;
            source: "../assets/images/symbols/tallyMark.png"
            transform: Rotation{
                id: rotateImagePhoto2
                angle: 326
                origin.x: tally10.width/2
                origin.y: tally10.height
            }
        }
        Image{
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            id: plus11
            height: 40*1.3;
            width: 40*1.3;
            source: "../assets/images/symbols/plus.png"
        }
    }
    //Score and PB rectangle
    Rectangle{
        id: flashingScore
        width: scoreId.width*1/2
        height: scoreId.height*3/2
        z:6
        color: "transparent"
        //border.color: "black" //no need for border
        x: scoreId.x-scoreId.width/2-10
        anchors.verticalCenter: scoreId.verticalCenter
        Text{
            id: flashingScoreText
            opacity: 0;
            color: "black"
            x: 1
            y: 1
            text:"apples are cool"
            rotation: 0
            font.family: snapITC.name
            font.pointSize: textMultiplier* 19
        }

        NumberAnimation {
            id: flashingScoreAnim
            target: flashingScoreText
            property: "opacity"
            duration: 300
            easing.type: Easing.Linear
            to: 1;
        }
    }

    //Box in the corner with score and PB
    Rectangle{
        z:2
        id: scoreId
        width: 180
        height: 140
        radius: 28
        border.color: "#134f13"
        border.width: 3
        x: rim.x-30
        y: ground.y + 24

        Text{
            property int value: points
            id: pointText
            text: value
            Behavior on value {
                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
            font.pointSize: textMultiplier* 28
            y: 10
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: impact.name
        }

        Text{
            text: "PB: " + personalBest;
            font.family: stencil.name
            font.pointSize: textMultiplier* 20
            font.bold: true
            anchors.top: pointText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        gradient: Gradient{
            GradientStop{position: 0 ;color: "#faf5f5"}
            GradientStop{position: 1/7 ;color: "#bfe6b1"}
            GradientStop{position: 2/7 ;color: "#faf5f5"}
            GradientStop{position: 3/7 ;color: "#bfe6b1"}
            GradientStop{position: 4/7 ;color: "#faf5f5"}
            GradientStop{position: 5/7 ;color: "#bfe6b1"}
            GradientStop{position: 6/7 ;color: "#faf5f5"}
            GradientStop{position: 1 ;color: "#bfe6b1"}
        }
    }

    Rectangle{
        id: insideContainerId
        color: "#dfedf2"
        opacity: 0.95
        width: 510
        height: 170
        radius: 12
        //        anchors.horizontalCenter: sliderId.horizontalCenter
        //        anchors.verticalCenter: sliderId.verticalCenter
        x: parent.width/2-width/2+80
        y: parent.height-ground.height/2-height/2+40
        signal sliderStopped(double value);
        onSliderStopped: {
            //normal setting upp stuff
            basketBall.width=140
            basketBall.height=140
            basketBall.y = root2.height-basketBall.height-50;
            basketBall.x=33;
            basketBall.rotation = 0
            feedbackLabel.visible= false;
            feedbackLabel.font.italic=false
            feedbackLabel.font.bold = false
            //Variable declarations
            var feedback = [];
            var random_number=0;
            let level3ShotAccuracy = figureOutShotWithColor(value);
            let pointsThisRound = 0;
            function lastMissionCheck(shotShot){
                function typeOfShot(shotShot){
                    var correctShot = typesOfShotPossible[shotRandomNumber]
                    //                    console.log("correct shot is"+correctShot)
                    if(correctShot===shotShot){
                        //                        console.log("Last mission check returned true")
                        return true;
                    }
                    //                    console.log("Last mission check returned false")
                    return false;
                }
                let last= mMissionModel.get(17)
                if(typeOfShot(shotShot)){
                    if(level===levelOptions[levelRandomNumber]){
                        counterLast++;
                        if(counterLast===mMissionModel.get(17).neededThings&&mMissionModel.get(17).currentThings<mMissionModel.get(17).neededThings){
                            mMissionModel.get(17).currentThings=counterLast
                            counterLast--
                        }
                    }
                }
                else{
                    if(level===levelOptions[levelRandomNumber]){
                        if(counterLast>mMissionModel.get(17).currentThings&&mMissionModel.get(17).currentThings<mMissionModel.get(17).neededThings){
                            mMissionModel.get(17).currentThings=counterLast;
                        }
                        counterLast=0;
                    }

                }
            }
            if(level3ShotAccuracy==="airball"|| level3ShotAccuracy==="null"&&(value <80  || value > 920)){
                if(true){
                    //all mission stuff
                    lastMissionCheck("airball")
                    //0
                    if(counter0>mMissionModel.get(0).currentThings&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                        mMissionModel.get(0).currentThings=counter0;
                    }
                    counter0=0;
                    //1
                    if(counter1>mMissionModel.get(1).currentThings&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings)&&checkIfCurrentMission(1)){
                        mMissionModel.get(1).currentThings=counter1
                    }
                    counter1=0;
                    //2
                    if(counter2>mMissionModel.get(2).currentThings&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                        console.log("Am I here???")
                        mMissionModel.get(2).currentThings=counter2
                    }
                    counter2=0;
                    //3
                    if(counter3>mMissionModel.get(3).currentThings&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                        mMissionModel.get(3).currentThings=counter3
                    }
                    counter3=0;
                    //4
                    if(level===3){
                        if(counter4>mMissionModel.get(4).currentThings&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)&&checkIfCurrentMission(4)){
                            mMissionModel.get(4).currentThings=counter4
                        }
                        counter4=0;
                    }
                    //5
                    if(level===2){
                        if(counter5>mMissionModel.get(5).currentThings&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)&&checkIfCurrentMission(5)){
                            mMissionModel.get(5).currentThings=counter5
                        }
                        counter5=0;
                    }
                    //6
                    if(level===3){
                        if(counter6>mMissionModel.get(6).currentThings&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                            mMissionModel.get(6).currentThings=counter6
                        }
                        counter6=0;
                    }
                    //7
                    //8
                    //9
                    if(level===3){
                        if(counter9>mMissionModel.get(9).currentThings&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                            mMissionModel.get(9).currentThings=counter9
                        }
                        counter9=0;
                    }
                    //10
                    //11
                    //12
                    //13
                    if(counter13>mMissionModel.get(13).currentThings&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                        mMissionModel.get(13).currentThings=counter13
                    }
                    counter13=0;
                    //14
                }
                manyMisses++;
                manyMakes=0;
                points -= level*105;
                pointsThisRound -= level*105;
                airBallAnimation.start();
                feedback = ["You can do better", "An airball?", "Try to aim at the hoop", "My dog can shoot better than that", "A complete fail...", "Practice makes perfect...you need practice!"]
                random_number = Math.floor((Math.random() * 6));
                feedbackLabel.font.italic = true;
            }
            else if(level3ShotAccuracy==="backboardMiss"|| level3ShotAccuracy==="null"&&(value <180 || value >820)){
                if(true){
                    //all mission stuff
                    lastMissionCheck("backboardMiss")
                    //0
                    if(counter0>mMissionModel.get(0).currentThings&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                        mMissionModel.get(0).currentThings=counter0;
                    }
                    counter0=0;
                    //1
                    if(counter1>mMissionModel.get(1).currentThings&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings)&&checkIfCurrentMission(1)){
                        mMissionModel.get(1).currentThings=counter1
                    }
                    counter1=0;
                    //2
                    if(counter2>mMissionModel.get(2).currentThings&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                        mMissionModel.get(2).currentThings=counter2
                    }
                    counter2=0;
                    //3
                    counter3++;
                    if(counter3===mMissionModel.get(3).neededThings&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                        mMissionModel.get(3).currentThings=2
                    }
                    //4
                    if(level===3){
                        if(counter4>mMissionModel.get(4).currentThings&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)&&checkIfCurrentMission(4)){
                            mMissionModel.get(4).currentThings=counter4
                        }
                        counter4=0;
                    }
                    //5
                    if(level===2){
                        if(counter5>mMissionModel.get(5).currentThings&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)&&checkIfCurrentMission(5)){
                            mMissionModel.get(5).currentThings=counter5
                        }
                        counter5=0;
                    }
                    //6
                    if(level===3){
                        if(counter6>mMissionModel.get(6).currentThings&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                            mMissionModel.get(6).currentThings=counter6
                        }
                        counter6=0;
                    }
                    //7
                    //8
                    //9
                    if(level===3){
                        if(counter9>mMissionModel.get(9).currentThings&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                            mMissionModel.get(9).currentThings=counter9
                        }
                        counter9=0;
                    }
                    //10
                    //11
                    //12
                    //13
                    if(counter13>mMissionModel.get(13).currentThings&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                        mMissionModel.get(13).currentThings=counter13
                    }
                    counter13=0;
                    //14
                }

                manyMisses++;
                manyMakes=0;
                points -= level*75;
                pointsThisRound -= level*75;
                backboardMissAnimation.start()
                feedback = ["Better than an airball", "Atleast you hit the backboard", "Your NBA hopes are dwindling", "Next time, try to hit the rim", "Might want to take some basketball lessons", "Not your worst...", "I think you can do better"]
                random_number = Math.floor((Math.random() * 6));
            }
            else if(level3ShotAccuracy==="rimMiss"|| level3ShotAccuracy==="null"&&(value <270 || value >730)){
                if(true){
                    //all mission stuff
                    lastMissionCheck("rimMiss")
                    //0
                    if(counter0>mMissionModel.get(0).currentThings&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                        mMissionModel.get(0).currentThings=counter0;
                    }
                    counter0=0;
                    //1
                    if(counter1>mMissionModel.get(1).currentThings&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings)&&checkIfCurrentMission(1)){
                        mMissionModel.get(1).currentThings=counter1
                    }
                    counter1=0;
                    //2
                    if(counter2>mMissionModel.get(2).currentThings&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                        mMissionModel.get(2).currentThings=counter2
                    }
                    counter2=0;
                    //3
                    if(counter3>mMissionModel.get(3).currentThings&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                        mMissionModel.get(3).currentThings=counter3
                    }
                    counter3=0;
                    //4
                    if(level===3){
                        if(counter4>mMissionModel.get(4).currentThings&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)&&checkIfCurrentMission(4)){
                            mMissionModel.get(4).currentThings=counter4
                        }
                        counter4=0;
                    }
                    //5
                    if(level===2){
                        if(counter5>mMissionModel.get(5).currentThings&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)&&checkIfCurrentMission(5)){
                            mMissionModel.get(5).currentThings=counter5
                        }
                        counter5=0;
                    }
                    //6
                    if(level===3){
                        if(counter6>mMissionModel.get(6).currentThings&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                            mMissionModel.get(6).currentThings=counter6
                        }
                        counter6=0;
                    }
                    //7
                    //8
                    //9
                    if(level===3){
                        counter9++;
                        if(counter9===mMissionModel.get(2).neededThings&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                            mMissionModel.get(9).currentThings=mMissionModel.get(9).neededThings
                        }
                    }
                    //10
                    //11
                    //12
                    //13
                    if(counter13>mMissionModel.get(13).currentThings&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                        mMissionModel.get(13).currentThings=counter13
                    }
                    counter13=0;
                    //14
                }

                manyMisses++;
                manyMakes=0;
                points -= level*40;
                pointsThisRound -= level*40;
                rimMissAnimation.start()
                feedback = ["Brick", "Close but not yet there", "Hit the net next time, not the rim", "Closer than ever", "You'll do it next time", "Good try!", "Close but not there", "Seems like you have started practicing..."]
                random_number = Math.floor((Math.random() * 5));
            }
            else if(level3ShotAccuracy==="backboardMake"|| level3ShotAccuracy==="null"&&(value < 350 || value >650)){
                if(true){
                    //all mission stuff
                    lastMissionCheck("backboard")
                    //0
                    if(counter0>mMissionModel.get(0).currentThings&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                        mMissionModel.get(0).currentThings=counter0;
                    }
                    counter0=0;
                    //1
                    if(counter1>mMissionModel.get(1).currentThings&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings&&checkIfCurrentMission(1))){
                        mMissionModel.get(1).currentThings=counter1
                    }
                    counter1=0;
                    //2
                    if(counter2>mMissionModel.get(2).currentThings&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                        mMissionModel.get(2).currentThings=counter2
                    }
                    counter2=0;
                    //3
                    if(counter3>mMissionModel.get(3).currentThings&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                        mMissionModel.get(3).currentThings=counter3
                    }
                    counter3=0;
                    //4
                    if(level===3){
                        if(counter4>mMissionModel.get(4).currentThings&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)&&checkIfCurrentMission(4)){
                            mMissionModel.get(4).currentThings=counter4
                        }
                        counter4=0;
                    }
                    //5
                    if(level===2){
                        counter5++;
                        if(counter5===mMissionModel.get(5).neededThings&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)){
                            mMissionModel.get(5).currentThings=mMissionModel.get(5).currentThings
                        }
                    }
                    //6
                    if(level===3){
                        if(counter6>mMissionModel.get(6).currentThings&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                            mMissionModel.get(6).currentThings=counter6
                        }
                        counter6=0;
                    }
                    //7
                    //8
                    //9
                    if(level===3){
                        if(counter9>mMissionModel.get(9).currentThings&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                            mMissionModel.get(9).currentThings=counter9
                        }
                        counter9=0;
                    }
                    //10
                    //11
                    //12
                    //13
                    counter13++;
                    if(counter13===mMissionModel.get(13).neededThings&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                        mMissionModel.get(13).currentThings=mMissionModel.get(13).neededThings
                    }
                    //14
                }

                manyMakes++;
                //                manyMisses=0
                points +=30*level;
                pointsThisRound += 30*level;
                backboardAnimation.start()
                feedback = ["Good shot","A make is a make", "A splash is a splash", "Lucky shot?",  "You can do even better", "Atleast it made"]
                random_number = Math.floor((Math.random() * 7));
            }
            else if(level3ShotAccuracy==="rimMake"|| level3ShotAccuracy==="null"&&(value <415 || value > 585)){
                if(true){
                    //all mission stuff
                    lastMissionCheck("rim")
                    //0
                    if(counter0>mMissionModel.get(0).currentThings&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                        mMissionModel.get(0).currentThings=counter0;
                    }
                    counter0=0;
                    //1
                    if(counter1>mMissionModel.get(1).currentThings&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings)&&checkIfCurrentMission(1)){
                        mMissionModel.get(1).currentThings=counter1
                    }
                    counter1=0;
                    //2
                    if(counter2>mMissionModel.get(2).currentThings&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                        mMissionModel.get(2).currentThings=counter2
                    }
                    counter2=0;
                    //3
                    if(counter3>mMissionModel.get(3).currentThings&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                        mMissionModel.get(3).currentThings=counter3
                    }
                    counter3=0;
                    //4
                    if(level===3){
                        counter4++;
                        if(counter4===mMissionModel.get(4).neededThings&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)){
                            mMissionModel.get(4).currentThings=mMissionModel.get(4).neededThings
                        }
                    }
                    //5
                    if(level===2){
                        if(counter5>mMissionModel.get(5).currentThings&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)&&checkIfCurrentMission(5)){
                            mMissionModel.get(5).currentThings=counter5
                        }
                        counter5=0;
                    }
                    //6
                    if(level===3){
                        if(counter6>mMissionModel.get(6).currentThings&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                            mMissionModel.get(6).currentThings=counter6
                        }
                        counter6=0;
                    }
                    //7
                    //8
                    //9
                    if(level===3){
                        if(counter9>mMissionModel.get(9).currentThings&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                            mMissionModel.get(9).currentThings=counter9
                        }
                        counter9=0;
                    }
                    //10
                    //11
                    //12
                    //13
                    if(counter13>mMissionModel.get(13).currentThings&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                        mMissionModel.get(13).currentThings=counter13
                    }
                    counter13=0;
                    //14
                }

                manyMakes++;
                //                manyMisses=0
                points+=50*level
                pointsThisRound += 50*level;
                rimMakeAnimation.start()
                feedback = ["I thought that was going to miss", "The rim was on your side", "Looks like you are on a set path to the NBA", "Amazing shot!", "Pretty nice!", "Fantastic", "Pretty good"]
                random_number = Math.floor((Math.random() * 5));
            }
            else if(level3ShotAccuracy==="splash"|| level3ShotAccuracy==="null"&&(value <485|| value>515)){
                if(true){
                    //all mission stuff
                    lastMissionCheck("splash")
                    //0
                    counter0++;
                    if(counter0===mMissionModel.get(0).neededThings&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                        mMissionModel.get(0).currentThings=mMissionModel.get(0).neededThings
                    }
                    //1
                    counter1++;
                    if(counter1===mMissionModel.get(1).neededThings&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings)&&checkIfCurrentMission(1)){
                        mMissionModel.get(1).currentThings=mMissionModel.get(1).neededThings
                    }
                    //2
                    counter2++;
                    if(counter2===mMissionModel.get(2).neededThings&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                        mMissionModel.get(2).currentThings=mMissionModel.get(2).neededThings
                    }
                    //3
                    if(counter3>mMissionModel.get(3).currentThings&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                        mMissionModel.get(3).currentThings=counter3
                    }
                    counter3=0;
                    //4
                    if(level===3){
                        if(counter4>mMissionModel.get(4).currentThings&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)&&checkIfCurrentMission(4)){
                            mMissionModel.get(4).currentThings=counter4
                        }
                        counter4=0;
                    }
                    //5
                    if(level===2){
                        if(counter5>mMissionModel.get(5).currentThings&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)&&checkIfCurrentMission(5)){
                            mMissionModel.get(5).currentThings=counter5
                        }
                        counter5=0;
                    }
                    //6
                    if(level===3){
                        counter6++;
                        if(counter6===mMissionModel.get(6).neededThings&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                            mMissionModel.get(6).currentThings=mMissionModel.get(6).neededThings
                        }
                    }
                    //7
                    //8
                    //9
                    if(level===3){
                        if(counter9>mMissionModel.get(9).currentThings&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                            mMissionModel.get(9).currentThings=counter9
                        }
                        counter9=0;
                    }
                    //10
                    //11
                    //12
                    //13
                    if(counter13>mMissionModel.get(13).currentThings&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                        mMissionModel.get(13).currentThings=counter13
                    }
                    counter13=0;
                    //14
                }

                manyMakes++;
                //                manyMisses=0
                points+= 110*level
                pointsThisRound += 110*level;
                splashAnimation.start()
                feedback = ["Next MVP?","Future NBA champion","The next Steph Curry?", "What an amazing shot?", "Making some splashes", "Raining threes", "All the way from deep?", "Swish!", "Like a true NBA player"]
                random_number = Math.floor((Math.random() * 7));
            }
            else{
                //need these stuffy here for if statement to check for make the work
                if(true){
                    //all mission stuff
                    lastMissionCheck("splash")
                    //0
                    counter0++;
                    if(counter0===mMissionModel.get(0).neededThings&&!(mMissionModel.get(0).currentThings>=mMissionModel.get(0).neededThings)&&checkIfCurrentMission(0)){
                        mMissionModel.get(0).currentThings=mMissionModel.get(0).neededThings
                    }
                    //1
                    counter1++;
                    if(counter1===mMissionModel.get(1).neededThings&&!(mMissionModel.get(1).currentThings>=mMissionModel.get(1).neededThings)&&checkIfCurrentMission(1)){
                        mMissionModel.get(1).currentThings=mMissionModel.get(1).neededThings
                    }
                    //2
                    counter2++;
                    if(counter2===mMissionModel.get(2).neededThings&&!(mMissionModel.get(2).currentThings>=mMissionModel.get(2).neededThings)&&checkIfCurrentMission(2)){
                        mMissionModel.get(2).currentThings=mMissionModel.get(2).neededThings
                    }
                    //3
                    if(counter3>mMissionModel.get(3).currentThings&&!(mMissionModel.get(3).currentThings>=mMissionModel.get(3).neededThings)&&checkIfCurrentMission(3)){
                        mMissionModel.get(3).currentThings=counter3
                    }
                    counter3=0;
                    //4
                    if(level===3){
                        if(counter4>mMissionModel.get(4).currentThings&&!(mMissionModel.get(4).currentThings>=mMissionModel.get(4).neededThings)&&checkIfCurrentMission(4)){
                            mMissionModel.get(4).currentThings=counter4
                        }
                        counter4=0;
                    }
                    //5
                    if(level===2){
                        if(counter5>mMissionModel.get(5).currentThings&&!(mMissionModel.get(5).currentThings>=mMissionModel.get(5).neededThings)&&checkIfCurrentMission(5)){
                            mMissionModel.get(5).currentThings=counter5
                        }
                        counter5=0;
                    }
                    //6
                    if(level===3){
                        counter6++;
                        if(counter6===mMissionModel.get(6).neededThings&&!(mMissionModel.get(6).currentThings>=mMissionModel.get(6).neededThings)&&checkIfCurrentMission(6)){
                            mMissionModel.get(6).currentThings=mMissionModel.get(6).neededThings
                        }
                    }
                    //7
                    //8
                    //9
                    if(level===3){
                        if(counter9>mMissionModel.get(9).currentThings&&!(mMissionModel.get(9).currentThings>=mMissionModel.get(9).neededThings)&&checkIfCurrentMission(9)){
                            mMissionModel.get(9).currentThings=counter9
                        }
                        counter9=0;
                    }
                    //10
                    //11
                    //12
                    //13
                    if(counter13>mMissionModel.get(13).currentThings&&!(mMissionModel.get(13).currentThings>=mMissionModel.get(13).neededThings)&&checkIfCurrentMission(13)){
                        mMissionModel.get(13).currentThings=counter13
                    }
                    counter13=0;
                    //14
                }

                manyMakes++;
                //                manyMisses=0
                points+= 150*level
                pointsThisRound +=150*level;
                splashAnimation.start()
                feedback = ["The Greatest of All Time", "May be the greatest shot ever", "Game winner!", "Buzzer beater", "MVP", "Champion", "Beautiful shot"]
                random_number = Math.floor((Math.random() * 5));
                feedbackLabel.font.bold = true;
                splashAnimation.start()
            }
            //If make- in general
            if(manyMakes>0)
            {
                if(true){
                    if(level===1){
                        //update mission
                        //7
                        counter7++;
                    }
                    if(level===2){
                        //update missions
                        //8
                        counter8++;
                    }
                }
                //                x1.visible=false;
                //                x2.visible=false;
                //                x3.visible=false;
                //Brighten the color of the score box text on the bottom left
                switch(manyMakes){
                case 1: tally1.visible =true;
                    flashingScoreText.color = "black"
                    break;
                case 2: tally1.visible =true; tally2.visible =true;
                    flashingScoreText.color = "#302525"
                    break;
                case 3:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    flashingScoreText.color = "#422e2e"
                    extraPoints=70;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 4:tally1.visible =true; tally2.visible =true;
                    tally3.visible =true; tally4.visible =true;
                    flashingScoreText.color = "#523333"
                    extraPoints=80;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 5:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true;
                    flashingScoreText.color = "#633434"
                    extraPoints=100;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 6:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true; tally6.visible =true;
                    flashingScoreText.color = "#803434"
                    extraPoints=120;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 7:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true;
                    tally6.visible =true; tally7.visible =true;
                    flashingScoreText.color = "#a34141"
                    extraPoints=135;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 8:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true;
                    tally6.visible =true; tally7.visible =true; tally8.visible =true;
                    flashingScoreText.color = "#d44242"
                    extraPoints=145;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 9:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true; tally6.visible =true;
                    tally7.visible =true; tally8.visible =true; tally9.visible =true;
                    flashingScoreText.color = "#ed4747"
                    extraPoints=155;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 10: tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true; tally6.visible =true;
                    tally7.visible =true; tally8.visible =true;
                    tally9.visible =true; tally10.visible =true;
                    flashingScoreText.color = "#ff0000"
                    extraPoints=160;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                default: tally1.visible =true; tally2.visible =true; tally3.visible =true; tally4.visible =true;
                    tally5.visible =true; tally6.visible =true; tally7.visible =true; tally8.visible =true; tally9.visible =true;
                    tally10.visible =true; plus11.visible = true;
                    flashingScoreText.color = "#2b59ff"
                    extraPoints+=15;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                }
            }
            //If miss - in general
            else{
                tally1.visible =false; tally2.visible =false; tally3.visible =false;
                tally4.visible =false; tally5.visible =false; tally6.visible =false;
                tally7.visible =false; tally3.visible =false; tally8.visible =false;
                tally9.visible =false; tally10.visible =false; plus11.visible=false;
                extraPoints=70;
                flashingScoreText.color = "black"
                switch(manyMisses)
                {
                case 1: x1.visible=true; break;
                case 2: x1.visible=true; x2.visible = true; break;
                case 3: x1.visible=true; x2.visible = true; x3.visible = true; break;
                }
            }
            //Do every time either way
            levelIndicator++;
            (level===3)?(sliderId.enabled=true):(sliderId.enabled=false);

            //feedback label
            feedbackLabel.x= Math.random()*(20)+40;
            feedbackLabel.y= Math.random()*(30)+parent.width/2;
            feedbackLabel.rotation= (Math.random()*80)-40;
            feedbackLabel.visible = true;
            feedbackLabel.text = feedback[random_number];

            //Flashing plus or minus scoreId
            flashingScoreText.text= (manyMakes>0)?("+"+pointsThisRound):(pointsThisRound)
            flashingScoreText.x= Math.random()*(flashingScore.width-flashingScoreText.implicitWidth)+1;
            flashingScoreText.y= Math.random()*(flashingScore.height-flashingScoreText.implicitHeight)+1;
            flashingScoreText.rotation= (Math.random()*100)-50;
            sliderId.enabled=false
            flashingScoreAnim.start();

            insideRectangleMouseArea.enabled = false; insideTheSliderRectangleMouseArea.enabled = false
        }
        Timer{
            id: isDoubleClickTimer
            interval:1550 //should be 500 maybe
        }

        Connections{
            target: Extra
            function onSpaceClickedInComp(){
                if(!isDoubleClickTimer.running){
                    isDoubleClickTimer.start()
                    whatToDoInsideRectangleMA();
                }
                else{
                    whatToDoWhenDoubleClicked();
                }
            }
        }
        MouseArea{
            id: insideRectangleMouseArea
            enabled: false;
            width: parent.width+20
            height: parent.height+20
            anchors.centerIn: parent
            propagateComposedEvents: true
            onClicked: {
                whatToDoInsideRectangleMA()
            }
            onDoubleClicked:{
                mouse.accepted=false;
            }
        }
        Slider{
            onValueChanged: {
                if(firstTime2){
                    if(value===1){
                        counterio=1;
                    }
                    if(counterio ==1 && value===500.5){
                        seqAnimationId.stop();
                        pointingFinger.visible=true;
                    }
                }
                if(level===3)
                {
                    mPauseAnim.stop();
                    pointingFinger.visible=false;
                    insideContainerId.sliderStopped(sliderId.value);
                    handleId.visible=true;
                    sliderId.enabled=false;
                    firstTime3=false;
                }
                else{
                    if(value===1)
                    {
                        seqAnimationId.restart()
                    }
                }
            }
            anchors.centerIn: parent
            id: sliderId
            from: 1;
            to: 1000;
            value: 200;
            width: 480;
            height: 30;
            enabled:insideRectangleMouseArea.enabled;
            MouseArea{
                id: insideTheSliderRectangleMouseArea
                enabled: false;
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    whatToDoInsideRectangleMA()
                    if(level===3){
                        enabled=false
                        mouse.accepted.false
                    }
                }
                onDoubleClicked:{
                    mouse.accepted=false;
                }
            }
            background: Rectangle{
                implicitHeight: 6
                height: implicitHeight
                radius: 8
                gradient: Gradient{
                    orientation: Gradient.Horizontal
                    GradientStop{position: 0.0; color: (level===3)?colors[0]:"#cf3732"}
                    GradientStop{position: (level===3)?0.1428:0.2; color:(level===3)?colors[0]:"#db8d44"}
                    GradientStop{position: (level===3)?0.1429:0.35; color:(level===3)?colors[1]:"#e3d430"}
                    GradientStop{position: (level===3)?0.2857:0.5; color:(level===3)?colors[1]:"#29c910"}
                    GradientStop{position: (level===3)?0.2858:0.65; color:(level===3)?colors[2]:"#e3d430"}
                    GradientStop{position: (level===3)?0.4286:0.8; color:(level===3)?colors[2]:"#db8d44"}
                    GradientStop{position: (level===3)?0.4287:1.0; color:(level===3)?colors[3]:"#cf3732"}
                    //below ones not used until level 3
                    GradientStop{position: (level===3)?0.5714:1.1; color:(level===3)?colors[3]:"#000000"}
                    GradientStop{position: (level===3)?0.5715:1.1; color:(level===3)?colors[4]:"#000000"}
                    GradientStop{position: (level===3)?0.7143:1.1; color:(level===3)?colors[4]:"#000000"}
                    GradientStop{position: (level===3)?0.7144:1.1; color:(level===3)?colors[5]:"#000000"}
                    GradientStop{position: (level===3)?0.8571:1.1; color:(level===3)?colors[5]:"#000000"}
                    GradientStop{position: (level===3)?0.8572:1.1; color:(level===3)?colors[6]:"#000000"}
                    GradientStop{position: (level===3)?1:1.1; color:(level===3)?colors[6]:"#000000"}
                }
                Rectangle {
                    height: parent.height
                    color: "#21be2b"
                    radius: 3
                }
            }
            handle: Rectangle {
                id: handleId
                x: sliderId.leftPadding + sliderId.visualPosition * (sliderId.availableWidth - width)
                y: sliderId.topPadding + sliderId.availableHeight / 2 - height / 2
                implicitWidth: 20
                implicitHeight: 50
                radius: 7
                //                color: sliderId.pressed ? "#f0f0f0" : "#ededed"
                color: sliderId.pressed ? "#141414":"#1c1c1c"
                border.color: "#9e9e9e"
            }
            SequentialAnimation{
                id: seqAnimationId
                NumberAnimation {
                    target: sliderId
                    property: "value"
                    to:1000
                    duration: mDuration
                    easing.type: sliderEasingType
                }
                NumberAnimation {
                    target: sliderId
                    property: "value"
                    to:0
                    duration: mDuration
                    easing.type: sliderEasingType

                }
            }
            PauseAnimation {
                onFinished: {
                    if(currentIndexForRandom===5)
                        currentIndexForRandom=0;
                    colors= currentRandomOrder5[currentIndexForRandom];
                    currentIndexForRandom+=1;
                    if(firstTime3===true&&currentIndexForRandom===4){
                        for(let i =0; i< colors.length; i++){
                            if(colors[i]==="#29c910"){
                                pointingFinger.x=sliderId.x-(pointingFinger.width/2)+(i/7*sliderId.width)+(1/14*sliderId.width)+165;
                                pointingFinger.y+= 34
                                pointingFingerAnimFront.to+=34
                                pointingFingerAnimBack.to+=34
                                firstTime3=false;
                                pointingFinger.visible=true;
                                break;
                            }
                        }
                    }
                    else
                        mPauseAnim.restart();
                }

                id: mPauseAnim
                duration: 1000
            }
        }
    }
    //splash animation
    MyAnimation{
        id: splashAnimation
        toX: rim.x+41;
        downEasingType: Easing.InQuad;
        toY: 50;
        animationDuration: 1600
        rotationNumber: 800
        onStopped:{
            whatToDoWhenAnimFinished()
        }
        onStarted: {
            splashSoundEffectTimer.start()
        }
    }
    MyTimer{
        id: splashSoundEffectTimer
        original:  1500
        onTimedOut: {
            splashSoundEffect.play()
        }
    }
    Audio{
        id: splashSoundEffect
        source:"../assets/sounds/splashSoundEffectCropped.mp3"
        volume: root.sound*1
        onPlaybackStateChanged: {
            if(playbackState===Audio.PlayingState){
                if(flipable.visible){
                    coinClinkSoundEffect.play()
                }
            }
        }
    }

    //air ball animation
    MyAnimation{
        id: airBallAnimation
        toX: rim.x-75;
        downEasingType: Easing.InQuad;
        toY: 250;
        animationDuration: 1600
        rotationNumber: 800
        otherToY: rim.y + 200
        percentageSmall: 0.4
        percentageLarge: 0.6
        shrink: false
        onStopped: {
            whatToDoWhenAnimFinished()
        }

    }

    //Backboard make
    SequentialAnimation{
        onStopped:{
            whatToDoWhenAnimFinished()
        }
        onStarted: {
            backboardMakeSoundEffectTimer.start()
        }
        id: backboardAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 92.5
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 92.5
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }

                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: backboard.y-20
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: backboard.x-basketBall.width+20
                        duration: 1600*0.8
                    }
                }
                ParallelAnimation{
                    NumberAnimation {
                        target: basketBall
                        property: "y"
                        to: rim.y-15
                        duration: 1600*0.2
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "x"
                        duration: 1600*0.2
                        to: rim.x+41
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "width"
                        to: 65+20
                        duration: 1600*0.2
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "height"
                        to: 65+20
                        duration: 1600*0.2
                        easing.type: Easing.Linear
                    }
                    SequentialAnimation{
                        id: rimRockId
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05
                        }
                        onFinished: {
                            if(counterr1<2){
                                rimRockId.start();
                                counterr1++;
                            }
                            else
                            {
                                rimRockId.rotation = 0;
                            }
                        }
                    }
                }
            }
        }
        PauseAnimation {
            duration: 400
        }
    }
    //SE
    MyTimer{
        id: backboardMakeSoundEffectTimer
        original:  1280
        onTimedOut: {
            backboardMakeSoundEffect.play()
            backboardMakeSoundEffectTimer2.start()
        }
    }
    Audio{
        id: backboardMakeSoundEffect
        source:"../assets/sounds/backboardMissSoundEffectCropped1.mp3"
        volume: root.sound*1

    }
    MyTimer{
        id: backboardMakeSoundEffectTimer2
        original:  180
        onTimedOut: {
            backboardMakeSoundEffect2.play()
        }
    }
    Audio{
        id: backboardMakeSoundEffect2
        source:"../assets/sounds/splashSoundEffectCropped.mp3"
        volume: root.sound*1
        onPlaybackStateChanged: {
            if(playbackState===Audio.PlayingState){
                if(flipable.visible){
                    coinClinkSoundEffect.play()
                }
            }
        }
    }

    //Backboard miss
    SequentialAnimation{
        onStopped:{
            whatToDoWhenAnimFinished()
        }
        onStarted: {
            backboardMissSoundEffectTimer.start()
        }
        id: backboardMissAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600*(0.8+0.65)
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 90+20-5
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 90+20-5
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: backboard.y-20
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: backboard.x-basketBall.width+20
                        duration: 1600*0.8
                    }
                }
                ParallelAnimation{
                    NumberAnimation {
                        target: basketBall
                        property: "y"
                        to: rim.y+200
                        duration: 1600*0.65
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "x"
                        duration: 1600*0.65
                        to: rim.x-300
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "width"
                        to: 110+20-5
                        duration: 1600*0.65
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "height"
                        to: 110+20-5
                        duration: 1600*0.65
                        easing.type: Easing.InCubic
                    }
                    SequentialAnimation{
                        id: rimRockId1
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05
                        }
                        onFinished: {
                            if(counterr1<2){
                                rimRockId1.start();
                                counterr1++;
                            }
                            else
                            {
                                rimRockId1.rotation = 0;
                            }
                        }
                    }
                }
            }
        }
        PauseAnimation {
            duration: 400
        }
    }
    //SE
    MyTimer{
        id: backboardMissSoundEffectTimer
        original:  1200
        onTimedOut: {
            backboardMissSoundEffect.play()
        }
    }
    Audio{
        id: backboardMissSoundEffect
        source:"../assets/sounds/backboardMissSoundEffectCropped.mp3"
        volume: root.sound*0.64
    }

    //Rim make
    SequentialAnimation{
        onStarted: {
            rimMakeSoundEffectTimer.start()
        }
        onStopped :{
            whatToDoWhenAnimFinished()
        }
        id: rimMakeAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 90+20-5
                                duration: 1600*0.25
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 90+20-5
                                duration: 1600*0.25
                                easing.type: Easing.InQuad
                            }

                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: rim.y-basketBall.height+25
                                duration: 1600*0.25
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: rim.x-basketBall.width/2+25
                        duration: 1600*0.75
                    }
                }
                ParallelAnimation{
                    SequentialAnimation{
                        id: rimRockId2
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05
                        }
                        onFinished: {
                            if(counterr1<2){
                                rimRockId2.start();
                                counterr1++;
                            }
                            else
                            {
                                rimRockId2.rotation = 0;
                            }
                        }
                    }
                    SequentialAnimation{
                        NumberAnimation {
                            target: basketBall
                            property: "y"
                            to: 150
                            duration: (1600*0.25)*0.65
                            easing.type: Easing.OutQuad
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 70+20-5
                                duration: 1600*0.25*0.75
                                easing.type: Easing.Linear
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 70+20-5
                                duration: 1600*0.25*0.75
                                easing.type: Easing.Linear
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "y"
                                to: rim.y-20
                                duration: (1600*0.25)*0.55
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "x"
                        to: rim.x+41
                        duration: 1600*0.25
                        easing.type: Easing.Linear
                    }
                }
                PauseAnimation {
                    duration: 400
                }
            }
        }
    }
    //SE
    MyTimer{
        id: rimMakeSoundEffectTimer
        original:  1200
        onTimedOut: {
            rimMakeSoundEffect.play()
        }
    }
    MyTimer{
        id: coinClinkSoundEffectForRimMakeTimer
        original: 300
        onTimedOut: {
            coinClinkSoundEffect.play()
        }
    }
    Audio{
        id: rimMakeSoundEffect
        source:"../assets/sounds/rimMakeSoundEffectCropped.mp3"
        volume: root.sound*1
        onPlaybackStateChanged: {
            if(playbackState===Audio.PlayingState){
                if(flipable.visible){
                    coinClinkSoundEffectForRimMakeTimer.start()
                }
            }
        }
    }

    //Rim miss
    SequentialAnimation{
        onStopped:{
            whatToDoWhenAnimFinished()
        }
        onStarted: {
            rimMissSoundEffectTimer.start()
        }
        id: rimMissAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600*1.7
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 75+20-5
                                duration: 1600*0.35
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 75+20-5
                                duration: 1600*0.35
                                easing.type: Easing.InQuad
                            }

                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: rim.y-60
                                duration: 1600*0.35
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: rim.x+50
                        duration: 1600*0.85
                    }
                }

                ParallelAnimation {
                    SequentialAnimation{
                        id: rimRockId3
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05

                            onFinished: {
                                if(counterr1<2){
                                    rimRockId2.start();
                                    counterr1++;
                                }
                                else
                                {
                                    rimRockId2.rotation = 0;
                                }
                            }
                        }
                        SequentialAnimation {
                            ParallelAnimation{
                                NumberAnimation {
                                    target: basketBall
                                    property: "width"
                                    to: 115+20-5
                                    duration: 1600*0.4
                                    easing.type: Easing.Linear
                                }
                                NumberAnimation {
                                    target: basketBall
                                    property: "height"
                                    to: 115+20-5
                                    duration: 1600*0.4
                                    easing.type: Easing.Linear
                                }

                                NumberAnimation {
                                    target: basketBall
                                    properties: "y"
                                    to: 140
                                    duration: 1600*0.4
                                    easing.type: Easing.OutQuad
                                }
                            }
                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: rim.y+150
                                duration: 1600 * 0.45
                                easing.type: Easing.InCubic
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: rim.x-350
                        duration: 1600*0.85
                    }

                }
            }
        }
        PauseAnimation {
            duration: 400
        }
    }
    //SE
    MyTimer{
        id: rimMissSoundEffectTimer
        original:  1290
        onTimedOut: {
            rimMissSoundEffect.play()
            rimMissSoundEffectTimer2.start()
        }
    }
    Audio{
        id: rimMissSoundEffect
        source:"../assets/sounds/rimMissSoundEffect2.mp3"
        volume: root.sound*0.8

    }
    MyTimer{
        id: rimMissSoundEffectTimer2
        original:  100
        onTimedOut: {
            rimMissSoundEffect2.play()
        }
    }
    Audio{
        id: rimMissSoundEffect2
        source:"../assets/sounds/rimMissSoundEffect2.mp3"
        volume: root.sound*0.3
    }
    Rectangle{
        id: dayNightStateRectId
        state: "day"
        states: [
            State{
                name: "day"
                PropertyChanges {
                    target: skyStartGradient
                    color: "#0080FF"
                }
                PropertyChanges {
                    target: skyEndGradient
                    color: "#66CCFF"
                }
                PropertyChanges {
                    target: groundStartGradient
                    color: "#00FF00"
                }
                PropertyChanges {
                    target: groundEndGradient
                    color: "#00803F"
                }
                PropertyChanges{
                    target: sun
                    color: "yellow"
                }

                PropertyChanges {
                    target: moonInSun
                    visible: false
                }
                PropertyChanges {
                    target: feedbackLabel
                    color: "black"
                }
                PropertyChanges {
                    target: coinInTheCornerText
                    color: "black"
                }
            },
            State{
                name: "night"
                PropertyChanges {
                    target: skyStartGradient
                    color: "#00008c"
                }
                PropertyChanges {
                    target: skyEndGradient
                    color: "#2020d6"
                }

                PropertyChanges {
                    target: groundStartGradient
                    color: "#045c16"
                }
                PropertyChanges {
                    target: groundEndGradient
                    color: "#177a2c"
                }
                PropertyChanges{
                    target: sun
                    color: "transparent"
                }

                PropertyChanges {
                    target: moonInSun
                    visible: true
                }
                PropertyChanges {
                    target: feedbackLabel
                    color: "white"
                }
                PropertyChanges {
                    target: coinInTheCornerText
                    color: "white"
                }
            }
        ]
        transitions: [
            Transition {
                from: "*"
                to: "*"
                ColorAnimation {
                    duration: 1000
                }
                NumberAnimation{
                    property: opacity
                    duration: 100
                }
            }
        ]
    }

    Rectangle{
        id: stateRectId
        state: "notPaused"
        states: [
            State {
                name: "paused"
                PropertyChanges {
                    target: pauseRectangle
                    visible: true
                }
            },
            State {
                name: "notPaused"
                PropertyChanges {
                    target: pauseRectangle
                    visible: false
                }
            }
        ]
        transitions: [
            Transition {
                from: "*"
                to: "*"
                ColorAnimation {
                    duration: 500
                }
                NumberAnimation{
                    property: opacity
                    duration: 500
                }
            }
        ]
    }
    Component{
        id: halftimeModeComponent
        HalftimeMode{
        }
    }
}

