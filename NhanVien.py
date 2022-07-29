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


def check_ma_nv(s):
    mycursor = mydb.cursor()

    mycursor.execute("SELECT * FROM nhanvien WHERE MaNV = %s", (s,))

    myresult = mycursor.fetchall()

    if len(myresult) != 0:
        return False

    return True


def check_sdt_nv(s):
    s = s.replace("+84", "0")
    mycursor = mydb.cursor()

    mycursor.execute("SELECT * FROM nhanvien_sdt WHERE sdt = %s", (s,))

    myresult = mycursor.fetchall()

    if len(myresult) != 0:
        return False

    s = "0" + s[3:]
    mycursor = mydb.cursor()

    mycursor.execute("SELECT * FROM nhanvien_sdt WHERE sdt = %s", (s,))

    myresult = mycursor.fetchall()

    if len(myresult) != 0:
        return False

    return True


class ThemNhanVien(QtWidgets.QDialog):
    def __init__(self):
        super(ThemNhanVien, self).__init__()
        uic.loadUi('UI/ThemNhanVien.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_save_button)
        self.pushButton_2.clicked.connect(self.on_click_cancel_button)

        s = 1

        while not check_ma_nv(str(s)):
            s += 1

        self.textEdit.setPlainText(str(s))

        self.show()

    def on_click_save_button(self):
        ma_nv = self.textEdit.toPlainText().rstrip()
        ten_nhan_vien = self.textEdit_2.toPlainText().rstrip()
        dia_chi = self.textEdit_3.toPlainText().rstrip()
        sdt = self.textEdit_4.toPlainText().rstrip()
        cap_bac = self.textEdit_5.toPlainText().rstrip()

        if not ma_nv:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Mã nhân viên không được để trống")
            msg.exec_()

            return

        if not ma_nv.isnumeric():
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Mã nhân viên phải là số")
            msg.exec_()

            return

        if not check_ma_nv(ma_nv):
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Mã nhân viên đã tồn tại")
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

        if not check_sdt_nv(sdt):
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Số điện thoại đã tồn tại")
            msg.exec_()

            return

        mycursor = mydb.cursor()

        sql = "INSERT INTO nhanvien (MaNV, Ten, DiaChi, CapBac) VALUES (%s, %s, %s, %s)"
        val = (ma_nv, ten_nhan_vien, dia_chi, cap_bac)
        mycursor.execute(sql, val)

        mydb.commit()

        mycursor = mydb.cursor()

        sql = "INSERT INTO nhanvien_sdt (MaNV, Sdt) VALUES (%s, %s)"
        val = (ma_nv, sdt)
        mycursor.execute(sql, val)

        mydb.commit()

        msg = QtWidgets.QMessageBox()
        msg.setWindowTitle("Thông báo")
        msg.setText("Thêm thành công")
        msg.exec_()

        return

    def on_click_cancel_button(self):
        self.close()


class SuaNhanVien(QtWidgets.QDialog):
    def __init__(self):
        super(SuaNhanVien, self).__init__()
        uic.loadUi('UI/SuaNhanVien.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_save_button)
        self.pushButton_2.clicked.connect(self.on_click_delete_button)
        self.pushButton_3.clicked.connect(self.on_click_cancel_button)

        self.openDialog = None

        self.show()

    def on_click_save_button(self):
        ma_nv = self.textEdit.toPlainText().rstrip()
        ten_nhan_vien = self.textEdit_2.toPlainText().rstrip()
        dia_chi = self.textEdit_3.toPlainText().rstrip()
        sdt = self.textEdit_4.toPlainText().rstrip()
        cap_bac = self.textEdit_5.toPlainText().rstrip()

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

        if not check_sdt_nv(sdt):
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Số điện thoại đã tồn tại")
            msg.exec_()

            return

        mycursor = mydb.cursor()

        sql = "UPDATE nhanvien SET Ten = %s, DiaChi = %s, CapBac = %s WHERE MaNV = %s"
        val = (ten_nhan_vien, dia_chi, cap_bac, ma_nv)
        mycursor.execute(sql, val)

        mydb.commit()

        mycursor = mydb.cursor()

        sql = "UPDATE nhanvien_sdt SET Sdt = %s WHERE MaNV = %s"
        val = (sdt, ma_nv)
        mycursor.execute(sql, val)

        mydb.commit()

        msg = QtWidgets.QMessageBox()
        msg.setWindowTitle("Thông báo")
        msg.setText("Sửa thành công")
        msg.exec_()

        self.close()
        self.openDialog.on_click_search_button()

        return

    def on_click_delete_button(self):
        ma_nv = self.textEdit.toPlainText().rstrip()

        mycursor = mydb.cursor()

        sql = "SET FOREIGN_KEY_CHECKS = 0"
        mycursor.execute(sql)

        mydb.commit()

        mycursor = mydb.cursor()

        sql = "DELETE FROM nhanvien WHERE MaNV = %s"
        val = (ma_nv,)
        mycursor.execute(sql, val)

        mydb.commit()

        mycursor = mydb.cursor()

        sql = "DELETE FROM nhanvien_sdt WHERE MaNV = %s"
        val = (ma_nv,)
        mycursor.execute(sql, val)

        mydb.commit()

        mycursor = mydb.cursor()

        sql = "SET FOREIGN_KEY_CHECKS = 1"
        mycursor.execute(sql)

        mydb.commit()

        msg = QtWidgets.QMessageBox()
        msg.setWindowTitle("Thông báo")
        msg.setText("Xoá thành công")
        msg.exec_()

        self.close()
        self.openDialog.on_click_search_button()

    def on_click_cancel_button(self):
        self.close()


class TimKiemNhanVien(QtWidgets.QDialog):
    def __init__(self):
        super(TimKiemNhanVien, self).__init__()
        uic.loadUi('UI/TimKiemNhanVien.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_search_button)
        self.tableWidget.clicked.connect(self.on_click_table)

        self.show()

    def on_click_search_button(self):
        if not self.textEdit.toPlainText().rstrip() and not self.textEdit_2.toPlainText().rstrip() and not self.textEdit_3.toPlainText().rstrip() \
                and not self.textEdit_4.toPlainText().rstrip() and not self.textEdit_5.toPlainText().rstrip():
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Phải có ít nhất một giá trị tìm kiếm")
            msg.exec_()

            return

        ma_nv = self.textEdit.toPlainText().rstrip()
        ten_nhan_vien = self.textEdit_2.toPlainText().rstrip()
        dia_chi = self.textEdit_3.toPlainText().rstrip()
        sdt = self.textEdit_4.toPlainText().rstrip()
        cap_bac = self.textEdit_5.toPlainText().rstrip()

        if sdt and not validate_sdt(sdt):
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText("Số điện thoại không hợp lệ")
            msg.exec_()

            return

        mycursor = mydb.cursor()
        sql = '''SELECT * FROM nhanvien JOIN nhanvien_sdt ON nhanvien.MaNV = nhanvien_sdt.MaNV WHERE (nhanvien.MaNV = %s OR %s = "") AND (nhanvien.Ten = %s OR %s = "") AND (nhanvien.DiaChi = %s OR %s = "") AND (nhanvien_sdt.Sdt = %s OR %s = "") AND (nhanvien.CapBac = %s OR %s= "")'''
        val = (ma_nv, ma_nv, ten_nhan_vien, ten_nhan_vien, dia_chi, dia_chi, sdt, sdt, cap_bac, cap_bac)

        mycursor.execute(sql, val)

        myresult = mycursor.fetchall()

        self.tableWidget.setRowCount(0)

        for x in myresult:
            rowPosition = self.tableWidget.rowCount()
            self.tableWidget.insertRow(rowPosition)

            self.tableWidget.setItem(rowPosition, 0, QtWidgets.QTableWidgetItem(str(x[0])))
            self.tableWidget.setItem(rowPosition, 1, QtWidgets.QTableWidgetItem(str(x[1])))
            self.tableWidget.setItem(rowPosition, 2, QtWidgets.QTableWidgetItem(str(x[2])))
            self.tableWidget.setItem(rowPosition, 3, QtWidgets.QTableWidgetItem(str(x[5])))
            self.tableWidget.setItem(rowPosition, 4, QtWidgets.QTableWidgetItem(str(x[3])))

            self.tableWidget.item(rowPosition, 0).setTextAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
            self.tableWidget.item(rowPosition, 1).setTextAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
            self.tableWidget.item(rowPosition, 2).setTextAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
            self.tableWidget.item(rowPosition, 3).setTextAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
            self.tableWidget.item(rowPosition, 4).setTextAlignment(QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)

    def on_click_table(self, item):
        dialog = SuaNhanVien()
        dialog.openDialog = self

        dialog.textEdit.setPlainText(self.tableWidget.item(item.row(), 0).text())
        dialog.textEdit_2.setPlainText(self.tableWidget.item(item.row(), 1).text())
        dialog.textEdit_3.setPlainText(self.tableWidget.item(item.row(), 2).text())
        dialog.textEdit_4.setPlainText(self.tableWidget.item(item.row(), 3).text())
        dialog.textEdit_5.setPlainText(self.tableWidget.item(item.row(), 4).text())

        dialog.exec_()


if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = TimKiemNhanVien()
    app.exec_()
