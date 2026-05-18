import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtCore
import SddmComponents 2.0
import "."

Rectangle {
    id: container
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    property int sessionIndex: session.index
    property date dateTime: new Date()

    TextConstants {
        id: textConstants
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            errorMessage.text = textConstants.loginSucceeded
        }
        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "#ff3333"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: container.dateTime = new Date()
    }

    FontLoader {
        id: textFont
        source: "./assets/volter.ttf"
    }

    FontLoader {
        id: clockFont
        source: "./assets/volter.ttf"
    }

    Image {
        id: behind
        anchors.fill: parent
         source: config.background
         fillMode: Image.Stretch
         onStatusChanged: {
             if (config.type === "color") {
                 source = config.defaultBackground
             }
         }
    }

    Text {
        id : date
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 4
        color : "#eaeaef"
        text: Qt.formatDateTime(container.dateTime, "ddd d MMM - hh:mm")
        font.pointSize: 36
        font.family: clockFont.name
    }

    ColumnLayout {
        id: middleBox
        anchors.centerIn: parent

        Text {
            id: userlabel
            font.family: textFont.name
            font.pointSize: 15
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: 28
            text: textConstants.userName
            color: "#e1e1e1"
        }

        Image {
            id: imageinput
            source: "assets/input.svg"
            width: 330
            height: 50

            TextField {
                id: nameinput
                focus: true
                font.family: textFont.name
                anchors.fill: parent
                text: userModel.lastUser
                font.pointSize: 15
                leftPadding: 16
                color: "#eaeaef"
                selectByMouse: true
                selectionColor: "#232929"
                selectedTextColor: "#fafaff"

                background: Image {
                    id: textback
                    source: "assets/inputhi.svg"

                    states: [
                        State {
                            name: "yay"
                            PropertyChanges {target: textback; opacity: 1}
                        },
                        State {
                            name: "nay"
                            PropertyChanges {target: textback; opacity: 0}
                        }
                    ]

                    transitions: [
                        Transition {
                            to: "yay"
                            NumberAnimation { target: textback; property: "opacity"; from: 0; to: 1; duration: 0; }
                        },

                        Transition {
                            to: "nay"
                            NumberAnimation { target: textback; property: "opacity"; from: 1; to: 0; duration: 0; }
                        }
                    ]
                }

                KeyNavigation.tab: password
                KeyNavigation.backtab: password

                Keys.onPressed: (event)=> {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        password.focus = true
                    }
                }

                onActiveFocusChanged: {
                    if (activeFocus) {
                        textback.state = "yay"
                    } else {
                        textback.state = "nay"
                    }
                }
            }
        } //inputimage

        Text {
            id: passwordlabel
            font.family: textFont.name
            font.pointSize: 15
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: 28
            text: textConstants.password
            color: "#e1e1e1"
        }

        Image {
            id: imagepassword
            source: "assets/input.svg"
            width: 330
            height: 50

            TextField {
                id: password
                font.family: textFont.name
                anchors.fill: parent
                font.pointSize: 15
                leftPadding: 16
                echoMode: TextInput.Password
                color: "#eaeaef"
                selectionColor: "#232929"
                selectedTextColor: "#fafaff"

                background: Image {
                    id: textback1
                    source: "assets/inputhi.svg"

                    states: [
                        State {
                            name: "yay1"
                            PropertyChanges {target: textback1; opacity: 1}
                        },
                        State {
                            name: "nay1"
                            PropertyChanges {target: textback1; opacity: 0}
                        }
                    ]

                    transitions: [
                        Transition {
                            to: "yay1"
                            NumberAnimation { target: textback1; property: "opacity"; from: 0; to: 1; duration: 0; }
                        },

                        Transition {
                            to: "nay1"
                            NumberAnimation { target: textback1; property: "opacity"; from: 1; to: 0; duration: 0; }
                        }
                    ]
                }

                KeyNavigation.tab: nameinput
                KeyNavigation.backtab: nameinput

                Keys.onPressed: (event)=> {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(nameinput.text, password.text, sessionIndex)
                        event.accepted = true
                    }
                }

                onActiveFocusChanged: {
                    if (activeFocus) {
                        textback1.state = "yay1"
                    } else {
                        textback1.state = "nay1"
                    }
                }
            }
        } //imagepassword
    } // columnlayout

    Image {
        id : loginButton
        anchors.right: middleBox.right
        anchors.top: middleBox.bottom
        anchors.topMargin: 16
        anchors.rightMargin: 0
        source : "assets/input.svg"

        MouseArea {
            id: ma3
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse) {
                    parent.source = "assets/inputhi.svg"
                }
                else {
                    parent.source = "assets/input.svg"
                }
            }

            onPressed: parent.source = "assets/inputhi.svg"
            onReleased:  {
                sddm.login(nameinput.text, password.text, sessionIndex)
                parent.source = "assets/input.svg"
            }
        }

        Text{
            anchors.centerIn: parent
            color: "white"
            font.family: textFont.name
            font.pointSize: 15
            text: textConstants.login
        }
    }


    RowLayout{
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 3 / 4 - 13
        
        Text {
            font.family: textFont.name
            font.pointSize: 17
            text: textConstants.session
            color: "#ffffff"
            verticalAlignment: Text.AlignVCenter
            Layout.preferredHeight: 26
        }

        ComboBox {
            id: session
            color: "#ff3749"
            hoverColor: "#232929"
            textColor: "white"
            menuColor: "#171b1b"
            borderColor: "#232929"
            width: 350
            height: 36
            font.pointSize: 15
            font.family: textFont.name
            arrowBox: "assets/comboarrow.svg"
            backgroundNormal: "assets/input.svg"
            backgroundHover: "assets/inputhi.svg"
            backgroundPressed: "assets/inputhi.svg"
            model: sessionModel
            index: sessionModel.lastIndex
            KeyNavigation.backtab: password
            KeyNavigation.tab: nameinput
        }

        Rectangle {
            color: "transparent"
            height: 26
            width: 26
        }

        Image {
            id: rebootButton
            source: "assets/rebootup.svg"
            width: 26
            height: 26

            MouseArea {
                id: ma2
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/reboothover.svg"
                }
                onExited: {
                    parent.source = "assets/rebootup.svg"
                }
                onPressed: {
                    parent.source = "assets/rebootdown.svg"
                    sddm.reboot()
                }
                onReleased: {
                    parent.source = "assets/rebootup.svg"
                }
            }
        }

        Image {
            id: shutdownButton
            source: "assets/powerup.svg"
            Layout.alignment: Qt.AlignCenter
            width: 26
            height: 26

            MouseArea {
                id: ma1
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/powerhover.svg"
                }
                onExited: {
                    parent.source = "assets/powerup.svg"
                }
                onPressed: {
                    parent.source = "assets/powerdown.svg"
                    sddm.powerOff()
                }
                onReleased: {
                    parent.source = "assets/powerup.svg"
                }
            }
        }

    }

    Component.onCompleted : {
        password.focus = true
        textback.state = "nay"  //dunno why both inputs get focused
    }
}
