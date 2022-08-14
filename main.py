import sys

from PyQt5 import QtWidgets, uic, QtGui, QtCore

import GiaoDich
import KhachHang
import NhanVien
import TaiKhoan
import TruyVan


class Ui(QtWidgets.QDialog):
    def __init__(self):
        super(Ui, self).__init__()
        uic.loadUi('UI/MainMenu.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_add_button)
        self.pushButton_2.clicked.connect(self.on_click_search_button)
        self.pushButton_3.clicked.connect(self.on_click3)
        self.pushButton_4.clicked.connect(self.on_click4)
        self.pushButton_5.clicked.connect(self.on_click5)
        self.pushButton_6.clicked.connect(self.on_click6)

        self.show()

    def on_click_add_button(self):
        if self.comboBox.currentText() == "Nhân viên":
            dialog = NhanVien.ThemNhanVien()
            dialog.exec_()

        if self.comboBox.currentText() == "Khách hàng":
            dialog = KhachHang.ThemKhachHang()
            dialog.exec_()

        if self.comboBox.currentText() == "Tài khoản":
            dialog = TaiKhoan.ThemTaiKhoan()
            dialog.exec_()

        if self.comboBox.currentText() == "Giao dịch":
            dialog = GiaoDich.ThemGiaoDich()
            dialog.exec_()

    def on_click_search_button(self):
        if self.comboBox.currentText() == "Nhân viên":
            dialog = NhanVien.TimKiemNhanVien()
            dialog.exec_()

        if self.comboBox.currentText() == "Khách hàng":
            dialog = KhachHang.TimKiemKhachHang()
            dialog.exec_()

        if self.comboBox.currentText() == "Giao dịch":
            dialog = GiaoDich.TimKiemGiaoDich()
            dialog.exec_()

    def on_click3(self):
        dialog = TruyVan.TinhLuong()
        dialog.exec_()

    def on_click4(self):
        dialog = TruyVan.LietKeTinDung()
        dialog.exec_()

    def on_click5(self):
        dialog = TruyVan.LietKeNoTinDung()
        dialog.exec_()

    def on_click6(self):
        dialog = TruyVan.LietKeTongTienGui()
        dialog.exec_()


if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = Ui()
    app.exec_()
