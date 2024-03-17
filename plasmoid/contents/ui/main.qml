import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.private.mpris as Mpris

PlasmoidItem {
    id: root

    property var metadata: mpris2Model.currentPlayer ? mpris2Model.currentPlayer : undefined

    property string trackTitle: {
        if (metadata.track) return metadata.track
        return ""
    }

    property string artist: {
        if (metadata.artist) return metadata.artist
        return ""
    }

    property string albumArt: {
        return metadata
            ? metadata.artUrl || ""
            : ""
    }

    property string separatorString: {
        let separatorStr = ""

        if (plasmoid.configuration.shouldAddLeadingWhitespaceToSeparator)
            separatorStr += " "

        separatorStr += plasmoid.configuration.separatorString

        if (plasmoid.configuration.shouldAddTrailingWhitespaceToSeparator)
            separatorStr += " "

        return separatorStr
    }

    property string oneLineTextContent: {
        if (!metadata) return plasmoid.configuration.noMediaString
        if (!(trackTitle == "") && artist == "") return plasmoid.configuration.noArtistString
        if (!trackTitle && !artist) return ""

        if (plasmoid.configuration.shouldDisplayTitleOnly)
            return trackTitle

        let content
        if (plasmoid.configuration.shouldDisplayTitleFirst) {
            content = trackTitle
                + separatorString
                + artist
        } else {
            content = artist
                + separatorString
                + trackTitle
        }

        if (content.length > plasmoid.configuration.characterLimit)
            content = content.slice(0, plasmoid.configuration.characterLimit) + "..."

        return content
    }

    Mpris.Mpris2Model {
        id: mpris2Model
        onDataChanged: {
            updateLayoutSize()
        }
        onCurrentPlayerChanged: {
            updateLayoutSize()
        }
    }

    function updateLayoutSize() {
        Layout.minimumWidth = oneLineLayout.contentWidth
        Layout.minimumHeight = plasmoid.configuration.layoutHeight
    }


    readonly property bool canControl: mpris2Model.currentPlayer?.canControl ?? false
    readonly property bool canGoPrevious: mpris2Model.currentPlayer?.canGoPrevious ?? false
    readonly property bool canGoNext: mpris2Model.currentPlayer?.canGoNext ?? false
    readonly property bool canPlay: mpris2Model.currentPlayer?.canPlay ?? false
    readonly property bool canPause: mpris2Model.currentPlayer?.canPause ?? false


    function previous() {
        mpris2Model.currentPlayer.Previous()
    }
    function next() {
        mpris2Model.currentPlayer.Next()
    }
    function play() {
        mpris2Model.currentPlayer.Play()
    }
    function pause() {
        mpris2Model.currentPlayer.Pause()
    }
    function stop() {
        mpris2Model.currentPlayer.Stop()
    }
    function quit() {
        mpris2Model.currentPlayer.Quit()
    }
    function togglePlaying() {
        mpris2Model.currentPlayer.PlayPause()
    }
    function raise() {
        mpris2Model.currentPlayer.Raise()
    }

    preferredRepresentation: fullRepresentation
    fullRepresentation: OneLineLayout {
        id: oneLineLayout
        Layout.minimumWidth: oneLineLayout.contentWidth
        Layout.minimumHeight: plasmoid.configuration.layoutHeight
    }


    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18nc("Open player window or bring it to the front if already open", "Open")
            icon.name: "go-up-symbolic"
            priority: PlasmaCore.Action.LowPriority
            visible: root.canRaise
            onTriggered: raise()
        },
        PlasmaCore.Action {
            text: i18nc("Play previous track", "Previous Track")
            icon.name: Qt.application.layoutDirection === Qt.RightToLeft ? "media-skip-forward" : "media-skip-backward"
            priority: PlasmaCore.Action.LowPriority
            visible: root.canControl
            enabled: root.canGoPrevious
            onTriggered: previous()
        },
        PlasmaCore.Action {
            text: i18nc("Pause playback", "Pause")
            icon.name: "media-playback-pause"
            priority: PlasmaCore.Action.LowPriority
            visible: root.isPlaying && root.canPause
            enabled: visible
            onTriggered: pause()
        },
        PlasmaCore.Action {
            text: i18nc("Start playback", "Play")
            icon.name: "media-playback-start"
            priority: PlasmaCore.Action.LowPriority
            visible: root.canControl && !root.isPlaying
            enabled: root.canPlay
            onTriggered: play()
        },
        PlasmaCore.Action {
            text: i18nc("Play next track", "Next Track")
            icon.name: Qt.application.layoutDirection === Qt.RightToLeft ? "media-skip-backward" : "media-skip-forward"
            priority: PlasmaCore.Action.LowPriority
            visible: root.canControl
            enabled: root.canGoNext
            onTriggered: next()
        },
        PlasmaCore.Action {
            text: i18nc("Stop playback", "Stop")
            icon.name: "media-playback-stop"
            priority: PlasmaCore.Action.LowPriority
            visible: root.canControl
            enabled: root.canStop
            onTriggered: stop()
        },
        PlasmaCore.Action {
            isSeparator: true
            priority: PlasmaCore.Action.LowPriority
            visible: root.canQuit
        },
        PlasmaCore.Action {
            text: i18nc("Quit player", "Quit")
            icon.name: "application-exit"
            priority: PlasmaCore.Action.LowPriority
            visible: root.canQuit
            onTriggered: quit()
        }
    ]
}
