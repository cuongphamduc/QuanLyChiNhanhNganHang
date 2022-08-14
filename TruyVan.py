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


class TinhLuong(QtWidgets.QDialog):
    def __init__(self):
        super(TinhLuong, self).__init__()
        uic.loadUi('UI/TinhLuong.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_process_button)

        self.show()

    def on_click_process_button(self):
        ma_nv = self.textEdit.toPlainText().rstrip()
        thang = self.comboBox.currentText().rstrip()

        mycursor = mydb.cursor()

        luong = None

        res = mycursor.callproc("TinhLuong", [ma_nv, thang, luong, ])

        mycursor.close()

        self.textEdit_2.setPlainText(str(res[2]))


class LietKeTinDung(QtWidgets.QDialog):
    def __init__(self):
        super(LietKeTinDung, self).__init__()
        uic.loadUi('UI/LietKeTinDung.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        self.pushButton.clicked.connect(self.on_click_process_button)

        self.show()

    def on_click_process_button(self):
        try:
            start_date = self.dateEdit.date()
            start_date = start_date.toPyDate()

            end_date = self.dateEdit_2.date()
            end_date = end_date.toPyDate()

            mycursor = mydb.cursor()

            mycursor.callproc("LietKeTinDung", [start_date.strftime("%Y-%m-%d"), end_date.strftime("%Y-%m-%d"), ])

            myresult = mycursor.stored_results()

            self.tableWidget.setRowCount(0)

            for m in myresult:
                for x in m.fetchall():
                    rowPosition = self.tableWidget.rowCount()
                    self.tableWidget.insertRow(rowPosition)

                    self.tableWidget.setItem(rowPosition, 0, QtWidgets.QTableWidgetItem(str(x[0])))
                    self.tableWidget.setItem(rowPosition, 1, QtWidgets.QTableWidgetItem(str(x[1])))

                    self.tableWidget.item(rowPosition, 0).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
                    self.tableWidget.item(rowPosition, 1).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()


class LietKeNoTinDung(QtWidgets.QDialog):
    def __init__(self):
        super(LietKeNoTinDung, self).__init__()
        uic.loadUi('UI/LietKeNoTinDung.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        try:
            mycursor = mydb.cursor()

            mycursor.callproc("LietKeNoTinDung", [])

            myresult = mycursor.stored_results()

            self.tableWidget.setRowCount(0)

            for m in myresult:
                for x in m.fetchall():
                    rowPosition = self.tableWidget.rowCount()
                    self.tableWidget.insertRow(rowPosition)

                    self.tableWidget.setItem(rowPosition, 0, QtWidgets.QTableWidgetItem(str(x[0])))
                    self.tableWidget.setItem(rowPosition, 1, QtWidgets.QTableWidgetItem(str(x[1])))

                    self.tableWidget.item(rowPosition, 0).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
                    self.tableWidget.item(rowPosition, 1).setTextAlignment(
                        QtCore.Qt.AlignRight | QtCore.Qt.AlignVCenter)
        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()

        self.show()


class LietKeTongTienGui(QtWidgets.QDialog):
    def __init__(self):
        super(LietKeTongTienGui, self).__init__()
        uic.loadUi('UI/LietKeTongTienGui.ui', self)
        self.setWindowFlag(QtCore.Qt.WindowMinimizeButtonHint, True)
        self.setWindowIcon(QtGui.QIcon('icon.jpg'))

        try:
            mycursor = mydb.cursor()

            mycursor.callproc("LietKeTienGui", [])

            myresult = mycursor.stored_results()

            self.tableWidget.setRowCount(0)

            for m in myresult:
                for x in m.fetchall():
                    if x[0] is None or x[0] == "":
                        continue
                        
                    rowPosition = self.tableWidget.rowCount()
                    self.tableWidget.insertRow(rowPosition)

                    self.tableWidget.setItem(rowPosition, 0, QtWidgets.QTableWidgetItem(str(x[0])))
                    self.tableWidget.setItem(rowPosition, 1, QtWidgets.QTableWidgetItem(str(x[1])))
                    self.tableWidget.setItem(rowPosition, 2, QtWidgets.QTableWidgetItem(str(x[2])))
                    self.tableWidget.setItem(rowPosition, 3, QtWidgets.QTableWidgetItem(str(x[3])))
                    self.tableWidget.setItem(rowPosition, 4, QtWidgets.QTableWidgetItem(str(x[4])))

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

        except Error as e:
            msg = QtWidgets.QMessageBox()
            msg.setWindowTitle("Lỗi")
            msg.setText(e.msg)
            msg.exec_()

        self.show()
