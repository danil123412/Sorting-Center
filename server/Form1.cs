using MaterialSkin;
using MaterialSkin.Controls;
using System;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Printing;
using System.Windows.Forms;
using ZXing;
using ZXing.Common;

namespace SortingCentre
{
    public partial class Form1 : MaterialForm
    {
        MaterialSkinManager materialSkinManager = MaterialSkinManager.Instance;
        public Form1()
        {
            materialSkinManager.AddFormToManage(this);
            InitializeComponent();
        }

        

        private void Form1_Load(object sender, EventArgs e)
        {

            
            // TODO: данная строка кода позволяет загрузить данные в таблицу "delivery1DataSet6.Пункт_выдачи_заказов". При необходимости она может быть перемещена или удалена.
            this.пункт_выдачи_заказовTableAdapter1.Fill(this.delivery1DataSet6.Пункт_выдачи_заказов);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "delivery1DataSet5.Тарифы". При необходимости она может быть перемещена или удалена.
            this.тарифыTableAdapter1.Fill(this.delivery1DataSet5.Тарифы);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "delivery1DataSet4.Тарифы". При необходимости она может быть перемещена или удалена.
            this.тарифыTableAdapter.Fill(this.delivery1DataSet4.Тарифы);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "delivery1DataSet3.Пункт_выдачи_заказов". При необходимости она может быть перемещена или удалена.
            this.пункт_выдачи_заказовTableAdapter.Fill(this.delivery1DataSet3.Пункт_выдачи_заказов);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "delivery1DataSet2.Получатель". При необходимости она может быть перемещена или удалена.
            this.получательTableAdapter.Fill(this.delivery1DataSet2.Получатель);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "delivery1DataSet1.Груз". При необходимости она может быть перемещена или удалена.
            this.грузTableAdapter.Fill(this.delivery1DataSet1.Груз);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "delivery1DataSet.Город". При необходимости она может быть перемещена или удалена.
            this.городTableAdapter.Fill(this.delivery1DataSet.Город);
            UpdateTableParameter();
            UpdateTable();
        }


        void UpdateTable()
        {
            deliveryView.Items.Clear();

            var reader = SQL.GetDelivery();

            while (reader.Read())
            {
                int id = reader.GetInt32(0);
                string city = reader.GetString(1);
                string adress = reader.GetString(2);
                string status = reader.GetString(3);
                DateTime issue = reader.GetDateTime(4);
                string operationDate = issue.ToShortDateString();
                DateTime iss = reader.GetDateTime(5);
                string operationTime = issue.ToShortTimeString();
                string cost = reader.GetDecimal(6).ToString();
                string surname = reader.GetString(7);
                string name = reader.GetString(8);
                string patronymic = reader.GetString(9);
                string cargo = reader.GetString(10);
                string tariff = reader.GetString(11);
                string pvz = reader.GetString(12);
                string sc = reader.GetString(13);

                var item = deliveryView.Items.Add(new ListViewItem(new String[] { id.ToString(), city,
                                                                adress, status, issue.ToShortDateString(), 
                    iss.ToShortTimeString(), cost, surname, name, patronymic, cargo, tariff, pvz, sc
                                                             }));
            }
            reader.Close();
        }

        void UpdateTableParameter()
        {
            parameterView.Items.Clear();

            var reader = SQL.TableParameter();

            while (reader.Read())
            {
                int line = reader.GetInt32(0);
                string parameter = reader.GetString(1);
            

                var item = parameterView.Items.Add(new ListViewItem(new String[] { (line +1).ToString(), parameter
                                                             }));
            }
            reader.Close();
        }




        

        private void addParametrForTheFirstLine_Click(object sender, EventArgs e)
        {

            try
            {
                if (SQL.addParametr((int)parametrForTheFirstLine.SelectedValue, 0))
                {
                    MessageBox.Show("Параметр успешно изменён");
                    UpdateTableParameter();
                }
            }
            catch (System.Data.SqlClient.SqlException)
            {
                MessageBox.Show("Ошибка");
            }
        }

        private void addParametrForSecondLine_Click(object sender, EventArgs e)
        {

            try
            {
                if (SQL.addParametr((int)parametrForTheFirstLine.SelectedValue, 1))
                {
                    MessageBox.Show("Параметр успешно изменён");
                    UpdateTableParameter();
                }
            }
            catch (System.Data.SqlClient.SqlException)
            {
                MessageBox.Show("Ошибка");
            }
        }

        private void addParametrForThirdLine_Click(object sender, EventArgs e)
        {

            try
            {
                if (SQL.addParametr((int)parametrForTheSecondLine.SelectedValue, 2))
                {
                    MessageBox.Show("Параметр успешно изменён");
                    UpdateTableParameter();
                }
            }
            catch (System.Data.SqlClient.SqlException)
            {
                MessageBox.Show("Ошибка");
            }
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            
            UpdateTable();
        }

        private void addDeliveryButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (SQL.addDelivery((int)cargoComboBox.SelectedValue, (int)cityComboBox.SelectedValue, 
                    adressTextBox.Text, priceTextBox.Text, (int)tarifComboBox.SelectedValue, (int)PVZComboBox.SelectedValue))
                {
                    MessageBox.Show("Добавлено");
                }
            }

        
        catch (System.Data.SqlClient.SqlException)
        {
            MessageBox.Show("Ошибка");
    }
        }

        private void generateButton_Click(object sender, EventArgs e)
        {
            var writer = new BarcodeWriter

            {
                Format = ZXing.BarcodeFormat.DATA_MATRIX,
                Options = new EncodingOptions
                {
                    Height = Int32.Parse(heightTextBox.Text),
                    Width = Int32.Parse(widthTextBox.Text)
                }
            };

            var bitmap = writer.Write(infoTextBox.Text);
            DataMatrixPictureBox.Image = bitmap;
            bitmap.Save("datamatrix.png", System.Drawing.Imaging.ImageFormat.Png);
        }

        private void printButton_Click(object sender, EventArgs e)
        {
            PrintDocument pd = new PrintDocument();
            pd.PrintPage += new PrintPageEventHandler(PrintImage);

            PrintDialog printDialog = new PrintDialog();
            if (printDialog.ShowDialog() == DialogResult.OK)
            {
                pd.PrinterSettings = printDialog.PrinterSettings;
                pd.Print();
            }
        }

        private void PrintImage(object o, PrintPageEventArgs e)
        {
            string imagePath = @"C:\Users\danil\Downloads\NetQRRecognizer-master (1)\NetQRRecognizer-master\WindowsFormsApp3\bin\Debug\datamatrix.png";
            Image image = Image.FromFile(imagePath);

            RectangleF bounds = e.PageSettings.PrintableArea;
            float widthRatio = bounds.Width / image.Width;
            float heightRatio = bounds.Height / image.Height;
            float ratio = Math.Min(widthRatio, heightRatio);

            int width = (int)(image.Width * ratio);
            int height = (int)(image.Height * ratio);

            Rectangle rect = new Rectangle((int)bounds.X, (int)bounds.Y, width, height);
            e.Graphics.DrawImage(image, rect);
        }

        private void adressTextBox_Validating(object sender, CancelEventArgs e)
        {
            
            var input = adressTextBox.Text;
            if (string.IsNullOrEmpty(input))
            {
                errorProvider1.SetError(adressTextBox, "Введите адрес!");
                e.Cancel = true;
            }
            else
            {
                errorProvider1.SetError(adressTextBox, String.Empty);
                e.Cancel = false;
            }
        }

        private void priceTextBox_Validating(object sender, CancelEventArgs e)
        {
            var input = priceTextBox.Text;
            if (string.IsNullOrEmpty(input))
            {
                errorProvider1.SetError(priceTextBox, "Введите стоимость!");
                e.Cancel = true;
            }
            else
            {
                errorProvider1.SetError(priceTextBox, String.Empty);
                e.Cancel = false;
            }
        }
    }
}
