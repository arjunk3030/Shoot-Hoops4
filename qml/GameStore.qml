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
Page {
    visible: true
    title:"The Store"
    property int duration: 1000
    id: root
    property var found: true;
    property var bought: ["Basketball", "Blue"]
    property int count: 0;
    property var mName: "Blue";
    property var mSource: "";
    property var mIndex: -1;
    property bool firstTime: true;
    property bool firstTime1: true;
    property var givenName: "";

    property var counter15: 0
    Component.onCompleted: {
        bigPicText.text =givenName;
    }
    function checkIfCurrentMission(num){
        for(let i =0; i< 3; i++){
            if(presentMissions[i]===num){
                return true;
            }
        }
        return false;
    }
    function findCurrentIndex()
    {
        let thing;
        for(let i =0; i < contactModel.count;i++){
            if(contactModel.get(i).picSource=== ballSource)
                thing = i
        }
        for(let k =0; k <bought.length; k++){
            for(let j = 0; j < contactModel.count; j++){
                if(bought[k]===contactModel.get(j).name){
                    contactModel.get(j).isBought=true
                    break;
                }
            }
        }
        return thing;
    }
    function checkIfFound()
    {
        found = false;
        for(let i =0; i < bought.length; i++){
            if(bought[i]===mName){
                found = true;
                return true;
            }
        }
        return false;
    }
    function someOfTheStuffToDoWhenClicked()
    {
        firstTime=false;
        if(!found){
            //not bought yet
            purchaseButton.visible=true;
            buttonFadeRect.visible=true;
            lockSign.visible = true;

            purchaseButtonText.text = count;

            if(numCoins>=count){
                purchaseButton.enabled=true;
                colorRect.color= "#bdbd22"
            }
            else{
                purchaseButton.enabled = false;
                colorRect.color= "#69685a"
            }
        }
        else{
            //bought before
            ballSource=mSource;
            purchaseButton.visible=false;
            buttonFadeRect.visible=false;
            lockSign.visible = false;
            givenName=mName;
        }
        bigPicImage.source= mSource;
        bigPicText.text =mName;
    }
    Image{
        x:0.1
        anchors.fill: parent
        opacity: 0.2
        source: "../assets/images/gameStoreBackground.jpg"
    }
    //Number of coins thingy
    Rectangle{
        Component.onCompleted: {
            bigPicAnim.start()
        }

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
                    NumberAnimation { duration: (firstTime)?1:1000; easing.type: Easing.InOutQuad}
                }
            }

        }
    }
    //Big Pic
    Rectangle{
        id: bigPic
        y:lockSign.y+lockSign.height/3-height+8
        anchors.horizontalCenter: parent.horizontalCenter
        width: (purchaseButton.width)*2.42
        height: (purchaseButton.width)*1.42
        border.color: "darkgray"
        border.width: 3
        radius: 4
        color: "transparent"
        Text{
            text: "Normal Ball"
            id: bigPicText
            font.family: impact.name
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: textMultiplier* 35
            anchors.horizontalCenter: parent.horizontalCenter
            y:2
            color: "black"
        }
        Image{
            id: bigPicImage
            source: ballSource
            width: 240;
            height: 240;
            anchors.horizontalCenter: parent.horizontalCenter
            y:bigPicText.y+bigPicText.height+2
        }

        RotationAnimation{
            id: bigPicAnim
            target: bigPicImage
            property: "rotation"
            easing.type: Easing.Linear
            to: 360*5;
            duration: 10020
            onStopped: {
                bigPicImage.rotation =0;
                bigPicAnim.start()
            }
        }
    }

    //lockSign sign
    Image{
        visible: false
        id: lockSign
        width: purchaseButton.width/2
        height: width
        anchors.bottom: buttonFadeRect.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../assets/images/symbols/lockSign.png"
    }
    Item {
        id: confirmMessage
        width: 708
        height: parent.height
        anchors.centerIn: parent
        z:10
        visible: false
        onVisibleChanged: {
            if(visible)
                myDialog3.show()
        }
        CustomCDialog{
            anchors.centerIn: parent
            id: myDialog3
            box.color: "white"
            modal: true
            onSelectedOk: {
                numCoins-=count
                contactModel.get(mIndex).isBought=true
                bought.push(mName);
                boughtChanged();
                checkIfFound()
                counter15++;
                if(counter15===mMissionModel.get(15).neededThings&&!(mMissionModel.get(15).currentThings>=mMissionModel.get(15).neededThings)&&checkIfCurrentMission(15)){
                    mMissionModel.get(15).currentThings=mMissionModel.get(15).neededThings
                }
                someOfTheStuffToDoWhenClicked();
            }
            onSelectedCancel: {
                confirmMessage.close()
            }
        }
    }
    //Purchase Button
    Button{
        onClicked: {
            confirmMessage.visible=true
        }
        visible:false;
        z:2
        x: buttonFadeRect.x+6
        y:buttonFadeRect.y-7
        id: purchaseButton
        height: 100;
        width:230;
        Rectangle{
            id: colorRect
            anchors.fill:parent
            color:"yellow"
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                Text{
                    id: purchaseButtonText
                    //cost
                    text: "25"
                    font.pointSize: textMultiplier* 29
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    font.family: stencil.name
                }
                Image{
                    //coin pic
                    width:53
                    height:53;
                    source: "../assets/images/coinFront.png"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

    }
    Rectangle{
        visible: false;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: grid.top
        id: buttonFadeRect
        height: purchaseButton.height;
        width:purchaseButton.width;
        color: "#93a8c4"
    }
    //List model for all the different things
    ListModel{
        id: contactModel
        ListElement{
            index:0
            isBought: true
            type: "regularBall";
            name: "Basketball"
            picSource: "../assets/images/balls/basketBall.png"
            price: 0;
        } ListElement{
            index:1
            isBought: true
            type: "blueBall";
            name: "Blue"
            picSource: "../assets/images/balls/blueBall.png"
            price: 5
        } ListElement{
            index:2
            isBought: false
            type: "greenBall";
            name: "Green"
            picSource: "../assets/images/balls/greenBall.png";
            price: 10
        } ListElement{
            index:3
            isBought: false
            type: "redBall";
            name: "Red"
            picSource: "../assets/images/balls/redBall.png"
            price: 15
        }ListElement{
            index:4
            isBought: false
            type: "tennisBall";
            name: "Tennis Ball"
            picSource: "../assets/images/balls/tennisBall.png"
            price: 15
        }ListElement{
            index:5
            isBought: false
            type: "soccerBall";
            name: "Soccer Ball"
            picSource: "../assets/images/balls/soccerBall.png"
            price: 20
        }ListElement{
            index:6
            isBought: false
            type: "bowlingBall";
            name: "Bowling Ball"
            picSource: "../assets/images/balls/bowlingBall.png"
            price: 30

        }ListElement{
            index:7
            isBought: false
            type: "volleyBall";
            name: "Volley Ball"
            picSource: "../assets/images/balls/volleyBall.png"
            price: 30
        }
        ListElement{
            index:8
            isBought: false
            type: "Cookie";
            name: "The Cookie"
            picSource: "../assets/images/balls/cookieBall.png"
            price: 35
        }
        ListElement{
            index:9
            isBought: false
            type: "Waffle";
            name: "The Waffle"
            picSource: "../assets/images/balls/waffleBall.png"
            price: 40
        }
        ListElement{
            index:10
            isBought: false
            type: "Tire";
            name: "The Tire"
            picSource: "../assets/images/balls/tireBall.png"
            price: 40
        }
        ListElement{
            index:11
            isBought: false
            type: "Donut";
            name: "The Donut"
            picSource: "../assets/images/balls/donutBall.png"
            price: 45
        }
        ListElement{
            index:12
            isBought: false
            type: "Coin";
            name: "The Coin"
            picSource: "../assets/images/balls/coinBall.png"
            price: 50
        }
        ListElement{
            index:13
            isBought: false
            type: "clock";
            name: "The Clock"
            picSource: "../assets/images/balls/clockBall.png"
            price: 50
        }
        ListElement{
            index:14
            isBought: false
            type: "Dartboard";
            name: "The Dartboard"
            picSource: "../assets/images/balls/dartboardBall.png"
            price: 60
        }
        ListElement{
            index:15
            isBought: false
            type: "Earth";
            name: "The Earth"
            picSource: "../assets/images/balls/earthBall.png"
            price: 70
        }
        ListElement{
            index:16
            isBought: false
            type: "moon";
            name: "The Moon"
            picSource: "../assets/images/balls/moonBall.png"
            price: 70
        }
        ListElement{
            index:17
            isBought: false
            type: "white";
            name: "The White"
            picSource: "../assets/images/balls/whiteCircle.png"
            price: 300
        }
    }

    GridView {
        clip: true
        ScrollBar.vertical: ScrollBar{}
        //        boundsBehavior: Flickable.OvershootBounds
        populate: Transition {
            NumberAnimation { properties: "x,y"; duration: 400 }
        }
        width: cellWidth*4; height: cellHeight*4
        cellWidth: 140; cellHeight: 140
        id:grid
        anchors.horizontalCenter: parent.horizontalCenter
        y:root.height-height-40
        currentIndex: findCurrentIndex()
        model: contactModel
        Component{
            id: foundDel
            Rectangle{
                width: grid.cellWidth
                height: grid.cellHeight
                color: "transparent"
                Rectangle {
                    width: grid.cellWidth-25
                    height: grid.cellHeight-25
                    id: wrapper
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    border.width: 3
                    border.color: "black"
                    radius: 5;
                    color: (isBought)?"white":"#a1a1a1"
                    Image{
                        id: mImage
                        x:parent.x
                        y:6
                        width: 85
                        height:85;
                        source: picSource

                    }
                    Text{
                        width: grid.cellWidth-15
                        y: mImage.y+mImage.height+4
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: nameText
                        text: name
                        font.family: centuryGothic.name
                        font.bold:  (grid.isCurrentItem===true)?"true":"false"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: textMultiplier* 10
                        color:"#050027"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                            mIndex=index
                            count = price;
                            mName = name;
                            mSource = picSource;
                            //what happens when u click
                            grid.currentIndex=index;
                            checkIfFound()
                            someOfTheStuffToDoWhenClicked()
                        }
                    }
                }
            }
        }
        delegate: foundDel
        highlight:
            Rectangle {
            z:8
            color: "steelblue";
            radius: 5;
            opacity: 0.6
            Image{
                id: checkMark
                visible: found;
                anchors.centerIn: parent
                width: 120;
                height: 120;
                source: "../assets/images/symbols/roundedCheck.png"
            }
            Image{
                id: theXofDoom
                visible: !found;
                anchors.centerIn: parent
                width: 120;
                height: 120;
                source: "../assets/images/symbols/straightX.png"
            }
        }
        focus: true
    }

    Settings{
        category: "mySettingsThing5"
        property alias mMName1: root.givenName
        property alias mBought2: root.bought
    }
}


