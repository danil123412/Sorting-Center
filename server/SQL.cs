using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SortingCentre
{
    public class SQL
    {
        static SqlConnection conn = new SqlConnection();
        static string conHome = ConfigurationManager.ConnectionStrings["SortingCentre.Properties.Settings.Delivery1ConnectionString"].ConnectionString;
        static SqlCommand addParametrCmd;
        static SqlCommand statusUpdateCmd;
        static SqlCommand updateSortingCmd;
        static SqlCommand gettingTheSortingParametersCmd;
        static SqlCommand getLineByIDCmd;
        static SqlCommand addDataTimeCmd;
        static SqlCommand addDeliveryCmd;


        static SQL()
        {
            createNonQueries();
        }

        public static void createNonQueries()
        {
            conn.ConnectionString = conHome;
            conn.Open();
        }

        public static bool addParametr(int parametr, int line)
        {
            
            addParametrCmd = conn.CreateCommand();
            addParametrCmd.CommandType = CommandType.StoredProcedure;
            addParametrCmd.CommandText = "addParametr";

            addParametrCmd.Parameters.Clear();
            addParametrCmd.Parameters.AddWithValue("@line", line);
            addParametrCmd.Parameters.AddWithValue("@parametr", parametr);
        return  
            addParametrCmd.ExecuteNonQuery() != 0;
        }

        public static bool addDataTime(int id, DateTime optionDate, DateTime optionTime)
        {
                
            addDataTimeCmd = conn.CreateCommand();
            addDataTimeCmd.CommandType = CommandType.StoredProcedure;
            addDataTimeCmd.CommandText = "addDataTime";

            addDataTimeCmd.Parameters.Clear();
            addDataTimeCmd.Parameters.AddWithValue("@id", id);
            addDataTimeCmd.Parameters.AddWithValue("@optionDate", optionDate);
            addDataTimeCmd.Parameters.AddWithValue("@optionTime", optionTime);

            return
                addDataTimeCmd.ExecuteNonQuery() != 0;
        }

        public static bool addDelivery(int cargo, int city, string adress, 
            string price, int tariff,  int pvz)
        {

            addDeliveryCmd = conn.CreateCommand();
            addDeliveryCmd.CommandType = CommandType.StoredProcedure;
            addDeliveryCmd.CommandText = "addDelivery";

            addDeliveryCmd.Parameters.Clear();
            
            addDeliveryCmd.Parameters.AddWithValue("@cargo", cargo);
            
            addDeliveryCmd.Parameters.AddWithValue("@city", city);
            addDeliveryCmd.Parameters.AddWithValue("@adress", adress);
            
            
            addDeliveryCmd.Parameters.AddWithValue("@price", price);
            addDeliveryCmd.Parameters.AddWithValue("@tariff", tariff);
            
            addDeliveryCmd.Parameters.AddWithValue("@pvz", pvz);

            return
                addDeliveryCmd.ExecuteNonQuery() != 0;
        }

        public static bool statusUpdate(int id)
        {

            statusUpdateCmd = conn.CreateCommand();
            statusUpdateCmd.CommandType = CommandType.StoredProcedure;
            statusUpdateCmd.CommandText = "updateStatus";

            statusUpdateCmd.Parameters.Clear();
            statusUpdateCmd.Parameters.AddWithValue("@id", id);
            return
                statusUpdateCmd.ExecuteNonQuery() != 0;
        }

        public static bool updateSortingCentre(int id, int centre)
        {

            updateSortingCmd = conn.CreateCommand();
            updateSortingCmd.CommandType = CommandType.StoredProcedure;
            updateSortingCmd.CommandText = "updateSortingCentre";

            updateSortingCmd.Parameters.Clear();
            updateSortingCmd.Parameters.AddWithValue("@id", id);
            updateSortingCmd.Parameters.AddWithValue("@sort", centre);
            return
                updateSortingCmd.ExecuteNonQuery() != 0;
        }

        public static bool gettingTheSortingParameters(int id, int status)
        {
            gettingTheSortingParametersCmd = conn.CreateCommand();
            gettingTheSortingParametersCmd.CommandType = CommandType.StoredProcedure;
            gettingTheSortingParametersCmd.CommandText = "updateStatus";

            gettingTheSortingParametersCmd.Parameters.Clear();
            gettingTheSortingParametersCmd.Parameters.AddWithValue("@id", id);
            gettingTheSortingParametersCmd.Parameters.AddWithValue("@status", status);
            return
                gettingTheSortingParametersCmd.ExecuteNonQuery() != 0;
        }

        public static int getLineByID(int id)
        {
            getLineByIDCmd = conn.CreateCommand();
            getLineByIDCmd.CommandType = CommandType.Text;
            getLineByIDCmd.CommandText = @"SELECT Линия
                                            FROM Доставка JOIN[Параметры для сортировки] ON Доставка.Город = [Параметры для сортировки].Параметр
                                            WHERE[ID доставки] = @id";

            getLineByIDCmd.Parameters.Clear();
            getLineByIDCmd.Parameters.AddWithValue("@id", id);
            var reader = getLineByIDCmd.ExecuteReader();
            reader.Read();
            var res = reader.IsDBNull(0) ? -1 :
                reader.GetInt32(0);
            reader.Close();
            return res;
        }
        public static SqlDataReader GetDelivery()
        {
            SqlCommand repair = conn.CreateCommand();
            repair.CommandText = "SELECT Доставка.[ID доставки], Город.[Наименование города], Доставка.Адрес, [Статус доставки].[Наименование статуса], Доставка.Дата, Доставка.Время, Доставка.Стоимость, Получатель.Фамилия, Получатель.Имя, Получатель.Отчество, Груз.[Наименование груза], Тарифы.[Наименование тарифа], [Пункт выдачи заказов].[Наименование ПВЗ], [Сортировочный центр].[Наименование СЦ] " +
                        "FROM Доставка INNER JOIN " +
                        "Получатель ON Доставка.Получатель = Получатель.[ID получателя] INNER JOIN " +
                        "Тарифы ON Доставка.Тариф = Тарифы.[ID тарифа] INNER JOIN " +
                        "[Пункт выдачи заказов] ON Доставка.ПВЗ = [Пункт выдачи заказов].[ID ПВЗ] INNER JOIN " +
                        "Груз ON Груз.[ID груза] = Доставка.Груз " +
                        "INNER JOIN Город ON Город.[ID города] = Доставка.Город INNER JOIN[Статус доставки] ON [Статус доставки].[ID статуса] = Доставка.Статус INNER JOIN  [Сортировочный центр] ON Доставка.СЦ = [Сортировочный центр].[ID СЦ]";

            return repair.ExecuteReader();
        }

        public static SqlDataReader TableParameter()
        {
            SqlCommand repair = conn.CreateCommand();
            repair.CommandText = "SELECT Линия, Город.[Наименование города] FROM[Параметры для сортировки] INNER JOIN Город ON Город.[ID города] = [Параметры для сортировки].Параметр";

            return repair.ExecuteReader();
        }
    }
}
