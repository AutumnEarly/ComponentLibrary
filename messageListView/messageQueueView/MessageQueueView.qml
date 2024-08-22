// MessageQueueView.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./resource"

Item {
    id: root


    property real margin: 20

    property Component messageItemDelegate: messageDelegate
    property Component background: Rectangle {
        anchors.fill: parent
        color: "#20000000"
    }
    property ListModel model: ListModel {}

    property alias itemsSpacing: messageView.spacing
    property alias count: messageView.count

    width: 260
    height: 400

    state: "open"
    states: [
        State {
            name: "close"
            PropertyChanges {
                target: contentItem
                opacity: 0
                x: root.width
            }
            PropertyChanges {
                target: openIcon
                parent: root
                anchors.right: contentItem.left
                anchors.verticalCenter: contentItem.verticalCenter
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: contentItem
                opacity: 1
                x: 0
            }
            PropertyChanges {
                target: openIcon
                parent: root
                anchors.right: contentItem.left
                anchors.verticalCenter: contentItem.verticalCenter
            }
        }
    ]
    transitions: [
        Transition {
            from: "close"
            to: "open"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: contentItem
                        property: "x"
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: contentItem
                        property: "opacity"
                        duration: 400
                        easing.type: Easing.InOutQuad
                    }
                }
            }

        },
        Transition {
            from: "open"
            to: "close"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        target: contentItem
                        property: "x"
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: contentItem
                        property: "opacity"
                        duration: 400
                        easing.type: Easing.InOutQuad
                    }
                }
            }

        }
    ]

    // 主体内容
    Item {
        id: contentItem
        z: 0
        width: parent.width
        height: parent.height
        clip: true
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
        id: openIcon
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
                if(root.state === "open") {
                    root.close()
                } else {
                    root.open()
                }
            }
        }
    }

    // 单个消息委托
    Component {
        id: messageDelegate
        Rectangle {
            x: (messageView.width - width) / 2
            width: messageView.width - root.margin*2
            height: 80
            radius: 8
            color: "#2F000000"
            clip: true
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
                        height: contentHeight
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        font.pointSize: 12
                        font.bold: true
                        text: title
                        color: "#FFFFFF"
                        onContentHeightChanged: (contentHeight) => {
                            if(contentHeight > maxHeight) {
                                height = maxHeight
                            } else {
                                height = contentHeight
                            }
                        }
                    }
                    Text {
                        property real maxHeight: parent.height * 0.7 - parent.spacing
                        width: parent.width
                        height: contentHeight
                        wrapMode: Text.Wrap
                        font.pointSize: 10
                        text: message
                        color: "#FFFFFF"
                        onContentHeightChanged: (contentHeight) => {
                            if(contentHeight > maxHeight) {
                                height = maxHeight
                            } else {
                                height = contentHeight
                            }
                        }
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

    function open() {
        root.state = "open"
    }
    function close() {
        root.state = "close"
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
    }
    function remove(index,count = 1) {
        model.remove(index, count)
    }
    function clear() {
        model.clear()
    }
}
