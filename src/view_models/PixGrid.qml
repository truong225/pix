import QtQuick.Controls 2.2
import QtQuick 2.9

PixPage
{
    id: gridPage

    /*props*/
    property int picSize : 150
    property int picSpacing: 50
    property int picRadius : 4

    property alias grid: grid
    property alias holder: holder

    /*signals*/
    signal picClicked(int index)

    PixHolder
    {
        id: holder
        message: "<h2>No Pics!</h2><p>There's not images in here</p>"
        emoji: "qrc:/img/assets/face-hug.png"
        visible: grid.count === 0
    }

    headerbarTitle: gridModel.count+" "+qsTr("images")

    headerBarRight: [
        PixButton
        {
            id: menuBtn
            iconName: "overflow-menu"
        }
    ]

    content: GridView
    {
        id: grid
        clip: true
        width: parent.width
        height: parent.height

        cellWidth: picSize + picSpacing
        cellHeight: picSize + picSpacing


        focus: true
        boundsBehavior: Flickable.StopAtBounds

        flickableDirection: Flickable.AutoFlickDirection

        snapMode: GridView.SnapToRow
        //        flow: GridView.FlowTopToBottom
        //        maximumFlickVelocity: albumSize*8


        model: ListModel {id: gridModel}


        highlightFollowsCurrentItem: true
        highlight: Rectangle
        {
            width: picSize + picSpacing
            height: picSize + picSpacing
            color: highlightColor
        }

        onWidthChanged:
        {
            var amount = parseInt(grid.width/(picSize + picSpacing),10)
            var leftSpace = parseInt(grid.width-(amount*(picSize + picSpacing)), 10)
            var size = parseInt((picSize + picSpacing)+(parseInt(leftSpace/amount, 10)), 10)

            size = size > picSize + picSpacing ? size : picSize + picSpacing

            grid.cellWidth = size
            //            grid.cellHeight = size
        }

        delegate: PixPic
        {
            id: delegate

            picSize : gridPage.picSize

            Connections
            {
                target: delegate
                onClicked:
                {
                    picClicked(index)
                    grid.currentIndex = index
                }
            }
        }

        ScrollBar.vertical: ScrollBar{ visible: true}
    }

    function clear()
    {
        gridModel.clear()
    }

}
