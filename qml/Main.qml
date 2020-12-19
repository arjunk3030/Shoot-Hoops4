import Lebron2 1.0
import QtQml.Models 2.2
import Felgo 3.0
import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.0
import QtQuick.Controls 2.12
import QtMultimedia 5.8

////New VERSION STARTS HER E
GameWindow {
    visible: true
    //    width: 708
    //    height: 785
    property var p: false
    property var thisTitle: "Shoot Hoops"
    property var mArray:[]
    property var firstTime5: true;
    property var currentMissionRewards: 0;
    property var arr: []
    property var presentMissions: [];

    property bool shouldBeginThirdLevel: false
    property var shotRandomNumber: 0;
    property var levelRandomNumber:0
    property var levelOptions: [1,1,1,1,1,2,2,2,2,2,3,3,0,0]
    property var typesOfShotPossible:["backboard","rim", "splash"]

    property bool adScreenHappening: false;
    property bool backButtonClickedWhenAdScreen: false;
    property bool retryScreenHappening: false;
    property var counter14: [];
    property bool firstTimeUpdatingMissions: true
    property int countingUpdatingMissions: 0;
    property int points: 0;
    property real textMultiplier: 1.43;
    id: root


    //these ones used to be from Extra
    property double volume: 0.65;
    property double sound: 0.93;
    property int numCoins: 5;
    property string ballSource:"../assets/images/balls/basketBall.png";
    property int personalBest: 0;
    property string datastore: "";
    property string miniStore:""
    property string endingPage: ""
    property bool firstTimeEVER: true;
    //        width: 708
    //        height: 785
    //settings is now in storage instead of QSettings
    Component.onCompleted: {
//                settings.clearAll()
        //other stuff
        mMusic1.play()
        //        //save volume
        //        if(!settings.getValue("volume")){
        //            settings.setValue("volume", root.volume);
        //        }
        //        else{
        //            console.log("ROOT VOLUME IS"+root.volume)
        //        }
        //        //save sound
        //        if(!settings.getValue("sound"))
        //            settings.setValue("sound", sound);
        //        else
        //            sound = settings.getValue("sound");
        //save coins
        if(!settings.getValue("coins"))
            settings.setValue("coins", numCoins);
        else{
            numCoins = settings.getValue("coins");
        }
        //        //save ball source
        if(!settings.getValue("ballSource"))
            settings.setValue("ballSource", ballSource);
        else
            ballSource = settings.getValue("ballSource");
        //save personal best
        if(!settings.getValue("personalBest")){
            settings.setValue("personalBest", personalBest);
        }
        else{
            personalBest = settings.getValue("personalBest");
        }
        //save datastore
        if(!settings.getValue("datastore"))
            settings.setValue("datastore", datastore);
        else{
            datastore = settings.getValue("datastore");
        }
        //other settings (mostly one time)
        //save counter 14
        if(!settings.getValue("counter14"))
            settings.setValue("counter14", counter14);
        else
            counter14 = settings.getValue("counter14");
        //save firstTimeUpdatingMissions
        if(!settings.getValue("firstTimeUpdatingMissions"))
            settings.setValue("firstTimeUpdatingMissions", firstTimeUpdatingMissions);
        else
            firstTimeUpdatingMissions = settings.getValue("firstTimeUpdatingMissions");
        //        //save firstTimeEVER
        if(!settings.getValue("firstTimeEVER"))
            settings.setValue("firstTimeEVER", false);
        else
            firstTimeEVER = settings.getValue("firstTimeEVER");
        aboutDialog.visible=firstTimeEVER
        firstTimeEVER=false;
        if ( datastore) {
            mMissionModel.clear()
            var datamodel = JSON.parse(datastore)
            for (let i = 0; i < datamodel.length; ++i) mMissionModel.append(datamodel[i])
        }
//        console.log("PRESENT MISSIOSN ARE"+presentMissions)
        if(presentMissions.length!==0){
            displayDelegateModel.items.remove(0,displayDelegateModel.items.count);
            displayDelegateModel.items.insert(mMissionModel.get(presentMissions[0]), "todaysMissions");
            displayDelegateModel.items.insert(mMissionModel.get(presentMissions[1]), "todaysMissions");
            displayDelegateModel.items.insert(mMissionModel.get(presentMissions[2]), "todaysMissions");
        }
        else{
            updateMissions();
        }
    }
    Component.onDestruction: {
        //for how to play not popping up every time
        firstTimeEVER= false;
        presentMissionsChanged()
        counter14Changed();
        mMusic1.stop()
        storeForSettings();
//        console.log("Present missions current things"+mMissionModel.get(presentMissions[0]).currentThings)
//        console.log("Present missions current things"+mMissionModel.get(presentMissions[1]).currentThings)
//        console.log("Present missions current things"+mMissionModel.get(presentMissions[2]).currentThings)

        var datamodel = []
        for (let i = 0; i < mMissionModel.count; ++i) datamodel.push(mMissionModel.get(i))
        datamodel =  JSON.stringify(datamodel)
        settings.setValue("datastore", datamodel)

        settings.setValue("coins", numCoins);
        settings.setValue("ballSource", ballSource);
        settings.setValue("personalBest", personalBest);
        settings.setValue("counter14", counter14);
        settings.setValue("firstTimeUpdatingMissions", firstTimeUpdatingMissions);


        settings.setValue("firstTimeEVER", firstTimeEVER);
        //        settings.setValue("volume", volume);
        //        settings.setValue("sound", sound);
    }
    Storage{
        id: settings
    }
    //font loader
    FontLoader{id: impact; source: "../assets/Fonts/Impact/impact.ttf"}
    FontLoader{id: bodoniMTBlack; source: "../assets/Fonts/BodoniMTBlack/bod_blar.ttf"}
    FontLoader{id: geniso; source: "../assets/Fonts/Geniso/Geniso.ttf"}
    FontLoader{id: stencil; source: "../assets/Fonts/Gunplay/gunplay.ttf"}
    FontLoader{id: snapITC; source: "../assets/Fonts/SnapITC/SnapITC.ttf"}
    FontLoader{id: centuryGothic; source: "../assets/Fonts/CenturyGothic/CenturyGothic.ttf"}

    Scene {
        id: settingsDialog
        width: mainScene.width
        height: mainScene.height
        anchors.centerIn: mainScene
        z:10
        visible: false
        onVisibleChanged: {
            if(visible)
                myDialog.show()
        }
        CustomSDialog{
            anchors.centerIn: parent
            id: myDialog
            box.color: "white"
            modal: true
        }
    }

    //    SettingsManager{
    //        id: s_manager
    //    }
    Connections {
        target: Qt.application
        // Qt.application.state:     0 - mimimized
        //                           2 - lost focus
        //                           4 - got focus
        onStateChanged: {

            if (Qt.application.state === 0) {
                mMusic1.pause();
            }
            else if (Qt.application.state === 2) {

                mMusic1.pause()
            }
            else if (Qt.application.state === 4) {
                mMusic1.play()
            }
        }
    }
    Audio{
        id: mMusic1
        source:"../assets/sounds/backgroundMusic.mp3"
        volume: root.volume*6/11
        loops: Audio.Infinite
    }
    //may no longer be used
    Connections{
        target: Extra;
        function onSomethingCompetitiveChanged(){
            navigationStack.pop()
        }
        function onGoToHalftime(){
            navigationStack.push(halftimeModeComponent)
        }
    }

    //--------------------------------------------------------------------------------------------------------------MISSIONS START HERE
    function storeForSettings(){
        if(presentMissions.length===0){
            presentMissions.push(displayDelegateModel.items.get(0).model.index);
            presentMissions.push(displayDelegateModel.items.get(1).model.index);
            presentMissions.push(displayDelegateModel.items.get(2).model.index);
        }
//        console.log("present Missions"+presentMissions)
        presentMissionsChanged()
    }
    function checkIfCurrentMission(num){
        for(let i =0; i< 3; i++){
            if(presentMissions[i]===num){
                return true;
            }
        }
        return false;
    }
    function checkIfButtonNeedsToBeVisible(whatFor){
        let thing = false;
        currentMissionRewards=0;
        for(let i =0; i< 3; i++){
            if( mMissionModel.get(presentMissions[i]).currentThings>=mMissionModel.get(presentMissions[i]).neededThings && mMissionModel.get(presentMissions[i]).completed!==true){
                if(whatFor)
                    currentMissionRewards+= mMissionModel.get(presentMissions[i]).reward
                thing=true;
            }
        }
        return thing
        //        }
    }
    Timer{
        interval: 1001
        id: delayTimer
    }
    function partUpdatingMissions(){
        if(!firstTimeUpdatingMissions){
            mMissionModel.remove(17)
        }
        else{
            firstTimeUpdatingMissions=false
        }
        var rowCount = mMissionModel.count
        mArray = []

        for(let i =0;i < rowCount;i++ ) {
            let entry = mMissionModel.get(i)
            //            if((!entry.multipleTimes || !entry.completed))
            mArray.push(entry)
        }
        arr = mArray.sort(() => Math.random() - Math.random()).slice(0, 2)    /*add back later*/
        if(arr[0]===mMissionModel.get(16)||arr[1]===mMissionModel.get(16)){
            var pointsScoredAndReward=[[1000,2],[2000,4],[4000,7],[5000,9],[6000,19],[7000,24],[8000,25],[9000,26],[10555,30]]
            var randomNumberForPointsMission= Math.floor(Math.random()*pointsScoredAndReward.length)
            mMissionModel.get(16).neededThings = pointsScoredAndReward[randomNumberForPointsMission][0]
            mMissionModel.get(16).reward = pointsScoredAndReward[randomNumberForPointsMission][1]
            mMissionModel.get(16).description = "Score "+pointsScoredAndReward[randomNumberForPointsMission][0] +" points in a game. Record:"
        }
        counter14=[];
        for(let h =0; h < arr.length; h++){
            //subject to change
            arr[h].completed=false
            arr[h].currentThings=0;
        }
        //        //we now want two with one extra special at the end
        var numberOfTimesAndCoins = [[2,2],[3,4],[4,6],[5,9],[6,10],[7,12],[8,16],[9,19]]
        typesOfShotPossible = ["backboard","rim", "splash"]
        levelOptions = [1,1,1,1,1,2,2,2,2,2,3,3,0,0]
        var thisRandomNumber = Math.floor((Math.random()*numberOfTimesAndCoins.length));
        tempModel.get(0).neededThings=numberOfTimesAndCoins[thisRandomNumber][0];
        tempModel.get(0).reward=numberOfTimesAndCoins[thisRandomNumber][1];
        shotRandomNumber = Math.floor((Math.random()*typesOfShotPossible.length));
        levelRandomNumber = Math.floor((Math.random()*levelOptions.length));
        tempModel.get(0).description=(typesOfShotPossible[shotRandomNumber]==="splash")?("Splash "+ tempModel.get(0).neededThings+" times in a row in "):("Make at the " + typesOfShotPossible[shotRandomNumber] + " " +tempModel.get(0).neededThings+" times in a row in ");
        tempModel.get(0).description+=(levelOptions[levelRandomNumber]===0)?("any level"):("level "+levelOptions[levelRandomNumber]);
        tempModel.get(0).description+= ". Record:"
        //adding it to the end
        var datamodel = []
        for (let t = 0; t < tempModel.count; ++t) datamodel.push(tempModel.get(t))
        let b = JSON.stringify(datamodel)
        datamodel = JSON.parse(b)
        for (let k = 0; k < datamodel.length; ++k){
            mMissionModel.append(datamodel[k])
        }
        arr.push(mMissionModel.get(mMissionModel.count-1));
    }
    function updatingMissionsDuringGame(){
        //        countingUpdatingMissions++;
        //make missions invisible here
        partUpdatingMissions()

        //        displayDelegateModel.items.insert(arr[0], "todaysMissions");
        //        displayDelegateModel.items.insert(arr[1], "todaysMissions");
        //        displayDelegateModel.items.insert(arr[2], "todaysMissions");
        //        presentMissions=[]
        //        storeForSettings();
        presentMissions=[]
        presentMissions.push(arr[0].index);
        presentMissions.push(arr[1].index);
        presentMissions.push(arr[2].index);
//        console.log("Pressent missions"+presentMissions)
        setCurrentMissions()
        let s = 0
        for(s = 0; s<4; s++){ //displayDelegateModel.items.count-1-s
            displayDelegateModel.items.get(s).model.index=mMissionModel.get(presentMissions[s]).index
            displayDelegateModel.items.get(s).model.completed=mMissionModel.get(presentMissions[s]).completed
            displayDelegateModel.items.get(s).model.description=mMissionModel.get(presentMissions[s]).description
            displayDelegateModel.items.get(s).model.multipleTimes=mMissionModel.get(presentMissions[s]).multipleThings
            displayDelegateModel.items.get(s).model.reward=mMissionModel.get(presentMissions[s]).reward
            displayDelegateModel.items.get(s).model.neededThings=mMissionModel.get(presentMissions[s]).neededThings
            displayDelegateModel.items.get(s).model.currentThings=mMissionModel.get(presentMissions[s]).currentThings
        }

        displayDelegateModel.items.insert(arr[0], "todaysMissions");
        displayDelegateModel.items.insert(arr[1], "todaysMissions");
        displayDelegateModel.items.insert(arr[2], "todaysMissions");
        if(!delayTimer.running)
            delayTimer.start()
    }

    Connections{
        id: flashingTimerConnection
        target: FlashingTimer
        function onCallUpdateMissions(){
            updatingMissionsDuringGame()
        }
    }
    function updateMissions(){
        displayDelegateModel.items.remove(0,displayDelegateModel.items.count)
        partUpdatingMissions()

        displayDelegateModel.items.insert(arr[0], "todaysMissions");
        displayDelegateModel.items.insert(arr[1], "todaysMissions");
        displayDelegateModel.items.insert(arr[2], "todaysMissions");
        presentMissions=[]
        storeForSettings();
    }
    //temp model
    ListModel{
        id: tempModel
        ListElement{//last index of mMissionModel
            index: 17
            completed: false;
            description: ""
            multipleTimes: true
            reward: 0;
            neededThings: 0
            currentThings: 0
        }
    }

    function help() {
        let url = "https://akumar-30.github.io/ShootHoops/"
        Qt.openUrlExternally(url)
    }
    Timer{
        id: thePauseTimer
        interval: 1000
        onTriggered: {

            //update delegate with updated model
            for(let s = 0; s< 3; s++){
                //                    if(presentMissions.length===0)
                //                        displayDelegateModel.items.get(displayDelegateModel.items.count-1-s).model.currentThings=mMissionModel.get(displayDelegateModel.items.get(displayDelegateModel.items.count-1-s).model.index).currentThings
                //                    else
                //                displayDelegateModel.items.get(displayDelegateModel.items.count-1-s).model.currentThings=mMissionModel.get(presentMissions[2-s]).currentThings
//                console.log("displayDelegateModel.items.get(s).model.currentThings"+ displayDelegateModel.items.get(s).model.currentThings)
                displayDelegateModel.items.get(s).model.currentThings=mMissionModel.get(presentMissions[s]).currentThings
            }
        }
    }
    Item{
        id: clicker
        anchors.fill: parent
        focus: true
        Keys.onDigit5Pressed: {
            if(event.modifiers===Qt.ControlModifier){
                verification.visible=true;
            }
        }
    }
    Settings{
        category: "windows"
        property alias x: root.x
        property alias y: root.y
    }
    Settings{
        category: "missions"
    }
    property bool shouldExtraVolumeChange: true
    property bool shouldExtraSoundChange: true
    Scene {
        id: warningDialog
        width: mainScene.width
        height: mainScene.height
        anchors.centerIn: mainScene
        z:10
        visible: false
        onVisibleChanged: {
            if(visible)
                myDialog1.show()
        }
        CustomWDialog{
            anchors.centerIn: parent
            id: myDialog1
            box.color: "white"
            modal: true
            onSelectedOk: {
                if(Extra.endingPage==="HalfimeMode.qml"){
                    navigationStack.pop()
                    navigationStack.pop()
                }
                else
                    navigationStack.pop()
                myDialog1.hide()
                thisTitle = "Shoot Hoops"
                //starting timer
                thePauseTimer.start()
            }
            onSelectedCancel: {
                myDialog1.hide()
            }
        }
    }
    Scene {
        id: aboutDialog
        width: mainScene.width
        height: mainScene.height
        anchors.centerIn: mainScene
        z:10
        visible:false
        onVisibleChanged: {
            if(visible)
                myDialog2.show()
        }
        CustomHDialog{
            anchors.centerIn: parent
            id: myDialog2
            box.color: "white"
            modal: true
        }
    }
    function makeMissionsInvisible(){
        missionsScene.visible=false
        missionsScene.scale=0
    }

    Scene{
        z:4
        id: missionsScene
        width: 708
        height: 1270
        anchors.centerIn: mainScene
        visible: false;
        //MISSSIONS START HERE+++++++++++++++++++++++++++++++++++
        // animation to hide the dialog
        ParallelAnimation {
            id: showMissionsAnimation
            onStarted: {
                missionsScene.visible = true
            }
            NumberAnimation {
                target: missionsScene
                property: "scale"
                from: 0
                to: 1
                easing.type: Easing.OutBack
                duration: 250
            }
        }
        ParallelAnimation {
            id: hideMissionsAnimation
            NumberAnimation {
                target: missionsScene
                property: "scale"
                from: 1
                to: 0
                easing.type: Easing.InBack
                duration: 250
            }
            onStopped: {
                // set it invisible when the animation has finished to disable MouseAreas again
                missionsScene.visible = false
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(missionsScene.visible){
                    hideMissionsAnimation.start()
                }
            }
        }
        Rectangle {
            z:17
            id: mainRect
            width: parent.width*2/3
            height: parent.height*3/5
            anchors.centerIn: parent
            border.color:"#2e8ddb"
            border.width:3
            Rectangle{
                anchors.top: parent.top
                id: header
                width: parent.width
                height: 100
                color: "#2e8ddb"
                Text{
                    anchors.fill: parent
                    color: "#ffffff"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: textMultiplier* 36
                    text: "Missions"
                    anchors.centerIn: parent
                    //                    font.family: "Complex"
                    font.family: bodoniMTBlack.name
                }
            }
            Rectangle{
                id: headerFade
                width: parent.width
                anchors.top:header.bottom
                height: 15
                color: "#18549e"
            }
            Text{
                id: countdownText
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                anchors.top: headerFade.bottom
                text: "NEXT MISSIONS IN "+whatToPrint;
                font.family: geniso.name
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                color: "#595756"
                y: header.y+25
                font.pointSize: textMultiplier* 16
            }
            //Actual model stuff START HERE-----------------------------------
            ListModel{
                id: mMissionModel
                ListElement{//0
                    index: 0
                    completed: false;
                    description: "Splash 3 times in a row. Record: "
                    multipleTimes: true
                    reward: 2;
                    neededThings: 3
                    currentThings: 0
                }
                ListElement{//1
                    index: 1
                    completed: false;
                    description: "Splash 6 times in a row. Record: "
                    multipleTimes: true
                    reward: 4;
                    neededThings: 6
                    currentThings: 0
                }
                ListElement{//2
                    index: 2
                    completed: false;
                    description: "Splash 11 times in a row. Record: "
                    multipleTimes: true
                    reward: 12;
                    neededThings: 11
                    currentThings: 0
                }
                ListElement{//3
                    index: 3
                    completed: false;
                    description: "Miss at the backboard two consecutive times. Record:"
                    multipleTimes: true
                    reward: 2;
                    neededThings: 2
                    currentThings: 0
                }
                ListElement{//4
                    index: 4
                    completed: false;
                    description: "Make at the rim 4 times in a row in level 3. Record:"
                    multipleTimes: true
                    reward: 12;
                    neededThings: 4
                    currentThings: 0
                }
                ListElement{//5
                    index: 5
                    completed: false;
                    description: "Make at the backboard 9 times in a row in level 2. Record:"
                    multipleTimes: true
                    reward: 23;
                    neededThings: 9
                    currentThings: 0
                }
                ListElement{//6
                    index: 6
                    completed: false;
                    description: "Splash the ball 8 times in a row during level 3. Record:"
                    multipleTimes: true
                    reward: 7;
                    neededThings: 8
                    currentThings: 0
                }
                ListElement{//7
                    index: 7
                    completed: false;
                    description: "Make all the shots in level 1. Record"
                    multipleTimes: true
                    reward: 9;
                    neededThings: 16
                    currentThings: 0
                }
                ListElement{//8
                    index: 8
                    completed: false;
                    description: "Make all the shots in level 2. Record"
                    multipleTimes: true
                    reward: 23;
                    neededThings: 18
                    currentThings: 0
                }
                ListElement{//9
                    index: 9
                    completed: false
                    description: "Miss two consecutively at the rim in level 3. Record:"
                    multipleTimes: true
                    reward: 4;
                    neededThings: 2
                    currentThings: 0
                }
                ListElement{//10
                    index: 10
                    completed: false;
                    description: "Get exactly 4 coins in a game in a twice"
                    multipleTimes: true
                    reward: 4;
                    neededThings: 2
                    currentThings: 0
                }
                ListElement{//11
                    index: 11
                    completed: false;
                    description: "Advance to level 3 while earning zero coins in the match"
                    multipleTimes: true
                    reward: 14;
                    neededThings: 1
                    currentThings: 0
                }
                ListElement{//12
                    index: 12
                    completed: false;
                    description: "Complete the other two challenges."
                    multipleTimes: true
                    reward: 4;
                    neededThings: 2
                    currentThings: 0
                }
                ListElement{//13
                    index: 13
                    completed: false;
                    description: "Make at the backboard four consecutive times. Record: "
                    multipleTimes: true
                    reward: 4;
                    neededThings: 4
                    currentThings: 0
                }
                ListElement{//14
                    index: 14
                    completed: false;
                    description: "Play a game with three different balls"
                    multipleTimes: false
                    reward: 5;
                    neededThings: 3
                    currentThings: 0
                }
                ListElement{//15
                    index: 15
                    completed: false;
                    description: "Purchase a new ball"
                    multipleTimes: false
                    reward: 8;
                    neededThings: 1
                    currentThings: 0
                }
                ListElement{//16
                    index: 16
                    completed: false;
                    description: "Score "
                    multipleTimes: false
                    reward: 0;
                    neededThings: 0
                    currentThings: 0
                }


                //            ListElement{//7
                //                index: 7
                //                completed: false;
                //                description: "Buy 3 different types of balls"
                //                multipleTimes: false
                //                reward: 8;
                //                neededThings: 3
                //                currentThings: 0
                //            }
                //            ListElement{//10
                //                index: 10
                //                completed: false;
                //                description: "Earning 8 coins in a game. Record: "
                //                multipleTimes: true
                //                reward: 4;
                //                neededThings: 1
                //                currentThings: 0
                //            }


                //            ListElement{//14
                //                index: 14
                //                completed: false;
                //                name: ""
                //                description: "Advance to level 2 while earning zero coins in the match"
                //                multipleTimes: true
                //                reward: 9;
                //                neededThings: 1
                //                currentThings: 0
                //            }
            }
            Component{
                id: mMissionDelegate

                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: mainRect.width-25
                    height: width*1/4+50
                    id: outsideComponentRect
                    Rectangle{
                        visible: (completed)
                        width: outsideComponentRect.width
                        height: outsideComponentRect.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "white"
                        border.width: 12
                        border.color: "#7ae868"
                        Text{
                            anchors.centerIn: parent
                            text: "COMPLETED"
                            font.family: "Segoe UI Light"
                            font.bold: true
                            font.underline: true
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: textMultiplier* 20
                            color: "#7ae868"

                        }
                    }
                    Rectangle{
                        visible: !completed
                        width: outsideComponentRect.width
                        height: outsideComponentRect.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "transparent"
                        Rectangle{
                            id: mainDelegateRect
                            width: parent.width
                            height: parent.height-12
                            anchors.verticalCenter: parent.verticalCenter
                            color: (currentThings>=neededThings)?"#7ae868":"#2e8ddb"
                            Column{
                                x:16
                                y:10
                                spacing: 12;
                                width: parent.width
                                Text{
                                    id: theText
                                    y:15
                                    font.family: centuryGothic.name
                                    font.bold: true
                                    width: parent.width*2/3+15
                                    wrapMode: Text.Wrap
                                    font.pointSize: textMultiplier* 14
                                    color: "white"
                                    text:description
                                    //description text
                                }
                                Row{
                                    spacing:2
                                    //progress bar
                                    ProgressBar {
                                        id: thingsLeft
                                        value: currentThings/neededThings
                                        padding: 2
                                        Text{
                                            z:3
                                            anchors.centerIn: parent
                                            color: "white"
                                            font.family: centuryGothic.name
                                            font.bold: true
                                            font.pointSize: textMultiplier* 18
                                            text:(currentThings>=neededThings)?(neededThings+"/"+neededThings):(currentThings+"/"+neededThings)
                                        }
                                        background: Rectangle {
                                            implicitWidth: theText.width
                                            implicitHeight: 40
                                            color: "#000000"
                                            radius: 2
                                        }
                                        contentItem: Item {
                                            implicitWidth: theText.width
                                            implicitHeight: 30
                                            Rectangle {
                                                width: thingsLeft.visualPosition * parent.width
                                                height: parent.height
                                                radius: 2
                                                color: "#06bf0c"
                                            }
                                        }
                                    }
                                    //filler space
                                    Rectangle{
                                        width: 30
                                        height: 2
                                        color: "transparent"
                                    }
                                    //reward
                                    Text{
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: "black"
                                        font.family: centuryGothic.name
                                        font.bold: true
                                        font.pointSize: textMultiplier* 20
                                        text:reward
                                    }
                                    //coin pic
                                    Image{
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 40
                                        height: 40
                                        source: "../assets/images/coinFront.png"
                                    }
                                }
                            }
                        }
                    }
                }
            }
            ListView {
                id: listOfMissions
                z:18
                anchors.top: countdownText.bottom
                width: parent.width
                height: parent.height-header.height-headerFade.height-countdownText.height-getRewardsButton.height-15
                x: 0;
                spacing: 10
                model: displayDelegateModel             // 6
                interactive: false;
            }
            DelegateModel {
                id: displayDelegateModel
                delegate:  mMissionDelegate
                model: mMissionModel
                groups: [
                    DelegateModelGroup   {
                        id: mDelegateGroupModel
                        includeByDefault: false
                        name: "todaysMissions"
                    }
                ]
                filterOnGroup: "todaysMissions"
            }
            //Actual model stuff ENDS HERE------------------------------------------------------------
            //get rewards button
            Button{
                onClicked: {
                    if(visible){
                        numCoins+= currentMissionRewards;
                        //remove delegates for completed missions
                        let j =0;
                        for(let i =displayDelegateModel.items.count-3; i< displayDelegateModel.items.count;i++){
                            if(displayDelegateModel.items.get(i).model.currentThings>=displayDelegateModel.items.get(i).model.neededThings){
                                displayDelegateModel.items.get(i).model.completed=true;
                                mMissionModel.get(presentMissions[i]).completed=true
                            }
                            j++;
                        }
                        visible=false;
                        getRewardsButtonFade.visible=false;
                    }
                }
                visible: currentMissionRewards!=0;
                z: 19
                id: getRewardsButton
                anchors.top: listOfMissions.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                height: 80
                width: 200
                Rectangle{
                    anchors.fill: parent
                    color: "#7ae868"
                }
                Row{
                    x:10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        color: "black"
                        font.family: centuryGothic.name
                        font.bold: true
                        font.pointSize: textMultiplier* 25
                        text:"Get"
                    }
                    Rectangle{
                        width: 15
                        height: 3
                        color: "transparent"
                    }

                    //text
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        color: "black"
                        font.family: centuryGothic.name
                        font.bold: true
                        font.pointSize: textMultiplier* 25
                        text: currentMissionRewards
                    }
                    //coin pic
                    Image{
                        anchors.verticalCenter: parent.verticalCenter
                        width: 40
                        height: 40
                        source: "../assets/images/coinFront.png"
                    }
                }
            }
            Rectangle{
                visible: currentMissionRewards!=0;
                id: getRewardsButtonFade
                width: getRewardsButton.width
                height: getRewardsButton.height
                y: getRewardsButton.y+5
                x: getRewardsButton.x-5
                color: "#147307"
            }

            //            //ADS FOR THE MONEY MONEY MONEY
            //            Button{
            //                //these are the rewarded ad stuff IGNORE ERRORS FOR NOW
            //                //                        AdMobRewardedVideo {
            //                //                            id: myRewardedVideo
            //                //                            // test ad for rewarded videos
            //                //                            adUnitId: "ca-app-pub-3940256099942544/5224354917"

            //                //                            onRewardedVideoRewarded: {
            //                //updatingMissionsDuringGame();
            //                //                            // load rewarded video at app start to cache it
            //                //                            Component.onCompleted: {
            //                //                                loadRewardedVideo()
            //                //                            }
            //                //                        }
            //                onClicked: {
            //                    if(visible){
            //                        //                        // show the new video if user is below 10 credits
            //                        //                        myRewardedVideo.showRewardedVideoIfLoaded()
            //                        //                        // load a new video every time it got shown, to give the user a fresh ad
            //                        //                        myRewardedVideo.loadRewardedVideo()
            //                        numCoins-=10;
            //                        updatingMissionsDuringGame();
            //                    }
            //                }
            //                visible: (!getRewardsButton.visible&&countingUpdatingMissions<1);
            //                z: 19
            //                id: newMissionsAdButton
            //                anchors.top: listOfMissions.bottom
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                height: 80
            //                width: 140*3
            //                Rectangle{
            //                    anchors.fill: parent
            //                    color: "#2e8ddb"
            //                }
            //                Row{
            //                    x:10
            //                    anchors.verticalCenter: parent.verticalCenter
            //                    anchors.centerIn: parent
            //                    Text{
            //                        anchors.verticalCenter: parent.verticalCenter
            //                        color: "White"
            //                        font.family: centuryGothic.name
            //                        font.bold: true
            //                        font.pointSize: textMultiplier* 30
            //                        text:"New Missions"
            //                    }
            //                    Rectangle{
            //                        width: 15
            //                        height: 2
            //                        color: "transparent"
            //                    }
            //                    //video pic
            ////                    Image{
            ////                        anchors.verticalCenter: parent.verticalCenter
            ////                        width: 50*1.35
            ////                        height: 35*1.35
            ////                        source: "../assets/images/PlayAdVideo.png"
            ////                    }
            //                    //coin pic
            //                    Image{
            //                        anchors.verticalCenter: parent.verticalCenter
            //                        width: (50+35)/2*1.35
            //                        height: (50+35)/2*1.35
            //                        source: "../assets/images/coinFront.png"
            //                    }
            //                }
            //            }
            //            Rectangle{
            //                visible: newMissionsAdButton.visible;
            //                id: newMissionsAdButtonFade
            //                width: newMissionsAdButton.width
            //                height: newMissionsAdButton.height
            //                y: newMissionsAdButton.y+5
            //                x: newMissionsAdButton.x-5
            //                color: "#18549e"
            //            }
        }
        Rectangle{
            visible:true;
            z:16
            id: mainRectFade
            x: mainRect.x-10
            y: mainRect.y+17
            width: mainRect.width
            height:mainRect.height
            color: "#18549e"
        }
    }
    //MISSIOSN ENDS HERE_________________________________

    //cool kids style with the navigation toolBar
    Scene{
        width: 708
        height: 1270
        id: mainScene
        NavigationBar{
            height: /*60*/85
            width: parent.width
            id: newNavigationBar
            leftBarItem: NavigationBarItem{
                visible:  navigationStack.depth>1
                contentWidth: 38
                IconButtonBarItem{
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    icon: IconType.arrowleft
                    iconSize: 38
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        if(Extra.endingPage=="HalftimeMode.qml"){
                            warningDialog.visible=true;
                        }
                        if(Extra.endingPage==="CompetitiveMode.qml"){
                            if(adScreenHappening!==true&&retryScreenHappening!==true)
                                warningDialog.visible=true;
                            else if(adScreenHappening===true){
                                backButtonClickedWhenAdScreen=true
                                //                            warningDialog.box.accepted()
                                //                            warningDialog.box.selectedOk()
                                myDialog1.selectedOk()
                            }
                             else{
                                //                            warningDialog.box.selectedOk()
                                myDialog1.selectedOk()
                                //                            warningDialog.box.accepted()
                            }
                        }
                        else
                            navigationStack.pop()
                    }
                }
            }
            titleItem: Text{
//                x:165
                y:5
                font.pointSize: textMultiplier* 25
                font.bold: true
                text:navigationStack.currentPage.title
                anchors.horizontalCenter: root.horizontalCenter
                font.family: centuryGothic.name
                color: "white"
            }

            rightBarItem:NavigationBarItem{
                contentWidth: 20
                IconButtonBarItem{
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    icon: IconType.ellipsisv
                    iconSize: 40
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        optionsMenu.open()

                    }
                }
                //                IconButtonBarItem{
                //                color: "white"
                //                icon: IconType.ellipsisv
                //                iconSize: newNavigationBar.size-10
                //                onClicked: {
                //                    optionsMenu.open()
                //                }
                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight
                    Action {
                        text: "Settings"
                        onTriggered: settingsDialog.visible=true
                    }
                    Action {
                        text: "How to play?"
                        onTriggered: aboutDialog.visible=true
                    }
                    Action {
                        text: "Help"
                        onTriggered: help()
                    }
                }
            }
        }
        NavigationStack{
            anchors.top: newNavigationBar.bottom
            id: navigationStack
            navigationBar.visible: false
            width: parent.width
            height: parent.height
            initialPage:Page {
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        if(missionsScene.visible){
                            //                            missionsScene.visible=false
                            hideMissionsAnimation.start()
                        }
                    }
                }
                title: "Shoot Hoops"
                width: parent.width
                height: parent.height
                id: pane
                Image{
                    z:-1
                    id: backgroundImage
                    opacity: 0.4
                    anchors.fill: parent
                    source: "../assets/images/background.png"
                }
                Rectangle{
                    id: personalBestBox
                    width: mainPBText.implicitWidth+30
                    height: mainPBText.implicitHeight+mainPBText2.implicitHeight+20
                    x:350
                    y:800
                    border.color: "blue"
                    border.width: 3
                    color: "transparent"
                    Component.onCompleted: {
                        switchToBlueTimerPB.start()
                    }
                    Text{
                        visible:false
                        id:templateText
                        text:"Personal Best: "
                        font.pointSize: textMultiplier* 20
                        font.family: stencil.name
                    }

                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        y:10
                        id: mainPBText
                        width: templateText.width+5
                        text: "Personal Best: ";
                        font.pointSize: textMultiplier* 20
                        font.family: stencil.name
                        wrapMode: Text.Wrap
                    }
                    Text{
                        id: mainPBText2
                        anchors.horizontalCenter: mainPBText.horizontalCenter
                        anchors.top:mainPBText.bottom
                        anchors.bottomMargin: 10
                        text: personalBest
                        font.pointSize: textMultiplier* 27
                        font.family: stencil.name
                    }
                    radius: 5
                    Timer{
                        id: switchToBlueTimerPB
                        interval: 400
                        onTriggered: {
                            personalBestBox.border.color="#3074c7" //blue
                            switchToRedTimerPB.restart()
                        }
                    }
                    Timer{
                        id: switchToGreenTimerPB
                        interval: 400
                        onTriggered: {
                            personalBestBox.border.color="#58b853"  //green
                            switchToBlueTimerPB.restart()
                        }
                    }
                    Timer{
                        id: switchToRedTimerPB
                        interval: 400
                        onTriggered: {
                            personalBestBox.border.color="#cc3f3f"  //red
                            switchToGreenTimerPB.restart()
                        }
                    }
                }
                //coin thing in corner
                Rectangle{
                    id:coinThing
                    Row{
                        spacing: 20;
                        x: 10
                        y:10
                        Image{
                            anchors.verticalCenter: parent.verticalCenter
                            width: 35
                            height: 35
                            source: "../assets/images/coinFront.png"
                        }
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            property int value: numCoins
                            text: value
                            font.family: stencil.name
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: textMultiplier*21
                            Behavior on value {
                                NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad}
                            }
                        }

                    }
                }
                Label {
                    text: "Shoot Hoops!"
                    font.family:impact.name
                    font.pointSize: textMultiplier* 65
                    width: 470
                    wrapMode: Label.Wrap
                    y:130
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Label.AlignHCenter
                }
                Rectangle{
                    //                    y: parent.width/2+40
                    anchors.verticalCenter: smallCirclesColumn.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: buttonToPlayGame
                    width: 370*0.95
                    height: 120*0.95
                    border.color: "red"
                    border.width: 7
                    color: (buttonToPlayGameMouseArea.pressed)?"#44a3f2":"#5db0f5"
                    //                    color: (buttonToPlayGameMouseArea.pressed)?"orange":"yellow"
                    Component.onCompleted: {
                        switchToGreenTimer.start()
                    }
                    Text{
                        text: "START"
                        font.family: "Tahoma"
                        font.bold: true
                        style: Text.Raised
                        font.pointSize: textMultiplier* 34
                        anchors.centerIn: parent
                    }
                    radius: 50
                    Timer{
                        id: switchToBlueTimer
                        interval: 550
                        onTriggered: {
                            buttonToPlayGame.border.color="#3074c7" //blue
                            switchToRedTimer.restart()
                        }
                    }
                    Timer{
                        id: switchToGreenTimer
                        interval: 600
                        onTriggered: {
                            buttonToPlayGame.border.color="#58b853"  //green
                            switchToBlueTimer.restart()
                        }
                    }
                    Timer{
                        id: switchToRedTimer
                        interval: 550
                        onTriggered: {
                            buttonToPlayGame.border.color="#cc3f3f"  //red
                            switchToGreenTimer.restart()
                        }
                    }
                    MouseArea{
                        id: buttonToPlayGameMouseArea
                        anchors.fill: parent
                        onClicked: {
                            if(!missionsScene.visible){
                                //update current missions (just double checking)
//                                setCurrentMissions()
                                //                                missionsScene.visible=false
                                makeMissionsInvisible()
                                navigationStack.push(competitiveModeComponent)
                                Extra.endingPage="CompetitiveMode.qml";
                                thisTitle="Game Mode"
                            }
                        }
                    }
                }
                Column{
                    y: 410
                    x: 20
                    spacing: 150
                    id: smallCirclesColumn
                    Rectangle{
                        color: "transparent"
                        width: 130
                        height: 130
                        radius: 115
                        border.width: 2
                        border.color: "black"
                        Image{
                            z:-1
                            anchors.centerIn: parent
                            width: 125
                            height: 125
                            source: "../assets/images/symbols/shop.png"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                //                                missionsScene.visible=false
                                makeMissionsInvisible()
                                navigationStack.push(gameStoreComponent);
                                Extra.endingPage="GameStore.qml";
                                thisTitle="The Store"
                            }
                        }
                        Text{
                            anchors.bottom: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "SHOP"
                            font.family: geniso.name
                            font.bold: true
                            font.pointSize: 21
                        }
                    }
                    Rectangle{
                        color: "transparent"
                        width: 130
                        height: 130
                        radius: 115
                        border.width: 2
                        border.color: "black"
                        Image{
                            x: 5
                            y:5
                            width: 35
                            height: 35
                            source: "../assets/images/exclamationMark.png"
                            visible: false /*checkIfButtonNeedsToBeVisible(false)*/    //change this to something else
                        }

                        Image{
                            z:-1
                            anchors.centerIn: parent
                            width: 125
                            height: 125
                            source: "../assets/images/symbols/missions.png"
                        }
                        Rectangle{
                            visible: thePauseTimer.running
                            z:-1
                            anchors.centerIn: parent
                            width: 125
                            height: 125
                            radius: 110
                            color:"darkgray"
                            opacity: 0.50
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(!thePauseTimer.running){
                                    //                                    missionsScene.visible=true
                                    showMissionsAnimation.start()
                                    checkIfButtonNeedsToBeVisible(true);
                                    if(true){
                                        //12
                                        let couldTheMissionBeCompleted = 0;
                                        for(let i =0; i< 3; i++){
                                            if(presentMissions[i]!==12){
                                                if ((mMissionModel.get(presentMissions[i]).currentThings>=mMissionModel.get(presentMissions[i]).neededThings)){
                                                    couldTheMissionBeCompleted++;
                                                }
                                                return true;
                                            }
                                        }
                                        if(couldTheMissionBeCompleted===2&&checkIfCurrentMission(12)){
                                            mMissionModel.get(12).currentThings++
                                        }
                                    }
                                }
                            }
                        }
                        Text{
                            anchors.bottom: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "MISSIONS"
                            font.family: geniso.name
                            font.bold: true
                            font.pointSize: 21
                        }
                    }
                }
            }
        }
    }
    Settings{
        property alias firstTimeEverSettings: root.firstTimeEVER
        property alias volumeSettings: root.volume
        property alias soundSettings:root.sound
        property alias numCoinsSettings: root.numCoins
        property alias ballSourceSettings:root.ballSource

        property alias shotRandomNumberSettings: root.shotRandomNumber
        property alias levelRandomNumberSettings: root.levelRandomNumber
        property alias personalBestSettings: root.personalBest
        property alias datastoreSettings:root.datastore

        property alias presentMissionsSettings: root.presentMissions
    }

    Component{
        id: competitiveModeComponent
        CompetitiveMode{
        }
    }
    Component{
        id: gameStoreComponent
        GameStore{
        }
    }
}
