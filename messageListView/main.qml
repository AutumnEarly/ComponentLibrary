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
