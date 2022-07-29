from PyQt5 import QtWidgets, uic, QtGui, QtCore
import sys
import NhanVien
import KhachHang


class Ui(QtWidgets.QDialog):
    def __init__(self):
        super(Ui, self).__init__()
        uic.loadUi('UI/MainMenu.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_add_button)
        self.pushButton_2.clicked.connect(self.on_click_search_button)

        self.show()

    def on_click_add_button(self):
        if self.comboBox.currentText() == "Nhân viên":
            dialog = NhanVien.ThemNhanVien()
            dialog.exec_()

        if self.comboBox.currentText() == "Khách hàng":
            dialog = KhachHang.ThemKhachHang()
            dialog.exec_()

    def on_click_search_button(self):
        if self.comboBox.currentText() == "Nhân viên":
            dialog = NhanVien.TimKiemNhanVien()
            dialog.exec_()

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = Ui()
    app.exec_()
