import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "./messageQueueView"

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
                                                     title: "这是一个消息的标题",
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
                Row {
                    Button {
                        text: "清空消息"
                        onClicked: {
                            messageQueueView.clear()
                        }
                        Keys.onReturnPressed: {
                            messageQueueView.model.clear()
                        }
                    }
                    Button {
                        text: "打开"
                        onClicked: {
                            messageQueueView.show()
                        }
                        Keys.onReturnPressed: {
                            messageQueueView.show()
                        }
                    }
                    Button {
                        text: "关闭"
                        onClicked: {
                            messageQueueView.hide()
                        }
                        Keys.onReturnPressed: {
                            messageQueueView.hide()
                        }
                    }
                }


            }
        }

        MessageQueueView {
            id: messageQueueView
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            Component.onCompleted: {

            }
        }
    }
    Timer {
        property var data: [
            {
                title: "这是一个消息的标题",
                message: "这是一个消息,这是一个消息,这是一个消息,这是一个消息,这是一个消息,这是一个消息,这是一个消息"
            },
            {
                title: "这是一个消息的标题",
                message: "这不是一个消息，这不是一个消息，这不是一个消息，这不是一个消息，这不是一个消息，这不是一个消息"
            },
            {
                title: "这是一个消息的标题",
                message: "好吧，这是一一一条消息"
            },
        ]
        property int current: 0
        interval: 400
        onTriggered: {
            if(current < data.length) {
                messageQueueView.insert(0,data[current]);
                current ++;
                start();
            }
        }
        Component.onCompleted: {
            start()
        }
    }
}
