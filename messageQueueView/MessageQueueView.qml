// MessageQueueView.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./resource"

Item {
    id: root


    property real margin: 20

    property Component messageItemDelegate: messageDelegate
    property Component background: backgourndCmp
    property ListModel model: ListModel {}

    property alias itemsSpacing: messageView.spacing
    property alias count: messageView.count

    signal added()
    signal removed()

    width: 260
    height: 400

    state: "show"
    states: [
        State {
            name: "hide"
            PropertyChanges {
                target: content
                opacity: 0
                x: root.width
            }
            PropertyChanges {
                target: showIcon
                parent: root
                anchors.right: content.left
                anchors.verticalCenter: content.verticalCenter
            }
            PropertyChanges {
                target: messageView
                interactive: false
            }
        },
        State {
            name: "show"
            PropertyChanges {
                target: content
                opacity: 1
                x: 0
            }
            PropertyChanges {
                target: showIcon
                parent: root
                anchors.right: content.left
                anchors.verticalCenter: content.verticalCenter
            }
            PropertyChanges {
                target: messageView
                interactive: true
            }
        }
    ]
    transitions: [
        Transition {
            from: "hide"
            to: "show"
            SequentialAnimation {
                ScriptAction {
                    script: {
                        messageView.parent = content
                        console.log("AA")
                    }
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: content
                        property: "x"
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: content
                        property: "opacity"
                        duration: 400
                        easing.type: Easing.InOutQuad
                    }
                }
            }

        },
        Transition {
            from: "show"
            to: "hide"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: content
                        property: "x"
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: content
                        property: "opacity"
                        duration: 400
                        easing.type: Easing.InOutQuad
                    }
                }
                ScriptAction {
                    script: {
                        messageView.parent = root
                        console.log("AA")
                    }
                }
            }

        }
    ]


    // 主体内容
    Item {
        id: content
        z: 0
        width: parent.width
        height: parent.height
        // 背景加载
        Background {
            id: backgroundLoader
        }
        // 消息视图
        MessageView {
            id: messageView
        }
    }

    // 打开关闭按钮
    ColorImage {
        id: showIcon
        z: 4
        width: 20
        height: width
        rotation: 90
        source: "qrc:/images/downUp.svg"
        color: "#4F00FF00"
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if(root.state === "show") {
                    root.hide()
                } else {
                    root.show()
                }
            }
        }
    }

    Component {
        id: backgourndCmp
        Rectangle {
           id: background
           anchors.fill: parent
           color: "#2F000000"
        }
    }

    // 单个消息委托
    Component {
        id: messageDelegate
        Rectangle {
            id: msgItem
            x: (messageView.width - width) / 2
            width: messageView.width - root.margin*2
            height: 80
            radius: 8
            opacity: 1
//            visible: opacity
            color: "#2F000000"
            clip: true

            Behavior on opacity {
                NumberAnimation {
                    property: "opacity"
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }

            Row {
                width: parent.width - 20
                height: parent.height - 20
                spacing: 5
                anchors.centerIn: parent
                Image { // 消息图标
                    id: iconImg
                    width: 35
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    source: iconSource
                }
                Column { // 消息信息
                    id: infoText
                    width: parent.width - iconImg.width - parent.spacing*2 - toolBar.width
                    height: parent.height
                    spacing: 5
                    Text {
                        property real maxHeight: parent.height * 0.3
                        width: parent.width
                        height: maxHeight
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        font.pointSize: 12
                        font.bold: true
                        text: title
                        color: "#FFFFFF"
                    }
                    Text {
                        property real maxHeight: parent.height * 0.7 - parent.spacing
                        width: parent.width
                        height: maxHeight
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        font.pointSize: 9
                        text: message
                        color: "#FFFFFF"
                    }
                }

                Column { // 工具栏
                    id: toolBar
                    width: 15
                    MouseArea {
                        width: parent.width
                        height: width
                        cursorShape: Qt.PointingHandCursor
                        Rectangle {
                            width: parent.width
                            height: 1
                            anchors.centerIn: parent
                            rotation: 45
                        }
                        Rectangle {
                            width: parent.width
                            height: 1
                            anchors.centerIn: parent
                            rotation: -45
                        }
                        onClicked: {
                            remove(index)
                        }
                    }
                }
            }
        }

    }


    function show() {
        root.state = "show"
    }

    function hide() {
        root.state = "hide"
    }

    function insert(index,info) {
        let title = info.title || "标题"
        let message = info.message || "信息"
        let iconSource = info.iconSource || "qrc:/images/message.svg"
        model.insert(index,{
                        title: title,
                        message: message,
                        iconSource: iconSource
                     })
        root.added()
    }

    function remove(index,count = 1) {
        model.remove(index, count)
    }

    function clear() {
        model.clear()
    }
}
