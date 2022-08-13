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


class ThemNhanVien(QtWidgets.QDialog):
    def __init__(self):
        super(ThemNhanVien, self).__init__()
        uic.loadUi('UI/ThemNhanVien.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_save_button)
        self.pushButton_2.clicked.connect(self.on_click_cancel_button)

        mycursor = mydb.cursor()

        res = mycursor.callproc("TaoMaNV", [0, ])

        mycursor.close()

        self.textEdit.setPlainText(str(res[0]))

        self.show()

    def on_click_save_button(self):
        try:
            ma_nv = self.textEdit.toPlainText().rstrip()
            ten_nhan_vien = self.textEdit_2.toPlainText().rstrip()
            dia_chi = self.textEdit_3.toPlainText().rstrip()
            sdt = self.textEdit_4.toPlainText().rstrip()
            cap_bac = self.textEdit_5.toPlainText().rstrip()

            mycursor = mydb.cursor()

            mycursor.callproc("ThemNhanVien", [ma_nv, ten_nhan_vien, dia_chi, cap_bac, sdt, ])

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
        try:
            ma_nv = self.textEdit.toPlainText().rstrip()
            ten_nhan_vien = self.textEdit_2.toPlainText().rstrip()
            dia_chi = self.textEdit_3.toPlainText().rstrip()
            sdt = self.textEdit_4.toPlainText().rstrip()
            cap_bac = self.textEdit_5.toPlainText().rstrip()

            mycursor = mydb.cursor()

            mycursor.callproc("SuaNhanVien", [ma_nv, ten_nhan_vien, dia_chi, cap_bac, sdt, ])

            mydb.commit()

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
            ma_nv = self.textEdit.toPlainText().rstrip()

            mycursor = mydb.cursor()

            mycursor.callproc("XoaNhanVien", [ma_nv, ])

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
        try:
            ma_nv = self.textEdit.toPlainText().rstrip()
            ten_nhan_vien = self.textEdit_2.toPlainText().rstrip()
            dia_chi = self.textEdit_3.toPlainText().rstrip()
            sdt = self.textEdit_4.toPlainText().rstrip()
            cap_bac = self.textEdit_5.toPlainText().rstrip()

            mycursor = mydb.cursor()

            mycursor.callproc("TimKiemNhanVien", [ma_nv, ten_nhan_vien, dia_chi, cap_bac, sdt, ])

            myresult = mycursor.stored_results()

            self.tableWidget.setRowCount(0)

            for m in myresult:
                for x in m.fetchall():
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
        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()

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
