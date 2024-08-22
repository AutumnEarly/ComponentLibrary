import QtQuick 2.15

/*
    消息视图
*/
ListView {
    id: listview

    width: parent.width
    height: parent.height
    spacing: 10
    anchors.horizontalCenter: parent.horizontalCenter
    verticalLayoutDirection: ListView.BottomToTop
    clip: true
    model: root.model

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
                duration: 400
                easing.type: Easing.OutQuart
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

    // populate 委托项加载时触发
    populate: Transition {
        id: popuTran
        NumberAnimation {
            property: "opacity"
            duration: 300
            from: 0
            to: 1
            easing.type: Easing.OutCubic
        }
    }

    ScroolBar.vertical: ScroolBar {

    }

}

