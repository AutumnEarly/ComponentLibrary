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
