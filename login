using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.OleDb;

namespace sistemaoficial
{
    public partial class login : Form
    {
        public login()
        {
            InitializeComponent();
        }

        class conexao
        {
            public OleDbConnection cn = new OleDbConnection();
            public void conectar()
            {
                cn.ConnectionString = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=|DataDirectory|\bdsistemaoficial.mdb";
                cn.Open();
            }
        }

        void abreInicio()
        {
            inicio abreIncio = new inicio();
            this.Hide();
            abreIncio.Show();
        }

        void loginInval()
        {
            MessageBox.Show("Dados incorretos.", "Sistema Simple Solution", MessageBoxButtons.OK);
            abreInicio();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            abreInicio();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //verifica login do administrador que está definido no App.config na aba <appSettings>
            if (sistemaoficial.Program.auxAdm == 1)
            {
                var _userAdm = System.Configuration.ConfigurationManager.AppSettings["userAdm"].ToString();
                var _senhaAdm = System.Configuration.ConfigurationManager.AppSettings["senhaAdm"].ToString();

                if ((user.Text.Equals(_userAdm)) && (senha.Text.Equals(_senhaAdm)))
                {
                    this.Hide();
                    //MessageBox.Show("certo");
                    admMenu abreAdmMenu = new admMenu();
                    abreAdmMenu.Show();
                }
                else
                {
                    loginInval();
                }
            }
            sistemaoficial.Program.auxAdm = 0;

            //verifica o login do professor de acordo com o cadastro feito no bd
            if (sistemaoficial.Program.auxPro == 1)
            {
                string query = "SELECT * FROM professor WHERE userProfessor=@userProfessor AND senhaProfessor=@senhaProfessor";

                conexao conexao = new conexao();
                conexao.conectar();

                OleDbCommand cmd = new OleDbCommand(query, conexao.cn);

                cmd.Parameters.AddWithValue("@userProfessor", user.Text);
                cmd.Parameters.AddWithValue("@senhaProfessor", senha.Text);

                OleDbDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    this.Hide();
                    //MessageBox.Show("certo");
                    profMenu abreProfInicio = new profMenu();
                    abreProfInicio.Show();
                }

                else
                {
                    loginInval();
                }

            }

            sistemaoficial.Program.auxPro = 0;

            //verifica o login do aluno de acordo com o cadastro feito no bd
            if (sistemaoficial.Program.auxAlu == 1)
            {
                string query1 = "SELECT * FROM aluno WHERE userAluno=@userAluno AND senhaAluno=@senhaAluno";

                conexao conexao1 = new conexao();
                conexao1.conectar();

                OleDbCommand cmd1 = new OleDbCommand(query1, conexao1.cn);

                cmd1.Parameters.AddWithValue("@userAluno", user.Text);
                cmd1.Parameters.AddWithValue("@senhaAluno", senha.Text);

                OleDbDataReader dr1 = cmd1.ExecuteReader();

                if (dr1.Read())
                {
                    this.Hide();
                    //MessageBox.Show("certo");

                    sistemaoficial.Program.auxCodAluno = Convert.ToInt32((dr1["codAluno"].ToString()));

                    alunoMenu abreAlunoInicio = new alunoMenu();
                    abreAlunoInicio.Show();
                }

                else
                {
                    loginInval();
                    sistemaoficial.Program.auxCodAluno = 0;
                }
            }
            sistemaoficial.Program.auxAlu = 0;
        }
    }
}
