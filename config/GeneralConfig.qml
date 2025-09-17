import Quickshell.Io

JsonObject {
    property Apps apps: Apps {}

    component Apps: JsonObject {
        property list<string> terminal: ["kitty"]
        property list<string> audio: ["pavucontrol"]
        property list<string> playback: ["mpv"]
        property list<string> explorer: ["nautilus"]
    }
}
