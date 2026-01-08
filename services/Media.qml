pragma Singleton
import Quickshell.Services.Mpris
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property list<MprisPlayer> players: Mpris.players.values
    property int currentPlayerIdx: 0
    property MprisPlayer currentPlayer: players[currentPlayerIdx] ?? null

    onPlayersChanged: {
        if (currentPlayerIdx > (players.length - 1)) {
            currentPlayerIdx = Math.max(0, players.length - 1);
        }
        currentPlayer = players[currentPlayerIdx] ?? null;
    }

    function increasePlayerIndex() {
        if (players && players.length > 0) {
            currentPlayerIdx = (currentPlayerIdx + 1) % players.length;
            currentPlayer = players[currentPlayerIdx];
        }
    }

    function decreasePlayerIndex() {
        if (players && players.length > 0) {
            currentPlayerIdx = (currentPlayerIdx - 1 + players.length) % players.length;
            currentPlayer = players[currentPlayerIdx];
        }
    }

    function setPlayerIndex(index) {
        if (players && players.length > 0) {
            currentPlayerIdx = (index + players.length) % players.length;
            currentPlayer = players[currentPlayerIdx];
        }
    }

    function getPlayerPosAsTime(position) {
        if (!position || isNaN(position)) {
            return "0:00:00";
        }
        const date = new Date(position * 1000);
        return date.toISOString().substr(11, 8); // HH:MM:SS
    }

    function getPlayerLengthAsTime(position) {
        if (!position || isNaN(position)) {
            return "0:00:00";
        }
        const date = new Date(position * 1000);
        return date.toISOString().substr(11, 8); // HH:MM:SS
    }

    function setPlayerPosition(player, newPosition) {
        if (!player || newPosition === undefined || isNaN(newPosition)) {
            console.warn("Invalid player or position provided to setPlayerPosition:", player, newPosition);
            return;
        }
        if (setPlayerPosition.running) {
            return;
        }
        setPlayerPosition.player = player;
        setPlayerPosition.newPosition = newPosition;
        setPlayerPosition.running = true;
    }

    Process {
        id: setPlayerPosition
        property MprisPlayer player
        property int newPosition: 0
        running: false
        command: ["dbus-send", 
                    "--print-reply",
                    "--dest=" + player?.dbusName, 
                    "/org/mpris/MediaPlayer2", 
                    "org.mpris.MediaPlayer2.Player.SetPosition", 
                    "objpath:/org/mpris/MediaPlayer2/TrackList/0",
                    "int64:" + newPosition * 1000000]
    }
}
