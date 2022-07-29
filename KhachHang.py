from PyQt5 import QtWidgets, uic, QtGui, QtCore
import sys
import mysql.connector
from mysql.connector import Error


def validate_sdt(s):
    if s[0] == "0":
        if len(s) == 10 and s.isnumeric():
            return True

    if s[:3] == "+84":
        if len(s) == 12 and s[1:].isnumeric():
            return True

    return False


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


def check_ma_kh(s):
    mycursor = mydb.cursor()

    mycursor.execute("SELECT * FROM khachhang WHERE MaKH = %s", (s,))

    myresult = mycursor.fetchall()

    if len(myresult) != 0:
        return False

    return True


def check_sdt_kh(s):
    s = s.replace("+84", "0")
    mycursor = mydb.cursor()

    mycursor.execute("SELECT * FROM khachhang_sdt WHERE sdt = %s", (s,))

    myresult = mycursor.fetchall()

    if len(myresult) != 0:
        return False

    s = "0" + s[3:]
    mycursor = mydb.cursor()

    mycursor.execute("SELECT * FROM khachhang_sdt WHERE sdt = %s", (s,))

    myresult = mycursor.fetchall()

    if len(myresult) != 0:
        return False

    return True


class ThemKhachHang(QtWidgets.QDialog):
    def __init__(self):
        super(ThemKhachHang, self).__init__()
        uic.loadUi('UI/ThemKhachHang.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_save_button)
        self.pushButton_2.clicked.connect(self.on_click_cancel_button)
        self.comboBox.currentTextChanged.connect(self.on_combobox_changed)

        s = 1

        while not check_ma_kh(str(s)):
            s += 1

        self.textEdit.setPlainText(str(s))

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
        ma_kh = self.textEdit.toPlainText().rstrip()
        ten_khach_hang = self.textEdit_2.toPlainText().rstrip()
        dia_chi = self.textEdit_3.toPlainText().rstrip()
        sdt = self.textEdit_4.toPlainText().rstrip()
        nghe_nghiep = self.textEdit_5.toPlainText().rstrip()
        thu_nhap = self.textEdit_6.toPlainText().rstrip()
        dai_dien = self.textEdit_7.toPlainText().rstrip()
        quy_mo = self.textEdit_8.toPlainText().rstrip()

        if not ma_kh:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Mã khách hàng không được để trống")
            msg.exec_()

            return

        if not ma_kh.isnumeric():
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Mã khách hàng phải là số")
            msg.exec_()

            return

        if not check_ma_kh(ma_kh):
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Mã khách hàng đã tồn tại")
            msg.exec_()

            return

        if not sdt:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Số điện thoại không được để trống")
            msg.exec_()

            return

        if not validate_sdt(sdt):
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Số điện thoại không hợp lệ")
            msg.exec_()

            return

        if not check_sdt_kh(sdt):
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Số điện thoại đã tồn tại")
            msg.exec_()

            return

        if thu_nhap and not thu_nhap.isnumeric():
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Thu nhập phải là số")
            msg.exec_()

            return

        if quy_mo and not quy_mo.isnumeric():
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Quy mô phải là số")
            msg.exec_()

            return

        mycursor = mydb.cursor()

        sql = "INSERT INTO khachhang (MaKH, Ten, DiaChi) VALUES (%s, %s, %s)"
        val = (ma_kh, ten_khach_hang, dia_chi)
        mycursor.execute(sql, val)

        mydb.commit()

        mycursor = mydb.cursor()

        sql = "INSERT INTO khachhang_sdt (MaKH, Sdt) VALUES (%s, %s)"
        val = (ma_kh, sdt)
        mycursor.execute(sql, val)

        mydb.commit()

        mycursor = mydb.cursor()

        if self.comboBox.currentText() == "Khách hàng cá nhân":
            sql = "INSERT INTO khachhangcanhan (MaKHCN, NgheNghiep, ThuNhap) VALUES (%s, %s, %s)"
            val = (ma_kh, nghe_nghiep, thu_nhap)
            mycursor.execute(sql, val)

            mydb.commit()
        else:
            sql = "INSERT INTO khachhangtochucdoanhnghiep (MaKHTCDN, NguoiDaiDien, QuyMo) VALUES (%s, %s, %s)"
            val = (ma_kh, dai_dien, quy_mo)
            mycursor.execute(sql, val)

            mydb.commit()

        msg = QtWidgets.QMessageBox()
        msg.setWindowTitle("Thông báo")
        msg.setText("Thêm thành công")
        msg.exec_()

        return

    def on_click_cancel_button(self):
        self.close()


if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = ThemKhachHang()
    app.exec_()
