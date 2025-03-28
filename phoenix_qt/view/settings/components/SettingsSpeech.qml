import QtQuick 2.15
import QtQuick.Controls 2.15
import QtTextToSpeech
import "../../component_library/button"
import '../../component_library/style' as Style

Item {
    id: control

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Row {
            Label {
                text: "Engine:"
                width: 100
                color: Style.Colors.textTitle
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
            }
            MyComboBox {
                id: enginesComboBox
                model: textToSpeechId.availableEngines()

                onActivated: {
                    if (textToSpeechId.state === TextToSpeech.Speaking) {
                        textToSpeechId.stop()
                    }
                    textToSpeechId.engine = textAt(currentIndex)
                    control.updateLocales()
                    control.updateVoices()
                }
            }
        }

        Row {
            Label {
                text: "Locale:"
                width: 100
                color: Style.Colors.textTitle
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
            }
            MyComboBox {
                id: localesComboBox

                onActivated: {
                    let locales = textToSpeechId.availableLocales()
                    if (currentIndex >= 0 && currentIndex < locales.length) {
                        textToSpeechId.locale = locales[currentIndex]
                        control.updateVoices()
                    }
                }
            }
        }

        Row {
            Label {
                text: "Voice:"
                width: 100
                color: Style.Colors.textTitle
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
            }
            MyComboBox {
                id: voicesComboBox

                onActivated: {
                    let voices = textToSpeechId.availableVoices()
                    if (currentIndex >= 0 && currentIndex < voices.length) {
                        textToSpeechId.voice = voices[currentIndex]
                    }
                }
            }
        }

        SettingsSlider {
            id: volumeSlider
            myTextName: "Volume:"
            myTextToolTip: "Volume"
            sliderValue: appSettings.speechVolume
            sliderFrom: 0.0
            sliderTo: 1.0
            sliderStepSize: 0.2

            onSliderValueChanged: {
                appSettings.speechVolume = sliderValue;
                appSettings.setValue("speechVolume", sliderValue);
            }
        }

        SettingsSlider {
            id: pitchSlider
            myTextName: "Pitch:"
            myTextToolTip: "Pitch"
            sliderValue: appSettings.speechPitch
            sliderFrom: -1.0
            sliderTo: 1.0
            sliderStepSize: 0.5

            onSliderValueChanged: {
                appSettings.speechPitch = sliderValue;
                appSettings.setValue("speechPitch", sliderValue);
            }
        }

        SettingsSlider {
            id: rateSlider
            myTextName: "Rate:"
            myTextToolTip: "Rate"
            sliderValue: appSettings.speechRate
            sliderFrom: -1.0
            sliderTo: 1.0
            sliderStepSize: 0.5

            onSliderValueChanged: {
                appSettings.speechRate = sliderValue;
                appSettings.setValue("speechRate", sliderValue);
            }
        }
    }

    Component.onCompleted: {
        let availableEngines = textToSpeechId.availableEngines();
        let engineIndex = availableEngines.indexOf(textToSpeechId.engine);
        enginesComboBox.currentIndex = engineIndex >= 0 ? engineIndex : 0;

        if (textToSpeechId.state === TextToSpeech.Ready) {
            control.engineReady();
        } else {
            textToSpeechId.stateChanged.connect(control.engineReady);
        }

        textToSpeechId.updateStateLabel(textToSpeechId.state);
    }

    function engineReady() {
        textToSpeechId.stateChanged.disconnect(control.engineReady);
        if (textToSpeechId.state !== TextToSpeech.Ready) {
            textToSpeechId.updateStateLabel(textToSpeechId.state);
            return;
        }
        control.updateLocales();
        control.updateVoices();
    }

    function updateLocales() {
        let allLocales = textToSpeechId.availableLocales().map(locale => locale.nativeLanguageName);
        let currentLocaleIndex = allLocales.indexOf(textToSpeechId.locale.nativeLanguageName);
        localesComboBox.model = allLocales;
        localesComboBox.currentIndex = currentLocaleIndex >= 0 ? currentLocaleIndex : 0;
    }

    function updateVoices() {
        let availableVoices = textToSpeechId.availableVoices();
        voicesComboBox.model = availableVoices.map(voice => voice.name);
        voicesComboBox.currentIndex = availableVoices.indexOf(textToSpeechId.voice) || 0;
    }
}
