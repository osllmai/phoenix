import QtQuick 2.8
import QtQuick.Timeline 1.0
// import QtQuick.Studio 1.0
// import QtQuick.Shapes 1.15
import QtQuick.Shapes
// import QtQuick.Studio.Components
import QtQml


Item {
    id: root
    width: 610* root.ratio
    height: 548* root.ratio
    property int kphDisplay: kph_number_195_91.text
    property int kplDisplay: kpl_number_195_93.text
    property int kphFrame: kphTimeline.currentFrame
    property color textColor: "black"
    property double ratio: 1/4

    Image {
        id: speed_dial_195_151Asset
        x: 161* root.ratio
        y: 153* root.ratio
        height: 275* root.ratio
        width: 275* root.ratio
        source: "images/speed_dial_195_151.png"
    }

    Item {
        id: speed_numbers_195_116
        x: 0
        y: 0
        Text {
            id: kph_195_95
            x: 151* root.ratio
            y: 523* root.ratio
            color: root.textColor
            text: "0"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_96
            x: 81* root.ratio
            y: 484* root.ratio
            color: root.textColor
            text: "10"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_97
            x: 29* root.ratio
            y: 421* root.ratio
            color: root.textColor
            text: "20"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_98
            x: 2* root.ratio
            y: 357* root.ratio
            color: root.textColor
            text: "30"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_99
            x: -11* root.ratio
            y: 280* root.ratio
            color: root.textColor
            text: "40"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_100
            x: -2* root.ratio
            y: 204* root.ratio
            color: root.textColor
            text: "50"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_101
            x: 16* root.ratio
            y: 135* root.ratio
            color: "#CCCCCC"
            text: "60"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_102
            x: 66* root.ratio
            y: 70* root.ratio
            color: root.textColor
            text: "70"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_103
            x: 125* root.ratio
            y: 15* root.ratio
            color: root.textColor
            text: "80"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_104
            x: 197* root.ratio
            y: -14* root.ratio
            color: root.textColor
            text: "90"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_105
            x: 274* root.ratio
            y: -23* root.ratio
            color: root.textColor
            text: "100"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_106
            x: 364* root.ratio
            y: -11* root.ratio
            color: root.textColor
            text: "110"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_107
            x: 435* root.ratio
            y: 13* root.ratio
            color: root.textColor
            text: "120"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_108
            x: 495* root.ratio
            y: 62* root.ratio
            color: root.textColor
            text: "130"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_109
            x: 539* root.ratio
            y: 127* root.ratio
            color: root.textColor
            text: "140"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_110
            x: 562* root.ratio
            y: 196* root.ratio
            color: root.textColor
            text: "150"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_111
            x: 575* root.ratio
            y: 269* root.ratio
            color: root.textColor
            text: "160"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_112
            x: 569* root.ratio
            y: 352* root.ratio
            color: root.textColor
            text: "170"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_113
            x: 538* root.ratio
            y: 424* root.ratio
            color: root.textColor
            text: "180"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_114
            x: 494* root.ratio
            y: 485* root.ratio
            color: root.textColor
            text: "190"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }

        Text {
            id: kph_195_115
            x: 426* root.ratio
            y: 524* root.ratio
            color: root.textColor
            text: "200"
            font.weight: Font.Thin
            font.pixelSize: 29* root.ratio
            font.family: "Exo 2"
        }
    }

    Item {
        id: speedometer_dots_195_141
        x: 54* root.ratio
        y: 45* root.ratio
        CustomDot {
            id: dot_0_195_140
            x: 127* root.ratio
            y: 457* root.ratio
        }

        CustomDot {
            id: dot_10_195_125
            x: 73* root.ratio
            y: 422* root.ratio
        }

        CustomDot {
            id: dot_20_195_129
            x: 31* root.ratio
            y: 366* root.ratio
        }

        CustomDot {
            id: dot_30_195_132
            x: 8* root.ratio
            y: 310* root.ratio
        }

        CustomDot {
            id: dot_40_195_121
            x: -2* root.ratio
            y: 248* root.ratio
        }

        CustomDot {
            id: dot_50_195_135
            x: 6* root.ratio
            y: 182* root.ratio
        }

        CustomDot {
            id: dot_60_195_138
            x: 28* root.ratio
            y: 123* root.ratio
        }

        CustomDot {
            id: dot_70_195_123
            x: 68* root.ratio
            y: 72* root.ratio
        }

        CustomDot {
            id: dot_80_195_127
            x: 117* root.ratio
            y: 32* root.ratio
        }

        CustomDot {
            id: dot_90_195_131
            x: 176* root.ratio
            y: 8* root.ratio
        }

        CustomDot {
            id: dot_100_195_120
            x: 238* root.ratio
            y: 0* root.ratio
        }

        CustomDot {
            id: dot_110_195_134
            x: 303* root.ratio
            y: 8* root.ratio
        }

        CustomDot {
            id: dot_120_195_139
            x: 361* root.ratio
            y: 32* root.ratio
        }

        CustomDot {
            id: dot_130_195_126
            x: 412* root.ratio
            y: 70* root.ratio
        }

        CustomDot {
            id: dot_140_195_130
            x: 450* root.ratio
            y: 120* root.ratio
        }

        CustomDot {
            id: dot_150_195_133
            x: 474* root.ratio
            y: 178* root.ratio
        }

        CustomDot {
            id: dot_160_195_122
            x: 482* root.ratio
            y: 242* root.ratio
        }

        CustomDot {
            id: dot_170_195_136
            x: 475* root.ratio
            y: 307* root.ratio
        }

        CustomDot {
            id: dot_180_195_137
            x: 451* root.ratio
            y: 363* root.ratio
        }

        CustomDot {
            id: dot_190_195_124
            x: 412* root.ratio
            y: 415* root.ratio
        }

        CustomDot {
            id: dot_200_195_128
            x: 361* root.ratio
            y: 454* root.ratio
        }
    }

    Image {
        id: sppedometer_outer_ring_195_86
        x: 41* root.ratio
        y: 34* root.ratio
        width: 517* root.ratio
        height: 485* root.ratio
        source: "images/sppedometer_outer_ring_195_86.png"
    }

    Image {
        id: speedometer_track_bg_195_87
        x: 69* root.ratio
        y: 61* root.ratio
        width: 460* root.ratio
        height: 433* root.ratio
        source: "images/speedometer_track_bg_195_87.png"
    }

    Image {
        id: speedometer_needle_ring_195_90
        x: 153* root.ratio
        y: 145* root.ratio
        height: 292* root.ratio
        width: 292* root.ratio
        source: "images/speedometer_needle_ring_195_90.png"
    }

    Text {
        id: kpl_number_195_93
        x: 192* root.ratio
        y: 315* root.ratio
        width: 219* root.ratio
        height: 57* root.ratio
        color: "#FFFFFF"
        text: "15.5"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 42* root.ratio
        font.family: "Cherry"
    }

    Text {
        id: kpl_readout_195_118
        x: 277* root.ratio
        y: 371* root.ratio
        color: "#FFFFFF"
        text: "CPU"
        font.weight: Font.ExtraLight
        font.pixelSize: 32* root.ratio
        font.family: "IBM Plex Mono"
    }

    Text {
        id: kph_number_195_91
        x: 187* root.ratio
        y: 201* root.ratio
        width: 230* root.ratio
        height: 98* root.ratio* root.ratio
        color: "#FFFFFF"
        text: "140"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 72* root.ratio
        font.family: "Cherry"
    }

    Text {
        id: kph_readout_195_117
        x: 277* root.ratio
        y: 173* root.ratio
        color: root.textColor
        text: "KPH"
        font.weight: Font.ExtraLight
        font.pixelSize: 30* root.ratio
        font.family: "IBM Plex Mono"
    }

    // Shape {
    //         anchors.fill: parent
    //         ShapePath {
    //             strokeColor: "blue"
    //             strokeWidth: 4
    //             fillColor: "lightblue"
    //             fillRule: ShapePath.OddEvenFill
    //             startX: 200
    //             startY: 200
    //             ArcItem {
    //                 centerX: 200
    //                 centerY: 200
    //                 radiusX: 100
    //                 radiusY: 100
    //                 startAngle: 0
    //                 sweepAngle: 120
    //             }
    //         }
    //     }

    // Shape {
    //     x: 76* root.ratio
    //     y: 71* root.ratio
    //     width: 445* root.ratio
    //     height: 442* root.ratio
    //     ShapePath {
    //         strokeColor: "blue"
    //         strokeWidth: 4
    //         fillColor: "lightblue"
    //         startX: 200
    //         startY: 200
    //         PathArc {
    //             id: arc
    //             x: 200   // End X-coordinate of the arc
    //             y: 200   // End Y-coordinate of the arc
    //             radiusX: 100
    //             radiusY: 100
    //             largeArc: false
    //             sweep: true
    //         }
    //     }
    // }



    // Shape {
    //     id: progressShape

    //     width: 445* root.ratio
    //     height: 442* root.ratio
    //     layer.enabled: true
    //     layer.samples: 8

    //     ShapePath {
    //         id: progressShapePath

    //         strokeColor: control.progressColor
    //         fillColor: "#00ffffff"
    //         strokeWidth: control.progressWidth
    //         capStyle: control.capStyle
    //         startX: -61.3


    //         PathArc {
    //             id: arc
    //             radiusX: 76* root.ratio
    //             radiusY: 71* root.ratio

    //         }
    //     }
    // }

    // ArcItem {
    //     id: arc
    //     x: 76* root.ratio
    //     y: 71* root.ratio
    //     width: 445* root.ratio
    //     height: 442* root.ratio
    //     fillColor: "#00ffffff"
    //     rotation: -90
    //     strokeColor: "#5ca8ba"
    //     end: 239.7
    //     begin: -61.3
    //     strokeWidth: 45* root.ratio
    // }

    Item {
        id: item1
        x: 200* root.ratio
        y: 191* root.ratio
        width: 200* root.ratio
        height: 200* root.ratio

        Image {
            id: speedometer_needle_195_142
            x: 224* root.ratio
            y: -23* root.ratio
            height: 51* root.ratio
            width: 72* root.ratio
            source: "images/speedometer_needle_195_142.png"
        }
    }

    Timeline {
        id: kphTimeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                property: "currentFrame"
                loops: 1
                duration: 1000
                from: 0
                to: 1000
                running: false
            }
        ]
        enabled: true
        startFrame: 0
        endFrame: 200

        KeyframeGroup {
            target: item1
            property: "rotation"

            Keyframe {
                frame: 0
                value: -209.5
            }

            Keyframe {
                frame: 200
                value: 92.5
            }
        }

        KeyframeGroup {
            target: arc
            property: "end"

            Keyframe {
                frame: 0
                value: -61.3
            }

            Keyframe {
                frame: 200
                value: 240.2
            }

            Keyframe {
                frame: 10
                value: -46.45
            }

            Keyframe {
                frame: 30
                value: -16.13
            }

            Keyframe {
                frame: 40
                value: -0.78
            }

            Keyframe {
                frame: 50
                value: 14.55
            }

            Keyframe {
                frame: 70
                value: 44.77
            }

            Keyframe {
                frame: 80
                value: 59.96
            }

            Keyframe {
                frame: 190
                value: 225.12
            }
        }

        KeyframeGroup {
            target: kph_195_95
            property: "scale"

            Keyframe {
                frame: 0
                value: 1.2
            }

            Keyframe {
                frame: 2
                value: 1.2
            }

            Keyframe {
                frame: 4
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_95
            property: "color"

            Keyframe {
                frame: 0
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 2
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 4
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_96
            property: "scale"
            Keyframe {
                frame: 9
                value: 1.2
            }

            Keyframe {
                frame: 11
                value: 1.2
            }

            Keyframe {
                frame: 7
                value: 1
            }

            Keyframe {
                frame: 13
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_96
            property: "color"
            Keyframe {
                frame: 7
                value: root.textColor
            }

            Keyframe {
                frame: 9
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 11
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 13
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_97
            property: "scale"
            Keyframe {
                frame: 19
                value: 1.2
            }

            Keyframe {
                frame: 21
                value: 1.2
            }

            Keyframe {
                frame: 17
                value: 1
            }

            Keyframe {
                frame: 23
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_97
            property: "color"
            Keyframe {
                frame: 17
                value: root.textColor
            }

            Keyframe {
                frame: 19
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 21
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 23
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_98
            property: "scale"
            Keyframe {
                frame: 29
                value: 1.2
            }

            Keyframe {
                frame: 31
                value: 1.2
            }

            Keyframe {
                frame: 27
                value: 1
            }

            Keyframe {
                frame: 33
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_98
            property: "color"
            Keyframe {
                frame: 27
                value: root.textColor
            }

            Keyframe {
                frame: 29
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 31
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 33
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_99
            property: "scale"
            Keyframe {
                frame: 39
                value: 1.2
            }

            Keyframe {
                frame: 41
                value: 1.2
            }

            Keyframe {
                frame: 37
                value: 1
            }

            Keyframe {
                frame: 43
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_99
            property: "color"
            Keyframe {
                frame: 37
                value: root.textColor
            }

            Keyframe {
                frame: 39
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 41
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 43
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_100
            property: "scale"
            Keyframe {
                frame: 49
                value: 1.2
            }

            Keyframe {
                frame: 51
                value: 1.2
            }

            Keyframe {
                frame: 47
                value: 1
            }

            Keyframe {
                frame: 53
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_100
            property: "color"
            Keyframe {
                frame: 47
                value: root.textColor
            }

            Keyframe {
                frame: 49
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 51
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 53
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_101
            property: "scale"
            Keyframe {
                frame: 59
                value: 1.2
            }

            Keyframe {
                frame: 61
                value: 1.2
            }

            Keyframe {
                frame: 57
                value: 1
            }

            Keyframe {
                frame: 63
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_101
            property: "color"
            Keyframe {
                frame: 57
                value: root.textColor
            }

            Keyframe {
                frame: 59
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 61
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 63
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_102
            property: "scale"
            Keyframe {
                frame: 68
                value: 1.2
            }

            Keyframe {
                frame: 70
                value: 1.2
            }

            Keyframe {
                frame: 66
                value: 1
            }

            Keyframe {
                frame: 72
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_102
            property: "color"
            Keyframe {
                frame: 66
                value: root.textColor
            }

            Keyframe {
                frame: 68
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 70
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 72
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_103
            property: "scale"
            Keyframe {
                frame: 79
                value: 1.2
            }

            Keyframe {
                frame: 81
                value: 1.2
            }

            Keyframe {
                frame: 77
                value: 1
            }

            Keyframe {
                frame: 83
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_103
            property: "color"
            Keyframe {
                frame: 77
                value: root.textColor
            }

            Keyframe {
                frame: 79
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 81
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 83
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_104
            property: "scale"
            Keyframe {
                frame: 89
                value: 1.2
            }

            Keyframe {
                frame: 91
                value: 1.2
            }

            Keyframe {
                frame: 87
                value: 1
            }

            Keyframe {
                frame: 93
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_104
            property: "color"
            Keyframe {
                frame: 87
                value: root.textColor
            }

            Keyframe {
                frame: 89
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 91
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 93
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_105
            property: "scale"
            Keyframe {
                frame: 99
                value: 1.2
            }

            Keyframe {
                frame: 101
                value: 1.2
            }

            Keyframe {
                frame: 97
                value: 1
            }

            Keyframe {
                frame: 103
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_105
            property: "color"
            Keyframe {
                frame: 97
                value: root.textColor
            }

            Keyframe {
                frame: 99
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 101
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 103
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_106
            property: "scale"
            Keyframe {
                frame: 109
                value: 1.2
            }

            Keyframe {
                frame: 111
                value: 1.2
            }

            Keyframe {
                frame: 107
                value: 1
            }

            Keyframe {
                frame: 113
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_106
            property: "color"
            Keyframe {
                frame: 107
                value: root.textColor
            }

            Keyframe {
                frame: 109
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 111
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 113
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_107
            property: "scale"
            Keyframe {
                frame: 119
                value: 1.2
            }

            Keyframe {
                frame: 121
                value: 1.2
            }

            Keyframe {
                frame: 117
                value: 1
            }

            Keyframe {
                frame: 123
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_107
            property: "color"
            Keyframe {
                frame: 117
                value: root.textColor
            }

            Keyframe {
                frame: 119
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 121
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 123
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_108
            property: "scale"
            Keyframe {
                frame: 129
                value: 1.2
            }

            Keyframe {
                frame: 131
                value: 1.2
            }

            Keyframe {
                frame: 127
                value: 1
            }

            Keyframe {
                frame: 133
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_108
            property: "color"
            Keyframe {
                frame: 127
                value: root.textColor
            }

            Keyframe {
                frame: 129
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 131
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 133
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_109
            property: "scale"
            Keyframe {
                frame: 139
                value: 1.2
            }

            Keyframe {
                frame: 141
                value: 1.2
            }

            Keyframe {
                frame: 137
                value: 1
            }

            Keyframe {
                frame: 143
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_109
            property: "color"
            Keyframe {
                frame: 137
                value: root.textColor
            }

            Keyframe {
                frame: 139
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 141
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 143
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_110
            property: "scale"
            Keyframe {
                frame: 149
                value: 1.2
            }

            Keyframe {
                frame: 151
                value: 1.2
            }

            Keyframe {
                frame: 147
                value: 1
            }

            Keyframe {
                frame: 153
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_110
            property: "color"
            Keyframe {
                frame: 147
                value: root.textColor
            }

            Keyframe {
                frame: 149
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 151
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 153
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_111
            property: "scale"
            Keyframe {
                frame: 159
                value: 1.2
            }

            Keyframe {
                frame: 161
                value: 1.2
            }

            Keyframe {
                frame: 157
                value: 1
            }

            Keyframe {
                frame: 163
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_111
            property: "color"
            Keyframe {
                frame: 157
                value: root.textColor
            }

            Keyframe {
                frame: 159
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 161
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 163
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_112
            property: "scale"
            Keyframe {
                frame: 169
                value: 1.2
            }

            Keyframe {
                frame: 171
                value: 1.2
            }

            Keyframe {
                frame: 167
                value: 1
            }

            Keyframe {
                frame: 173
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_112
            property: "color"
            Keyframe {
                frame: 167
                value: root.textColor
            }

            Keyframe {
                frame: 169
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 171
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 173
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_113
            property: "scale"
            Keyframe {
                frame: 179
                value: 1.2
            }

            Keyframe {
                frame: 181
                value: 1.2
            }

            Keyframe {
                frame: 177
                value: 1
            }

            Keyframe {
                frame: 183
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_113
            property: "color"
            Keyframe {
                frame: 177
                value: root.textColor
            }

            Keyframe {
                frame: 179
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 181
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 183
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_114
            property: "scale"
            Keyframe {
                frame: 189
                value: 1.2
            }

            Keyframe {
                frame: 191
                value: 1.2
            }

            Keyframe {
                frame: 187
                value: 1
            }

            Keyframe {
                frame: 193
                value: 1
            }
        }

        KeyframeGroup {
            target: kph_195_114
            property: "color"
            Keyframe {
                frame: 187
                value: root.textColor
            }

            Keyframe {
                frame: 189
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 191
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 193
                value: root.textColor
            }
        }

        KeyframeGroup {
            target: kph_195_115
            property: "scale"
            Keyframe {
                frame: 196
                value: 1
            }

            Keyframe {
                frame: 198
                value: 1.2
            }

            Keyframe {
                frame: 200
                value: 1.2
            }
        }

        KeyframeGroup {
            target: kph_195_115
            property: "color"
            Keyframe {
                frame: 196
                value: root.textColor
            }

            Keyframe {
                frame: 198
                value: "#5ca8ba"
            }

            Keyframe {
                frame: 200
                value: "#5ca8ba"
            }
        }
    }
}



