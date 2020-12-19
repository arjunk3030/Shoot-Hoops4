import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.0
import QtMultimedia 5.9
//import Qt.labs.qmlmodels 1.0
import QtQuick.Dialogs 1.2
//import otherArjun 1.0
Page {
    visible: true
    width: parent.width
    height: parent.height
    anchors.fill: parent
    function onGoBackFromHalftime(points1){
        Extra.endingPage="CompetitiveMode.qml"
        navigationStack.pop()
        points+=points1
        shouldBeginThirdLevel=true
    }

    title:"Halftime!"
    id: root2
    property int timeRemaining: totalTimeTimer.interval/1000
    //    property alias ball: basketball
    property int numberOfClicks: 0;
    signal ballClicked;
    onBallClicked: {
        numberOfClicks++
    }

    Rectangle{
        id: levelRectangle
        anchors.centerIn: parent
        width: 1
        height: 1
        z:100;
        color: "#f7fafc"
        radius: 20;
        visible: false;
        Component.onCompleted: {
            levelRectangleAnimation.start()
        }
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            id: levelRectangleText1
            text: "It's Halftime"
            font.pointSize: textMultiplier*1;
            font.family: bodoniMTBlack.name
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
        Text{
            id: levelRectangleText
            text: "Click the ball to collect it and earn points - this adds on to your game score"
            font.pointSize: textMultiplier* 20;
            font.family: centuryGothic.name
            wrapMode: Text.Wrap
            width: parent.width-30
            lineHeight: 1.5
            y: levelRectangleText1.y+levelRectangleText1.implicitHeight+30+10
            anchors.horizontalCenter: parent.horizontalCenter
            visible:false
        }
        //        Button{
        //            visible: false
        //            id: startGameButton
        //            text: "Start"
        //            font.pointSize: textMultiplier* 14;
        //            width: parent.width-90
        //            height: 120
        //            y: levelRectangleText.y+levelRectangleText.implicitHeight+30
        //            anchors.horizontalCenter: parent.horizontalCenter
        //            onClicked: {
        //                levelRectangle.visible=false;
        //                remainingTimeBox.visible=true
        //                ballTriggerTimer.start()
        //                totalTimeTimer.start()
        //            }
        //        }
        Button {
            visible: false
            Rectangle{
                anchors.fill: parent
                color: startGameButton.pressed?"#233ab8" : "#3F51B5"
            }
            Text{
                anchors.centerIn: parent
                font.pointSize: textMultiplier* 20
                text: "Start"
                color: "White"
                font.family: "Century Gothic"
            }
            id: startGameButton
            width: templateButton.width+140
            height: templateButton.height+50
            font.pointSize: textMultiplier* 14;
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            onClicked: {
                // emit signal and hide dialog if button is selected
                levelRectangle.visible=false;
                remainingTimeBox.visible=true
                ballTriggerTimer.start()
                totalTimeTimer.start()
            }
        }
        Button{
            visible: false
            id: templateButton
        }
        ParallelAnimation {
            id: levelRectangleAnimation
            onStarted: {
                levelRectangle.visible = true;
            }
            onStopped: {
                //Making bottom text appear
                levelRectangleText.visible=true
                startGameButton.visible=true;
            }
            NumberAnimation {
                target: levelRectangleText1
                property: "font.pointSize"
                duration: 800
                easing.type: Easing.Linear
                to:30
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
    }
    //for dynamic object creatin
    function createHalftimeBallObjects() {
        var component;
        var sprite;  //comes from qt doc and to lazy to change
        function finishCreation() {
            if (component.status === Component.Ready) {
                sprite = component.createObject(root2);
                if (sprite === null) {
                    // Error Handling
                    //                    console.log("Error creating object");
                }
            } else if (component.status === Component.Error) {
                // Error Handling
                //                console.log("Error loading component:", component.errorString());
            }
        }
        component = Qt.createComponent("HalftimeBall.qml");
        if (component.status === Component.Ready)
            finishCreation();
        else
            component.statusChanged.connect(finishCreation);
    }
    Rectangle{
        visible: false
        id: remainingTimeBox
        anchors.centerIn: parent
        width:height
        height: remainingTimeBoxText.implicitHeight+129
        color: "black"
        z:200
        opacity: 0.4
        radius:20
        Text{
            id: remainingTimeBoxText
            x: parent.width/2-40
            anchors.centerIn: parent
            font.family: geniso.name
            font.bold: true
            text: timeRemaining
            font.pointSize: textMultiplier* 150
            color: "white"
        }
    }
    Rectangle{
        visible: false
        id: totalRewardsBox
        anchors.centerIn: parent
        width:remainingTimeBox.width
        height: remainingTimeBox.height
        color: "black"
        z:200
        opacity: 0.4
        radius:25
        Column{
            anchors.fill: parent
            anchors.centerIn: parent
            spacing: 20
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: value +" X " + " 15 = ";
                property int value: (totalRewardsBox.visible)?(numberOfClicks):(0)
                Behavior on value {
                    NumberAnimation { duration: 800; easing.type: Easing.InOutQuad }
                }
                id: totalRewardsBoxText
                font.family: geniso.name
                font.bold: true
                font.pointSize: textMultiplier* 40
                color: "white"
            }
            Text{
                property int value: (totalRewardsBox.visible)?(numberOfClicks*15*4/3*6/5):(0)
                Behavior on value {
                    NumberAnimation { duration: 900; easing.type: Easing.InOutQuad }
                }
                anchors.horizontalCenter: parent.horizontalCenter
                text: value
                font.family: geniso.name
                font.bold: true
                font.pointSize: textMultiplier* 85
                color: "white"
            }
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: "extra points"
                font.family: geniso.name
                font.pointSize: textMultiplier* 40
                color: "white"
            }
        }
    }
    Timer{
        id: ballTriggerTimer
        interval: 545
        running: totalTimeTimer.running; repeat: true
        onTriggered:{
            let b =4;
            if(timeRemaining<15)
                b=5;
            if(timeRemaining<9)
                b=6
            if(timeRemaining<3)
                b=7
            for(let i =0; i < b; i++){
                createHalftimeBallObjects()
            }
        }
    }
    Timer{
        id: totalTimeTimer
        interval:  20000
    }

    PauseAnimation {
        id: endPauseAnim
        duration: 5000
        onStopped: {
            //do something
            onGoBackFromHalftime(numberOfClicks*15*4/3*6/5);
        }
    }
    PauseAnimation {
        id: endPauseAnim2
        duration: 2500
        onStopped:{
            remainingTimeBox.visible=false
            totalRewardsBox.visible=true
            endPauseAnim.start()
        }
    }
    Timer{
        id: countdownUpdateTimer
        interval: 1000
        running: totalTimeTimer.running; repeat: true
        onTriggered:{
            if(totalTimeTimer.running)
                timeRemaining--;
            if(timeRemaining===0){
                remainingTimeBoxText.text= "Time's Up"
                remainingTimeBox.height=remainingTimeBox.height;
                remainingTimeBoxText.font.pointSize=40
                endPauseAnim2.start()
            }
        }
    }
    //Sun
    //    Rectangle{
    //        z:8
    //        visible: true
    //        id: sun
    //        radius: 80
    //        x:-width/2+10
    //        y:-height/2+10
    //        width:130
    //        height:130
    //        color: "yellow"
    //        Text{
    //            id: onSunLevelText
    //            font.pointSize: textMultiplier* 10
    //            text: "Count";
    //            x: height*3/5+50
    //            y: width*3/5+30
    //            font.underline: true
    //            color: "black"
    //            font.family: "Blacklight"
    //            wrapMode: Text.Wrap
    //        }
    //        Text{
    //            id: onSunLevelText1
    //            font.pointSize: textMultiplier* 18
    //            text: numberOfClicks;
    //            anchors.top: onSunLevelText.bottom
    //            color: "black"
    //            font.family: "Athletic"
    //            wrapMode: Text.Wrap
    //            x: height*3/5+55
    //        }
    //    }
    //Sun
    Rectangle{
        visible: true
        id: sun
        radius: 80
        x:80
        y:50
        width:170
        height:170
        color: "yellow"
        z: 17
        Text{
            id: onSunLevelText
            font.pointSize: textMultiplier* 22
            text: "Count";
            anchors.centerIn: parent
            color: "black"
            font.bold: true
            font.underline: true
            font.family: "Century Gothic"
            wrapMode: Text.Wrap
        }
        Text{
            id: onSunLevelText1
            font.pointSize: textMultiplier* 25
            text: numberOfClicks;
            y: onSunLevelText.y+onSunLevelText.height+5
            color: "black"
            font.family: "Stencil"
            wrapMode: Text.Wrap
            anchors.horizontalCenter: onSunLevelText.horizontalCenter
        }
    }
    //Sky
    Rectangle {
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

    //Ground
    Rectangle{
        id: ground
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 300
        width: parent.width
        gradient: Gradient {
            GradientStop { id: groundStartGradient; position: 0.0; color: "#00FF00"}
            GradientStop {id: groundEndGradient; position: 1.0; color: "#00803F"}
        }
    }

}
