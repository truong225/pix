import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.kde.maui 1.0 as Maui

ItemDelegate
{  
    property int picSize : iconSizes.enormous
    property int picRadius : 0
    property bool showLabel : true
    property bool showIndicator : false
    property bool showEmblem:  true
    property bool fit : false
    property bool isHovered :  hovered

    property string indicatorColor: ListView.isCurrentItem ? highlightColor : "transparent"

    property color labelColor : (GridView.isCurrentItem || (keepEmblemOverlay && emblemAdded)) && !hovered && showSelectionBackground? highlightedTextColor : textColor
    property color hightlightedColor : GridView.isCurrentItem || hovered || (keepEmblemOverlay && emblemAdded) ? highlightColor : "transparent"

    property bool showSelectionBackground : true

    property bool emblemAdded : false
    property bool keepEmblemOverlay : false


    signal rightClicked();
    signal emblemClicked();

    hoverEnabled: !isMobile
    focus: true

    background: Rectangle
    {
        color: "transparent"
    }

    MouseArea
    {
        anchors.fill: parent
        acceptedButtons:  Qt.RightButton
        onClicked:
        {
            if(!isMobile && mouse.button === Qt.RightButton)
                rightClicked()
        }
    }

    Maui.ToolButton
    {
        id: emblem

        size:  iconSizes.medium
        iconName: (keepEmblemOverlay && emblemAdded) ? "emblem-remove" : "emblem-added"
        visible: (isHovered || (keepEmblemOverlay && emblemAdded)) && showEmblem
        isMask: false
        z: 999
        anchors.top: parent.top
        anchors.left: parent.left
        onClicked:
        {
            emblemAdded = !emblemAdded
            emblemClicked(index)
        }
    }

    ColumnLayout
    {
        anchors.fill: parent

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter

            Image
            {
                id: img
                anchors.fill: parent
                anchors.centerIn: parent
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                sourceSize.height: picSize
                sourceSize.width: picSize
                cache: false
                antialiasing: true
                smooth: true
                fillMode: fit ? Image.PreserveAspectFit : Image.PreserveAspectCrop
                source: (url && url.length>0)?
                            "file://"+encodeURIComponent(url) :
                            "qrc:/img/assets/image-x-generic.svg"
                asynchronous: true

                Rectangle
                {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: showIndicator
                    color: indicatorColor
                    height: iconSizes.small
                    width: iconSizes.small
                    radius: Math.min(width, height)
                }

                layer.enabled: picRadius > 0
                layer.effect: OpacityMask
                {
                    maskSource: Item
                    {
                        width: img.sourceSize.width
                        height: img.sourceSize.height
                        Rectangle
                        {
                            anchors.centerIn: parent
                            width: img.adapt ? img.sourceSize.width : Math.min(img.sourceSize.width, img.sourceSize.height)
                            height: img.adapt ? img.sourceSize.height : width
                            radius: picRadius
                        }
                    }
                }
            }
        }

        Item
        {
            Layout.fillHeight: showLabel
            Layout.fillWidth: true
            Layout.maximumHeight: !showLabel ? 0 : parent.height * (isMobile? 0.5 : 0.3)
            visible: showLabel

            Label
            {
                text: title
                width: parent.width
                height: parent.height * 0.8
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                elide: Qt.ElideRight
                wrapMode: Text.Wrap
                font.pointSize: fontSizes.default
                color: labelColor

                Rectangle
                {
                    visible: parent.visible && showSelectionBackground
                    anchors.fill: parent
                    z: -1
                    radius: 3
                    color: hightlightedColor
                    opacity: hovered ? 0.25 : 1
                }
            }
        }
    }
}
