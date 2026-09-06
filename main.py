import sys
from PyQt6.QtCore import QUrl, QObject, pyqtSignal, pyqtSlot
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

class AddressManager(QObject):
    # Оголошуємо сигнал як атрибут класу (без @)
    addressSaved = pyqtSignal(str, str, str)

    # Використовуємо @pyqtSlot, щоб QML міг викликати цю функцію
    @pyqtSlot(str, str, str)
    def saveAddress(self, city, street, building):
        data = f"Місто: {city} | Вулиця: {street} | Будинок: {building}\n"
        with open("saved_addresses.txt", "a", encoding="utf-8") as f:
            f.write(data)
        print("Адресу успішно збережено!")

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    
    manager = AddressManager()
    engine.rootContext().setContextProperty("addressManager", manager)
    
    engine.load(QUrl("main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())