import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.9


Item {
    z:20
    id: dialog
    anchors.fill: parent
    // we need to disable this item if it is invisible, then all the contained MouseAreas are also disabled
    enabled: visible
    // by default, the dialog is invisible
    visible: false

    // alias to access the box
    property alias box: box

    // property to make this dialog modal and prevents selecting anything behind it
    property bool modal: false

    // signals emitted if a button has been pressed
    signal selectedOk
    signal selectedCancel

    // show function
    function show() {
        // set the dialog visible to enable it and start show animation
        dialog.visible = true
        showAnimation.start()
    }

    // hide function
    function hide() {
        // start hide animation, the dialog will be set invisible once the animation has finished
        hideAnimation.start()
    }

    // this component prevents selecting anything behind the dialog, only enabled if it's a modal dialog
    MouseArea {
        anchors.fill: parent
        enabled: dialog.modal
        onClicked: {
            hide()
        }
    }

    // visible overlay, only visible if it's a modal dialog
    Rectangle {
        id: overlay
        visible: dialog.modal
        anchors.fill: parent
        color: "#000"
    }

    // the box containing dialog text and buttons
    Rectangle {
        MouseArea{
            anchors.fill: parent
            enabled: dialog.modal
        }
        id: box
        color: "white"
//        border.color: "black"
        radius: 9
        anchors.centerIn: parent
        onVisibleChanged: {
            if(visible){
                Extra.isOpen = true;
            }
            else{ aboutDialog.visible=false
                Extra.isOpen = false;
            }
        }

        //            x: Math.round((705 - width) / 2)
        //            y: 130
        //            y: Math.round(785 / 6)
        //            width: Math.round(Math.min(705, 785) /3 * 2)
        width: 550
        height: 900
        focus: true
        Label {
            id: title
            height: 35
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                id: labelText
                text: "How to play??"
                font.family: bodoniMTBlack.name
                wrapMode: Label.Wrap
                font.pointSize: textMultiplier*27
                font.bold:true;
                horizontalAlignment: "AlignHCenter"
            }
        }
        Flickable{
            id: howToPlayFlickable
            y: title.y+title.width+75
            width: box.width-25
            height: box.height-title.width-90
            contentHeight: parent.height*2
            contentWidth: aboutColumn.width-5
            flickableDirection: Flickable.VerticalFlick
            clip: true
            ScrollBar.vertical: ScrollBar{
                x:box.width-width
            }
            Column {
                x:10
                id: aboutColumn
                spacing: 20
                width:parent.width
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true
                        font.underline: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 18
                        text: "The Game"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        font.bold: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 15
                        text: "Level 1"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    Tap to shoot! The closer to the middle, the more accurate the shot. Don't miss three times!"
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        font.bold: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 15
                        text: "Level 2"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    Tap to shoot! The closer to the middle, the more accurate the shot. Don't miss three times! Watch out for the slider's random movement!"
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        font.bold: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 15
                        text: "Halftime"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    Click on as many balls as you can as they fall. The more balls you click the more bonus points earned"
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        font.bold: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 15
                        text: "Level 3"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    Aim to click on the green part of the slider to have the best accuracy! Don't miss three times!. It's not as easy as it looks."
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        font.bold: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 15
                        text: "Level 4"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    A harder, more challenging Level 2"
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true
                        font.underline: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 18
                        text: "Coins"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    Earn coins by completing daily missions or making shots in game!"
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true
                        font.underline: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 18
                        text: "Daily Missions"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    Complete tasks by playing to game to earn coins. The three daily missions reset every 24 hours."
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true
                        font.underline: true
                        wrapMode: Label.Wrap
                        font.pointSize: textMultiplier* 18
                        text: "The Store"
                    }
                }
                Label {
                    font.family: centuryGothic.name; width: parent.width
                    text: "    Use coins to purchase a new styles of balls to play with"
                    wrapMode: Label.Wrap
                    font.pointSize: textMultiplier* 12.5
                    lineHeight: 1.45
                }
            }
        }
    }

    // animation to show the dialog
    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: box
            property: "scale"
            from: 0
            to: 1
            easing.type: Easing.OutBack
            duration: 250
        }
        NumberAnimation {
            target: overlay
            property: "opacity"
            from: 0
            to: 0.2
            duration: 250
        }
    }

    // animation to hide the dialog
    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: box
            property: "scale"
            from: 1
            to: 0
            easing.type: Easing.InBack
            duration: 250
        }
        NumberAnimation {
            target: overlay
            property: "opacity"
            from: 0.2
            to: 0
            duration: 250
        }
        onStopped: {
            // set it invisible when the animation has finished to disable MouseAreas again
            dialog.visible = false
        }
    }
}
