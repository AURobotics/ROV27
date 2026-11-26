import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

def main():
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    qml_file = "main.qml"
    engine.load(qml_file)

    if not engine.rootObjects():
        return 1

    return app.exec()
if __name__ == "__main__":
    sys.exit(main())
    