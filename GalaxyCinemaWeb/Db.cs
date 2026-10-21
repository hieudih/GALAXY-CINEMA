using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace GalaxyCinemaWeb
{
    public static class Db
    {
        public static SqlConnection Open()
        {
            var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["GalaxyCinema"].ConnectionString);
            cn.Open();
            return cn;
        }

        public static DataTable Query(string sql, params object[] p)
        {
            using (var cn = Open())
            using (var cmd = new SqlCommand(sql, cn))
            {
                AddParams(cmd, p);
                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);
                return dt;
            }
        }

        public static object Scalar(string sql, params object[] p)
        {
            using (var cn = Open())
            using (var cmd = new SqlCommand(sql, cn))
            {
                AddParams(cmd, p);
                return cmd.ExecuteScalar();
            }
        }

        public static int Execute(string sql, params object[] p)
        {
            using (var cn = Open())
            using (var cmd = new SqlCommand(sql, cn))
            {
                AddParams(cmd, p);
                return cmd.ExecuteNonQuery();
            }
        }

        public static SqlCommand Cmd(SqlConnection cn, SqlTransaction tr, string sql, params object[] p)
        {
            var cmd = new SqlCommand(sql, cn, tr);
            AddParams(cmd, p);
            return cmd;
        }

        public static DataTable Query(SqlConnection cn, SqlTransaction tr, string sql, params object[] p)
        {
            var dt = new DataTable();
            new SqlDataAdapter(Cmd(cn, tr, sql, p)).Fill(dt);
            return dt;
        }

        public static void AddParams(SqlCommand cmd, object[] p)
        {
            for (int i = 0; i + 1 < p.Length; i += 2)
                cmd.Parameters.AddWithValue((string)p[i], p[i + 1] ?? DBNull.Value);
        }

        public static string NextId(SqlConnection cn, SqlTransaction tr, string prefix, string table, string column, int width = 3)
        {
            string sql = "SELECT ISNULL(MAX(TRY_CAST(SUBSTRING(" + column + ", " + (prefix.Length + 1) + ", 10) AS INT)), 0) "
                       + "FROM " + table + " WITH (UPDLOCK, HOLDLOCK) WHERE " + column + " LIKE @p";
            int n = Convert.ToInt32(Cmd(cn, tr, sql, "@p", prefix + "%").ExecuteScalar());
            return prefix + (n + 1).ToString("D" + width);
        }

        public static string LoaiNgay(DateTime ngay)
        {
            return (ngay.DayOfWeek == DayOfWeek.Saturday || ngay.DayOfWeek == DayOfWeek.Sunday) ? "Cuối tuần" : "Ngày thường";
        }

        public static DateTime? DocNgay(string s)
        {
            DateTime d;
            return DateTime.TryParseExact((s ?? "").Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out d) ? d : (DateTime?)null;
        }

        public static TimeSpan? DocGio(string s)
        {
            TimeSpan t;
            return TimeSpan.TryParseExact((s ?? "").Trim(), @"hh\:mm", CultureInfo.InvariantCulture, out t) ? t : (TimeSpan?)null;
        }

        public static void HuyDonQuaHan()
        {
            using (var cn = Open())
            using (var tr = cn.BeginTransaction())
            {
                const string dk = "TrangThaiDon = N'Chờ thanh toán' AND NgayDat < DATEADD(MINUTE, -8, GETDATE())";
                Cmd(cn, tr, "UPDATE tblVe SET TrangThaiVe = N'Đã hủy' WHERE MaDon IN (SELECT MaDon FROM tblDonDatVe WHERE " + dk + ")").ExecuteNonQuery();
                Cmd(cn, tr, "UPDATE tblDonDatVe SET TrangThaiDon = N'Đã hủy' WHERE " + dk).ExecuteNonQuery();
                tr.Commit();
            }
        }
    }
}
