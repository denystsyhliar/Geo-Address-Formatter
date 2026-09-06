import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 850      // Збільшили ширину для двох панелей
    height: 500
    minimumWidth: 750
    minimumHeight: 450
    title: "Форма збору геоадрес (MagneticOne)"
    color: "#1e1e2e"

    // Об'єкт для прийому сигналів із Python
    Connections {
        target: addressManager
        function onAddressesLoaded(addressList) {
            historyModel.clear() // Очищаємо стару модель
            // Проходимось по масиву та заповнюємо QML-модель
            for (let i = 0; i < addressList.length; i++) {
                historyModel.append({"addressText": addressList[i]})
            }
        }
    }

    // Локальна структура даних для списку
    ListModel {
        id: historyModel
    }

    // Тригер, що спрацьовує під час відкриття програми
    Component.onCompleted: {
        addressManager.fetchAddresses()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // ЛІВА ПАНЕЛЬ: Картка вводу даних
        Rectangle {
            id: formCard
            Layout.preferredWidth: 350
            Layout.fillHeight: true
            color: "#252538"
            radius: 12

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 15

                Label {
                    text: "Нова геоадреса"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#cdd6f4"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 10
                }

                TextField {
                    id: cityInput
                    placeholderText: "Місто / Село"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    font.pixelSize: 14
                    color: "#cdd6f4"
                    background: Rectangle {
                        color: "#181825"
                        radius: 8
                        border.color: cityInput.activeFocus ? "#89b4fa" : "#313244"
                        border.width: 2
                    }
                }

                TextField {
                    id: streetInput
                    placeholderText: "Вулиця"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    font.pixelSize: 14
                    color: "#cdd6f4"
                    background: Rectangle {
                        color: "#181825"
                        radius: 8
                        border.color: streetInput.activeFocus ? "#89b4fa" : "#313244"
                        border.width: 2
                    }
                }

                TextField {
                    id: buildingInput
                    placeholderText: "Номер будинку"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    font.pixelSize: 14
                    color: "#cdd6f4"
                    background: Rectangle {
                        color: "#181825"
                        radius: 8
                        border.color: buildingInput.activeFocus ? "#89b4fa" : "#313244"
                        border.width: 2
                    }
                }

                Item { Layout.fillHeight: true } // Пружина

                Button {
                    id: saveButton
                    text: "ЗБЕРЕГТИ АДРЕСУ"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    font.pixelSize: 14
                    font.bold: true
                    
                    background: Rectangle {
                        color: saveButton.down ? "#74c7ec" : (saveButton.hovered ? "#89dceb" : "#89b4fa")
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: saveButton.text
                        font: saveButton.font
                        color: "#11111b"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        // Захист від порожніх полів (базова валідація)
                        if (cityInput.text.trim() !== "" && streetInput.text.trim() !== "") {
                            addressManager.saveAddress(cityInput.text, streetInput.text, buildingInput.text)
                            cityInput.text = ""
                            streetInput.text = ""
                            buildingInput.text = ""
                        }
                    }
                }
            }
        }

        // ПРАВА ПАНЕЛЬ: Історія збережень
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#252538"
            radius: 12

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                Label {
                    text: "Історія бази даних"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#cdd6f4"
                }

                // Декоративний розділювач
                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    color: "#313244"
                }

                // Динамічний список
                ListView {
                    id: addressList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: historyModel // Прив'язка до даних
                    clip: true          // Обрізати елементи при прокрутці
                    spacing: 10

                    // Шаблон відмальовування одного елемента списку
                    delegate: Rectangle {
                        width: addressList.width
                        height: 50
                        color: "#181825"
                        radius: 8
                        border.color: "#313244"
                        border.width: 1

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            text: model.addressText
                            color: "#a6adc8"
                            font.pixelSize: 13
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight // Додає "..." якщо текст задовгий
                        }
                    }
                }
            }
        }
    }
}