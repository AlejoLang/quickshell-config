import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "root:/services/" as Services
import "../../../general/"

Rectangle {
    id: root
    property list<PwNode> sinksList: Services.Audio.sinksList
    property list<PwNode> sourcesList: Services.Audio.sourcesList
    implicitWidth: 400
    implicitHeight: nodesColumn.height
    radius: 10

    Column {
        id: nodesColumn
        spacing: 10
        padding: 10
        width: parent.implicitWidth
        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            Text {
                text: "Sinks"
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                font.bold: true
            }
            Repeater {
                model: root.sinksList
                Item {
                    id: sinkItem
                    width: parent.width
                    height: children[0].height
                    Rectangle {
                        color: "#f0f0f0"
                        border.color: "#d0d0d0"
                        border.width: 1
                        radius: 5
                        implicitHeight: children[0].height
                        implicitWidth: parent.width
                        Column {
                            spacing: 5
                            padding: 5
                            width: parent.width 
                            RowLayout {
                                spacing: 5
                                width: parent.width
                                Text {
                                    text: modelData.description
                                    Layout.fillWidth: true
                                    clip: true
                                    elide: Text.ElideRight
                                    font.pixelSize: 18
                                    font.family: "CaskaydiaCove Nerd Font"
                                }
                                Text {
                                    text: modelData?.id == Services.Audio?.currentSink?.id ? "check_box" : "check_box_outline_blank"
                                    Layout.preferredWidth: 30
                                    font.pixelSize: 18
                                    font.family: "Material Symbols Rounded"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            Services.Audio.switchAudioSink(modelData.id);
                                        }
                                    } 
                                }
                            }
                            Slide {
                                id: sinkSlider
                                height: 10
                                width: parent.width - 20
                                percentaje: modelData.audio.volume.toFixed(2)
                                onPercentajeChanged: {
                                    Services.Audio.setNodeVolume(modelData.id, percentaje.toFixed(2));
                                }
                            }
                        }
                       
                    }
                }
            }
        }
        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 20
            Text {
                text: "Sources"
                font.pixelSize: 18
                font.family: "CaskaydiaCove Nerd Font"
                font.bold: true
            }
            Repeater {
                model: root.sourcesList
                Item {
                    id: sourceItem
                    width: parent.width
                    height: children[0].height
                    Rectangle {
                        color: "#f0f0f0"
                        border.color: "#d0d0d0"
                        border.width: 1
                        radius: 5
                        implicitHeight: children[0].height
                        implicitWidth: parent.width
                        Column {
                            spacing: 5
                            padding: 5
                            width: parent.width 
                            RowLayout {
                                spacing: 5
                                width: parent.width
                                Text {
                                    text: modelData.description
                                    Layout.fillWidth: true
                                    clip: true
                                    elide: Text.ElideRight
                                    font.pixelSize: 18
                                    font.family: "CaskaydiaCove Nerd Font"
                                }
                                Text {
                                    text: modelData.id == Services.Audio.currentSource.id ? "check_box" : "check_box_outline_blank"
                                    Layout.preferredWidth: 30
                                    font.pixelSize: 18
                                    font.family: "Material Symbols Rounded"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            Services.Audio.switchAudioSource(modelData.id);
                                        }
                                    } 
                                }
                            }
                            
                            Slide {
                                id: sourceSlider
                                height: 10
                                width: parent.width - 20
                                percentaje: modelData.audio.volume.toFixed(2)
                                onPercentajeChanged: {
                                    Services.Audio.setNodeVolume(modelData.id, percentaje.toFixed(2));
                                }
                            }
                        }
                       
                    }
                }
            }
        }
    }
}