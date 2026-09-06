import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "Форма збору геоадрес (MagneticOne)"

    Column {
        anchors.centerIn: parent
        spacing: 15

        TextField {
            id: cityInput
            placeholderText: "Введіть місто/село"
            width: 250
        }

        TextField {
            id: streetInput
            placeholderText: "Введіть вулицю"
            width: 250
        }

        TextField {
            id: buildingInput
            placeholderText: "Номер будинку"
            width: 250
        }

        Button {
            text: "Зберегти адресу"
            width: 250
            onClicked: {
                addressManager.saveAddress(cityInput.text, streetInput.text, buildingInput.text)
                cityInput.text = ""
                streetInput.text = ""
                buildingInput.text = ""
            }
        }
    }
}