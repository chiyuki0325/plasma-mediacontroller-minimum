import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.private.mpris as Mpris
import org.kde.kirigami as Kirigami

RowLayout {
    id: playerControls

    property bool enabled: root.canControl
    property bool compactView: true
    property bool canFitPrevNext: true

    property int controlSize: parent.height + 2
    readonly property int controlSmallerSize: Math.min(controlSize,
                                                       Math.max(Math.round(controlSize / 1.25), Kirigami.Units.iconSizes.medium))
    readonly property int controlsCount : 1 + (prevButton.visible ? 1 : 0) +  (nextButton.visible ? 1 : 0)

    spacing: compactView ?  0 : Kirigami.Units.largeSpacing

    Layout.minimumHeight: oneLineLayout.Layout.minimumHeight


    PlasmaComponents3.ToolButton {
        id: prevButton
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        implicitWidth: controlSmallerSize
        implicitHeight: implicitWidth
        enabled: playerControls.enabled && root.canGoPrevious

        icon.name: LayoutMirroring.enabled ? "media-skip-forward" : "media-skip-backward"
        onClicked: {
            //root.position = 0    // Let the media start from beginning. Bug 362473
            root.previous()
        }
        Layout.minimumHeight: oneLineLayout.Layout.minimumHeight
    }

    PlasmaComponents3.ToolButton {
        Layout.alignment: Qt.AlignCenter
        implicitWidth: controlSize
        implicitHeight: implicitWidth
        enabled: root.metadata.playbackStatus == Mpris.PlaybackStatus.Playing ? root.canPause : root.canPlay
        icon.name: root.metadata.playbackStatus == Mpris.PlaybackStatus.Playing ? "media-playback-pause" : "media-playback-start"
        onClicked: root.togglePlaying()
        Layout.minimumHeight: oneLineLayout.Layout.minimumHeight
    }

    PlasmaComponents3.ToolButton {
        id: nextButton
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        implicitWidth: controlSmallerSize
        implicitHeight: implicitWidth
        enabled: playerControls.enabled && root.canGoNext

        icon.name: LayoutMirroring.enabled ? "media-skip-backward" : "media-skip-forward"
        onClicked: {
            //root.position = 0    // Let the media start from beginning. Bug 362473
            root.next()
        }
        Layout.minimumHeight: oneLineLayout.Layout.minimumHeight
    }
}
