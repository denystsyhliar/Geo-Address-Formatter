import sys
import os
from PyQt6.QtCore import QUrl, QObject, pyqtSignal, pyqtSlot
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

class AddressManager(QObject):
    addressesLoaded = pyqtSignal(list)

    def __init__(self):
        super().__init__()
        # Визначаємо папку, де знаходиться сама програма/скрипт для збереження txt файлу
        if getattr(sys, 'frozen', False):
            self.base_dir = os.path.dirname(sys.executable)
        else:
            self.base_dir = os.path.dirname(os.path.abspath(__file__))
        
        self.filepath = os.path.join(self.base_dir, "saved_addresses.txt")

    @pyqtSlot()
    def fetchAddresses(self):
        address_list = []
        if os.path.exists(self.filepath):
            with open(self.filepath, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line:
                        address_list.append(line)
        self.addressesLoaded.emit(address_list[::-1])

    @pyqtSlot(str, str, str)
    def saveAddress(self, city, street, building):
        data = f"Місто: {city} | Вулиця: {street} | Будинок: {building}\n"
        with open(self.filepath, "a", encoding="utf-8") as f:
            f.write(data)
        print(f"Збережено: {data.strip()}")
        self.fetchAddresses()

def resolve_qml_path(filename):
    """Динамічне визначення шляху до QML залежно від середовища виконання"""
    if getattr(sys, 'frozen', False):
        # PyInstaller поміщає data-файли у _internal (sys._MEIPASS)
        return os.path.join(sys._MEIPASS, filename)
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), filename)

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    
    manager = AddressManager()
    engine.rootContext().setContextProperty("addressManager", manager)
    
    # Використовуємо абсолютний локальний шлях замість відносного
    qml_file = resolve_qml_path("main.qml")
    engine.load(QUrl.fromLocalFile(qml_file))
    
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())