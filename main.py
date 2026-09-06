import sys
import os
from PyQt6.QtCore import QUrl, QObject, pyqtSignal, pyqtSlot
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

class AddressManager(QObject):
    # Сигнал для передачі масиву рядків у QML
    addressesLoaded = pyqtSignal(list)

    def __init__(self):
        super().__init__()
        self.filepath = "saved_addresses.txt"

    # Слот для читання даних, викликається QML при запуску та після збереження
    @pyqtSlot()
    def fetchAddresses(self):
        address_list = []
        if os.path.exists(self.filepath):
            with open(self.filepath, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line:
                        address_list.append(line)
        # Відправляємо масив у QML, перевертаючи його ([::-1]), щоб нові адреси були зверху
        self.addressesLoaded.emit(address_list[::-1])

    @pyqtSlot(str, str, str)
    def saveAddress(self, city, street, building):
        data = f"Місто: {city} | Вулиця: {street} | Будинок: {building}\n"
        with open(self.filepath, "a", encoding="utf-8") as f:
            f.write(data)
        print(f"Збережено: {data.strip()}")
        # Одразу оновлюємо список в інтерфейсі
        self.fetchAddresses()

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    
    manager = AddressManager()
    engine.rootContext().setContextProperty("addressManager", manager)
    
    engine.load(QUrl("main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())