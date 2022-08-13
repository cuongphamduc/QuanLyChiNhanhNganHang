from PyQt5 import QtWidgets, uic, QtGui, QtCore
import sys
import mysql.connector
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

                mycursor.callproc("ThemKHCN", [ma_kh, ten_khach_hang, dia_chi, sdt, nghe_nghiep, thu_nhap, ])

                mydb.commit()
                mycursor.close()
            else:
                mycursor = mydb.cursor()

                mycursor.callproc("ThemKHTCDN", [ma_kh, ten_khach_hang, dia_chi, sdt, dai_dien, quy_mo, ])

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


if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = ThemKhachHang()
    app.exec_()
