
[TOC]

## 开发环境

`Qt版本: ` 6.5.3

`构建: `cmake + minGW64-bit

## 简介

这是一个纯QML程序，功能是一个消息列表的功能，可以进行插入，删除，清空等操作

## 预览图

![2024-08-21 14-28-39_converted](images/2024-08-21 14-28-39_converted.gif)

## 代码

代码一共分为两个部分，分别为main.qml 和 MessageQueueView.qml

### main.qml

展示消息列表组件功能

``` qml
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Item {
        id: root
        width: parent.width
        height: parent.height
        Pane {
            width: parent.width
            height: parent.height
            Column {
                width: 80
                height: 100
                spacing: 10
                Material.theme: Material.System
                Row {
                    Text {
                        text: "插入消息:  "
                    }
                    TextField {
                        Keys.onReturnPressed: {
                            messageQueueView.insert(text,{
                                                     title: "这是一个标题",
                                                     message: "这是第 " + messageQueueView.count +" 条消息"
                                                 })
                        }
                    }
                }
                Row {
                    Text {
                        text: "移除消息:  "
                    }
                    TextField {
                        Keys.onReturnPressed: {
                            messageQueueView.remove(text,1)
                        }
                    }
                }
                Button {
                    text: "清空消息"
                    onClicked: {
                        messageQueueView.clear()
                    }
                    Keys.onReturnPressed: {
                        messageQueueView.model.clear()
                    }
                }
            }
        }

        MessageQueueView {
            id: messageQueueView
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
        }
    }
}
```

### MessageQueueView.qml

消息列表组件

``` qml
// MessageQueueView.qml
import QtQuick
import QtQuick.Controls
Item {
    id: root

    property real margin: 20

    property Component messageItemDelegate: messageDelegate
    property Component background: backgroundCmp

    property alias model: listmodel
    property alias itemsSpacing: listview.spacing
    property alias count: listview.count

    width: 260
    height: 400
    clip: true
    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: root.background
    }
    Component {
        id: backgroundCmp
        Rectangle {
            id: background
            anchors.fill: parent
            color: "#2F000000"
        }
    }


    ListView {
        id: listview
        width: parent.width
        height: parent.height
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        verticalLayoutDirection: ListView.BottomToTop
        model: ListModel {
            id: listmodel
        }

        delegate: messageItemDelegate
        // add 添加 过渡动画 因add导致被影响的项
        add: Transition {
            id: addTrans
            onRunningChanged: {
                console.log("addTran: " + ViewTransition.item)
            }

            ParallelAnimation {

                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
                PathAnimation {
                    duration: 400
                    easing.type: Easing.InOutQuad
                    path: Path {
                        startX: addTrans.ViewTransition.destination.x + 80
                        startY: addTrans.ViewTransition.destination.y
                        PathCurve {
                            x: (listview.width - addTrans.ViewTransition.item.width) / 2
                            y: addTrans.ViewTransition.destination.y
                        }
                    }
                }
            }


        }
        // add 添加 过渡动画
        addDisplaced: Transition {
            id: dispTran
            onRunningChanged: {
                if(running) {
                    console.log("addDispTran: " + ViewTransition.targetIndexes)
                }
            }
            // 如果数据插入太快会导致动画被中断 然后动画控制的属性值无法回到正确的值，在这里手动回到正确的值
            PropertyAction { property: "opacity"; value: 1;}
            PropertyAction { property: "x"; value: (listview.width - dispTran.ViewTransition.item.width) / 2;}


            NumberAnimation {
                property: "y"
                duration: 300
                easing.type: Easing.InOutQuad
            }

        }

        // remove 移除 过渡动画
        remove: Transition {
            id: removeTran
            onRunningChanged: {
                console.log("removeTran: " + ViewTransition.targetIndexes)
            }
            ParallelAnimation {
                NumberAnimation {
                    property: "x"
                    to: listview.width
                    duration: 500
                    easing.type: Easing.InOutQuart
                }
                NumberAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 400
                    easing.type: Easing.InOutQuart
                }
            }


        }
        // remove 移除 过渡动画 因romove导致被影响的项
        removeDisplaced: Transition {
            id: removeDispTran
            onRunningChanged: {
                console.log("removeDispTran: " + ViewTransition.targetIndexes)
            }
            ParallelAnimation {
                NumberAnimation {
                    property: "y"
                    duration: 500
                    easing.type: Easing.InOutQuart
                }
            }
        }

    }

    Component {
        id: messageDelegate
        Rectangle {
            x: (listview.width - width) / 2
            width: listview.width - root.margin*2
            height: 80
            radius: 8
            color: "#2F000000"
            clip: true
            Row {
                width: parent.width - 20
                height: parent.height - 20
                spacing: 5
                anchors.centerIn: parent
                Image {
                    id: iconImg
                    width: 35
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    source: iconSource
                }
                Column {
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
                Column {
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
```

