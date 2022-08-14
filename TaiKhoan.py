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


class ThemTaiKhoan(QtWidgets.QDialog):
    def __init__(self):
        super(ThemTaiKhoan, self).__init__()
        uic.loadUi('UI/ThemTaiKhoan.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_save_button)
        self.pushButton_2.clicked.connect(self.on_click_cancel_button)
        self.comboBox.currentTextChanged.connect(self.on_combobox_changed)
        self.comboBox_2.currentTextChanged.connect(self.on_combobox_changed2)

        mycursor = mydb.cursor()

        res = mycursor.callproc("TaoMaTK", [0, ])

        mycursor.close()

        self.textEdit.setPlainText(str(res[0]))

        self.textEdit_3.setDisabled(False)
        self.textEdit_6.setDisabled(False)
        self.textEdit_4.setDisabled(True)
        self.textEdit_5.setDisabled(True)

        self.textEdit_4.clear()
        self.textEdit_5.clear()

        self.show()

    def on_combobox_changed(self, value):
        if value == "Khách hàng cá nhân":
            self.comboBox_2.clear()
            self.comboBox_2.addItem("Tài khoản tín dụng")
            self.comboBox_2.addItem("Tài khoản gửi tiền")

            self.comboBox_2.setCurrentText("Tài khoản tín dụng")
        else:
            self.comboBox_2.clear()
            self.comboBox_2.addItem("Tài khoản gửi tiền")
            self.comboBox_2.addItem("Tài khoản vay tiền")

            self.comboBox_2.setCurrentText("Tài khoản gửi tiền")

        self.textEdit_3.clear()
        self.textEdit_4.clear()
        self.textEdit_5.clear()
        self.textEdit_6.clear()

    def on_combobox_changed2(self, value):
        if value == "Tài khoản tín dụng":
            self.textEdit_3.setDisabled(False)
            self.textEdit_6.setDisabled(False)
            self.textEdit_4.setDisabled(True)
            self.textEdit_5.setDisabled(True)

            self.textEdit_4.clear()
            self.textEdit_5.clear()

        if value == "Tài khoản gửi tiền":
            self.textEdit_4.setDisabled(False)
            self.textEdit_5.setDisabled(False)
            self.textEdit_3.setDisabled(True)
            self.textEdit_6.setDisabled(True)

            self.textEdit_3.clear()
            self.textEdit_6.clear()

        if value == "Tài khoản vay tiền":
            self.textEdit_4.setDisabled(False)
            self.textEdit_6.setDisabled(False)
            self.textEdit_3.setDisabled(True)
            self.textEdit_5.setDisabled(True)

            self.textEdit_3.clear()
            self.textEdit_5.clear()

    def on_click_save_button(self):
        try:
            ma_tk = self.textEdit.toPlainText().rstrip()
            hang_tk = self.textEdit_2.toPlainText().rstrip()
            han_muc = self.textEdit_3.toPlainText().rstrip()
            lai_suat = self.textEdit_4.toPlainText().rstrip()
            so_du = self.textEdit_5.toPlainText().rstrip()
            so_no = self.textEdit_6.toPlainText().rstrip()
            ma_kh = self.textEdit_7.toPlainText().rstrip()
            ma_nv = self.textEdit_8.toPlainText().rstrip()

            if self.comboBox_2.currentText() == "Tài khoản tín dụng":
                mycursor = mydb.cursor()

                mycursor.callproc("ThemTaiKhoanTinDung", [ma_kh, ma_nv, ma_tk, hang_tk, han_muc, so_no, ])

                mydb.commit()
                mycursor.close()

            if self.comboBox_2.currentText() == "Tài khoản vay tiền":
                mycursor = mydb.cursor()

                mycursor.callproc("ThemTaiKhoanVayTien", [ma_kh, ma_nv, ma_tk, hang_tk, lai_suat, so_no, ])

                mydb.commit()
                mycursor.close()

            if self.comboBox_2.currentText() == "Tài khoản gửi tiền":
                if self.comboBox.currentText() == "Khách hàng cá nhân":
                    mycursor = mydb.cursor()

                    mycursor.callproc("ThemTaiKhoanGuiTienCaNhan", [ma_kh, ma_nv, ma_tk, hang_tk, so_du, lai_suat, ])

                    mydb.commit()
                    mycursor.close()
                else:
                    mycursor = mydb.cursor()

                    mycursor.callproc("ThemTaiKhoanGuiTienToChucDoanhNghiep",
                                      [ma_kh, ma_nv, ma_tk, hang_tk, so_du, lai_suat, ])

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


class TimKiemTaiKhoan(QtWidgets.QDialog):
    def __init__(self):
        super(TimKiemTaiKhoan, self).__init__()
        uic.loadUi('UI/TimKiemTaiKhoan.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_search_button)
        self.tableWidget.clicked.connect(self.on_click_table)
        self.comboBox.currentTextChanged.connect(self.on_combobox_changed)
        self.comboBox_2.currentTextChanged.connect(self.on_combobox_changed2)

        self.show()

    def on_combobox_changed(self, value):
        if value == "Khách hàng cá nhân":
            self.comboBox_2.clear()
            self.comboBox_2.addItem("Tài khoản tín dụng")
            self.comboBox_2.addItem("Tài khoản gửi tiền")

            self.comboBox_2.setCurrentText("Tài khoản tín dụng")
        else:
            self.comboBox_2.clear()
            self.comboBox_2.addItem("Tài khoản gửi tiền")
            self.comboBox_2.addItem("Tài khoản vay tiền")

            self.comboBox_2.setCurrentText("Tài khoản gửi tiền")

        self.textEdit_3.clear()
        self.textEdit_4.clear()
        self.textEdit_5.clear()
        self.textEdit_6.clear()
        self.on_click_search_button()

    def on_combobox_changed2(self, value):
        if value == "Tài khoản tín dụng":
            self.textEdit_3.setDisabled(False)
            self.textEdit_6.setDisabled(False)
            self.textEdit_4.setDisabled(True)
            self.textEdit_5.setDisabled(True)

            self.textEdit_4.clear()
            self.textEdit_5.clear()

        if value == "Tài khoản gửi tiền":
            self.textEdit_4.setDisabled(True)
            self.textEdit_5.setDisabled(True)
            self.textEdit_3.setDisabled(False)
            self.textEdit_6.setDisabled(False)

            self.textEdit_3.clear()
            self.textEdit_6.clear()

        if value == "Tài khoản vay tiền":
            self.textEdit_4.setDisabled(True)
            self.textEdit_6.setDisabled(True)
            self.textEdit_3.setDisabled(False)
            self.textEdit_5.setDisabled(False)

            self.textEdit_3.clear()
            self.textEdit_5.clear()

        self.on_click_search_button()

