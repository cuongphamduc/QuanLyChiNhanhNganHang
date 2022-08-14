import sys

import mysql.connector
from PyQt5 import QtWidgets, uic, QtGui, QtCore
from mysql.connector import Error

with open("config.txt", "r") as f:
    user = f.readline().rstrip()
    password = f.readline().rstrip()

try:
    mydb = mysql.connector.connect(host='localhost',
                                   database='chinhanhnganhang',
                                   user=user,
                                   password=password)
    if mydb.is_connected():
        db_Info = mydb.get_server_info()
        print("Connected to MySQL Server version ", db_Info)
        cursor = mydb.cursor()
        cursor.execute("select database();")
        record = cursor.fetchone()
        print("You're connected to database: ", record)

except Error as e:
    print("Error while connecting to MySQL", e)


class ThemKhachHang(QtWidgets.QDialog):
    def __init__(self):
        super(ThemKhachHang, self).__init__()
        uic.loadUi('UI/ThemKhachHang.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_save_button)
        self.pushButton_2.clicked.connect(self.on_click_cancel_button)
        self.comboBox.currentTextChanged.connect(self.on_combobox_changed)

        mycursor = mydb.cursor()

        res = mycursor.callproc("TaoMaKH", [0, ])

        mycursor.close()

        self.textEdit.setPlainText(str(res[0]))

        self.show()

    def on_combobox_changed(self, value):
        if value == "Khách hàng cá nhân":
            self.textEdit_5.setDisabled(False)
            self.textEdit_6.setDisabled(False)
            self.textEdit_7.setDisabled(True)
            self.textEdit_8.setDisabled(True)

            self.textEdit_7.clear()
            self.textEdit_8.clear()
        else:
            self.textEdit_5.setDisabled(True)
            self.textEdit_6.setDisabled(True)
            self.textEdit_7.setDisabled(False)
            self.textEdit_8.setDisabled(False)

            self.textEdit_5.clear()
            self.textEdit_6.clear()

    def on_click_save_button(self):
        try:
            ma_kh = self.textEdit.toPlainText().rstrip()
            ten_khach_hang = self.textEdit_2.toPlainText().rstrip()
            dia_chi = self.textEdit_3.toPlainText().rstrip()
            sdt = self.textEdit_4.toPlainText().rstrip()
            nghe_nghiep = self.textEdit_5.toPlainText().rstrip()
            thu_nhap = self.textEdit_6.toPlainText().rstrip()
            dai_dien = self.textEdit_7.toPlainText().rstrip()
            quy_mo = self.textEdit_8.toPlainText().rstrip()

            if self.comboBox.currentText() == "Khách hàng cá nhân":
                mycursor = mydb.cursor()

                mycursor.callproc("ThemKhachHangCaNhan", [ma_kh, ten_khach_hang, dia_chi, sdt, nghe_nghiep, thu_nhap, ])

                mydb.commit()
                mycursor.close()
            else:
                mycursor = mydb.cursor()

                mycursor.callproc("ThemKkhachHangToChucDoanhNghiep",
                                  [ma_kh, ten_khach_hang, dia_chi, sdt, dai_dien, quy_mo, ])

                mydb.commit()
                mycursor.close()

            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Thông báo")
            msg.setText("Thêm thành công")
            msg.exec_()
        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()

        self.close()

    def on_click_cancel_button(self):
        self.close()


class SuaKhachHang(QtWidgets.QDialog):
    def __init__(self):
        super(SuaKhachHang, self).__init__()
        uic.loadUi('UI/SuaKhachHang.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_save_button)
        self.pushButton_2.clicked.connect(self.on_click_delete_button)
        self.pushButton_3.clicked.connect(self.on_click_cancel_button)

        self.openDialog = None

        self.show()

    def on_click_save_button(self):
        try:
            ma_kh = self.textEdit.toPlainText().rstrip()
            ten_khach_hang = self.textEdit_2.toPlainText().rstrip()
            dia_chi = self.textEdit_3.toPlainText().rstrip()
            sdt = self.textEdit_4.toPlainText().rstrip()
            nghe_nghiep = self.textEdit_5.toPlainText().rstrip()
            thu_nhap = self.textEdit_6.toPlainText().rstrip()
            dai_dien = self.textEdit_7.toPlainText().rstrip()
            quy_mo = self.textEdit_8.toPlainText().rstrip()

            if self.comboBox.currentText() == "Khách hàng cá nhân":
                mycursor = mydb.cursor()

                mycursor.callproc("SuaKhachHangCaNhan", [ma_kh, ten_khach_hang, dia_chi, sdt, nghe_nghiep, thu_nhap, ])

                mydb.commit()
                mycursor.close()
            else:
                mycursor = mydb.cursor()

                mycursor.callproc("SuaKhachHangToChucDoanhNghiep",
                                  [ma_kh, ten_khach_hang, dia_chi, sdt, dai_dien, quy_mo, ])

                mydb.commit()
                mycursor.close()

            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Thông báo")
            msg.setText("Sửa thành công")
            msg.exec_()
        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()

        self.close()
        self.openDialog.on_click_search_button()

    def on_click_delete_button(self):
        try:
            ma_kh = self.textEdit.toPlainText().rstrip()

            mycursor = mydb.cursor()

            if self.comboBox.currentText() == "Khách hàng cá nhân":
                mycursor.callproc("XoaKhachHangCaNhan", [ma_kh, ])
            else:
                mycursor.callproc("XoaKhachHangToChucDoanhNghiep", [ma_kh, ])

            mydb.commit()
            mycursor.close()

            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Thông báo")
            msg.setText("Xoá thành công")
            msg.exec_()
        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()

        self.close()
        self.openDialog.on_click_search_button()

    def on_click_cancel_button(self):
        self.close()


class TimKiemKhachHang(QtWidgets.QDialog):
    def __init__(self):
        super(TimKiemKhachHang, self).__init__()
        uic.loadUi('UI/TimKiemKhachHang.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_search_button)
        self.tableWidget.clicked.connect(self.on_click_table)
        self.comboBox.currentTextChanged.connect(self.on_combobox_changed)

        self.show()

    def on_combobox_changed(self, value):
        if value == "Khách hàng cá nhân":
            self.tableWidget.setHorizontalHeaderLabels(
                ["Mã khách hàng", "Tên", "Địa chỉ", "Số điện thoại", "Nghề nghiệp", "Thu nhập"])
        else:
            self.tableWidget.setHorizontalHeaderLabels(
                ["Mã khách hàng", "Tên", "Địa chỉ", "Số điện thoại", "Người đại diện", "Quy mô"])

        self.on_click_search_button()

    def on_click_search_button(self):
        try:
            ma_kh = self.textEdit.toPlainText().rstrip()
            ten = self.textEdit_2.toPlainText().rstrip()
            sdt = self.textEdit_3.toPlainText().rstrip()

            mycursor = mydb.cursor()

            if self.comboBox.currentText() == "Khách hàng cá nhân":
                mycursor.callproc("TimKiemKhachHangCaNhan", [ma_kh, ten, sdt, ])
            else:
                mycursor.callproc("TimKiemKhachHangToChucDoanhNghiep", [ma_kh, ten, sdt, ])

            myresult = mycursor.stored_results()

            self.tableWidget.setRowCount(0)

            for m in myresult:
                for x in m.fetchall():
                    rowPosition = self.tableWidget.rowCount()
                    self.tableWidget.insertRow(rowPosition)

                    self.tableWidget.setItem(rowPosition, 0, QtWidgets.QTableWidgetItem(str(x[0])))
                    self.tableWidget.setItem(rowPosition, 1, QtWidgets.QTableWidgetItem(str(x[1])))
                    self.tableWidget.setItem(rowPosition, 2, QtWidgets.QTableWidgetItem(str(x[2])))
                    self.tableWidget.setItem(rowPosition, 3, QtWidgets.QTableWidgetItem(str(x[4])))
                    self.tableWidget.setItem(rowPosition, 4, QtWidgets.QTableWidgetItem(str(x[6])))
                    self.tableWidget.setItem(rowPosition, 5, QtWidgets.QTableWidgetItem(str(x[7])))

                    self.tableWidget.item(rowPosition, 0).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
                    self.tableWidget.item(rowPosition, 1).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
                    self.tableWidget.item(rowPosition, 2).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
                    self.tableWidget.item(rowPosition, 3).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
                    self.tableWidget.item(rowPosition, 4).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
                    self.tableWidget.item(rowPosition, 5).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()

    def on_click_table(self, item):
        dialog = SuaKhachHang()
        dialog.openDialog = self

        dialog.comboBox.setCurrentText(self.comboBox.currentText())

        dialog.textEdit.setPlainText(self.tableWidget.item(item.row(), 0).text())
        dialog.textEdit_2.setPlainText(self.tableWidget.item(item.row(), 1).text())
        dialog.textEdit_3.setPlainText(self.tableWidget.item(item.row(), 2).text())
        dialog.textEdit_4.setPlainText(self.tableWidget.item(item.row(), 3).text())
        dialog.textEdit_5.setPlainText(self.tableWidget.item(item.row(), 4).text())
        dialog.textEdit_6.setPlainText(self.tableWidget.item(item.row(), 5).text())

        dialog.exec_()


if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = ThemKhachHang()
    app.exec_()
