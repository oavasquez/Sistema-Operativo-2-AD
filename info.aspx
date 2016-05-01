<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="info.aspx.cs" Inherits="Proyecto_SO.info" %>
<%@ Import Namespace="Proyecto_SO" %>


<html xmlns="http://www.w3.org/1999/xhtml">

<head> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Sevidor vasquez.com</title> 
    <link href='https://fonts.googleapis.com/css?family=Pinyon+Script' rel='stylesheet' type='text/css'>
		
    <style type="text/css">
		*{
		   margin:0px;
		   padding:0px;
		}
		body{
		   background:url(fondo.jpg) #2b2b2a;
		}
		form{
		   background:#CB0C49;
		   width:800px;
		   border:1px solid #4e4d4d;
		   border-radius:3px;
		   -moz-border-radius:3px;
		   -webkit-border-radius:3px;
		   box-shadow:inset 0 0 10px #000;
		   margin:100px auto;
		}
		form h4{
		   text-aling:center;
		   color:#FFFFFF;
		   font-weight:normal;
		   font-size:40pt;
		   margin:30px 0px;
	           font-family: 'Pinyon Script', cursive;
		}
		form input{
		   width: 280px;
		   height:35px;
		   padding:0px 10px;
		   color:#6d6d6d;
		   text-aling:center;

		}
		form button{
		   width:135px;
		   margin:20px 0px 30px 30px;
		   height:50px;
		}
		caja_superior{
		   width: 280px;
		   height:35px;
		   padding:0px 10px;
		   color:#6d6d6d;
		   text-aling:center;

		}
		div.a {
   		text-aling:center;
		} 

		</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" bgcolor="#E6E6E6" >
		
 		<form id="info" method="post" runat="server">
    
		
			
			<h4>&nbsp&nbsp&nbsp&nbsp&nbsp Informacion de Usuario</h4>
		

        <div id="caja_centro">
		 <br>
				<div id="caja_info">
                   
				 <br>
					<table width="90%" id="user">
						<tr>
							<td width="20%" rowspan="4">
                               
                                 <asp:Dropdownlist id ="ddlUsuarios" runat="server" Height="20px" Width="179px" CssClass="ddl" OnSelectedIndexChanged="llenarDdl" ></asp:Dropdownlist>  
							</td>
							<th width="40%" colspan="2">Datos Generales</th>
							<th width="40%">Miembro de </th>
						</tr>
						<tr>
							<td width="10%">Nombre:</td>
							<td width="20%"><asp:Label ID="lblName" Runat="server" /></td>
							<td width="40%" rowspan="3"><asp:ListBox ID="listaGrupos"  Width="95%" height="100%" runat="server" CssClass="myListBox"></asp:ListBox>
							</td>
						</tr>
						<tr>
							<td width="10%">Apellido</td>
							<td width="20%"><asp:Label ID="lblApellido" Runat="server" /></td>
						</tr>
						<tr>
							<td width="10%">Usuario</td>
							<td width="20%"><asp:Label ID="lblUsuario" Runat="server" /></td>
						</tr>
					</table>
                   
				</div>

            <div id= "caja_opciones">
                <center>
                      	<h5>Opciones de usuario</h5>
			<asp:Label ID="errorLabel" Runat="server"></asp:Label><br>
			<asp:Button id="btnPass" Text="Cambiar Contraseña" runat="server" OnClick="Cambiar_Cotraseña" Height="40px" Width="154px" /><br>
			<asp:Label id="lblActualPass"  Runat="server" ><h7>Ingrese contraseña actual:</h7></asp:Label> 
			<asp:TextBox ID="txtActualPass" Runat="server" TextMode="Password" width="80%"></asp:TextBox><br>
			<asp:Label id="lblNuevaPass"  Runat="server"  ><h7>Ingrese nueva contraseña: </h7></asp:Label> 
			<asp:TextBox ID="txtNewPass" Runat="server" TextMode="Password" width="80%"></asp:TextBox><br>
			<asp:Label id="lblConfirmPass"  Runat="server" ><h7>Ingrese contraseña actual:</h7></asp:Label> <br>
			<asp:TextBox ID="txtConfirmPass" Runat="server" TextMode="Password"  width="80%"></asp:TextBox>
			<asp:Button id="btnConfirm" Text="Guardar Contraseña" runat="server" OnClick="Guardar_Cotraseña" cssClass="button" /><br>                                            
                </center>
            </div>

 </form>
		
</div>
<div class="a">
					<p> vasquez.com | <a href="inicio.aspx">Salir</a></p>
				</div>	
			
</body>
</html>

<script runat="server">

    void Page_Load(Object origen, EventArgs args)
    {
        login((string)Session["user"], (string)Session["pass"]);


        errorLabel.Text = "";
        lblActualPass.Visible = false;
        txtActualPass.Visible = false;
        lblNuevaPass.Visible = false;
        txtNewPass.Visible = false;
        lblConfirmPass.Visible = false;
        txtConfirmPass.Visible = false;
        btnConfirm.Visible = false;
    }

    void login(string nom, string pass)
    {
        string adPath = "LDAP://" + Session["dominio"];
        LDAPAutenticador aut = new LDAPAutenticador(adPath);
        ArrayList gruposDe = new ArrayList();
        ArrayList propUsuarios = new ArrayList();

        try
        {
            if (aut.autenticado((string)Session["dominio"], (string)Session["user"], (string)Session["pass"]) == true)
            {
                lblUsuario.Text = aut.getCN();

                propUsuarios = aut.getListaPropiedades();
                ddlUsuarios.Items.Clear();
                ddlUsuarios.Items.Add(new ListItem(propUsuarios[0] as string));

                if(propUsuarios.Count >1)
                {
                    lblName.Text = propUsuarios[1] as string;
                    lblApellido.Text = propUsuarios[2] as string;
                    lblUsuario.Text = propUsuarios[0] as string;
                }

                llenarGrupos(lblUsuario.Text);

                //gruposDe = aut.GetGroups();
                //listaGrupos.Items.Clear();
                //for (int i = 0; i < gruposDe.Count; i++)
                //{
                //    listaGrupos.Items.Add(new ListItem(gruposDe[i] as string));
                //    if (gruposDe[i] as string == "Administrators")
                //    {
                //        Response.Write("Bienvenido administrador");
                //    }
                //}
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "error",    "alert('" + ex.ToString() + "');", true);
            Response.Redirect("inicio.aspx");
        }

    }

    void Cambiar_Cotraseña(Object origen, EventArgs args)
    {

        lblActualPass.Visible = true;
        txtActualPass.Visible = true;
        lblNuevaPass.Visible = true;
        txtNewPass.Visible = true;
        lblConfirmPass.Visible = true;
        txtConfirmPass.Visible = true;
        btnConfirm.Visible = true;
    }

    void llenarDdl(Object origen, EventArgs args)
    {
        //llenarGrupos(ddlUsuarios.SelectedItem.Value);
        Response.Write(ddlUsuarios.SelectedItem.Value);
    }

    void llenarGrupos(string cn)
    {
        string adPath = "LDAP://" + Session["dominio"];
        LDAPAutenticador aut = new LDAPAutenticador(adPath);
        ArrayList gruposDe = new ArrayList();
        ArrayList todosLosUsuarios = new ArrayList();
        gruposDe = aut.GetGroups(cn);
        listaGrupos.Items.Clear();
        for (int i = 0; i < gruposDe.Count; i++)
        {
            listaGrupos.Items.Add(new ListItem(gruposDe[i] as string));
            if(gruposDe[i] as string == "administrators")
            {
                Response.Write("Bienvenido administrador");
                //llamar todos los usuarios y agregarlos al ddl
                todosLosUsuarios = aut.getTodosUsuarios();
                for(int e =0; e<todosLosUsuarios.Count; e++)
                {
                    ddlUsuarios.Items.Add(new ListItem(todosLosUsuarios[e] as string));
                }
            }
        }
    }

    void Guardar_Cotraseña(Object origen, EventArgs args)
    {
        if (txtNewPass.Text == txtConfirmPass.Text)
        {
            string adPath = "LDAP://" + Session["dominio"];
            LDAPAutenticador aut = new LDAPAutenticador(adPath);

            Response.Write(aut.modificaPass(txtConfirmPass.Text, (string)Session["user"], txtActualPass.Text));

            errorLabel.Text = "";
            lblActualPass.Visible = false;
            txtActualPass.Visible = false;
            lblNuevaPass.Visible = false;
            txtNewPass.Visible = false;
            lblConfirmPass.Visible = false;
            txtConfirmPass.Visible = false;
            btnConfirm.Visible = false;
        }
        else
        {
            errorLabel.Text = "Contraseñas no coinciden";
        }
    }


</script>
