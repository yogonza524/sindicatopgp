/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.beans;

import java.io.IOException;
import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import org.sindicato.business.UsuarioController;
import org.sindicato.entities.Usuario;
import org.sindicato.util.Email;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="index")
@RequestScoped
public class IndexBean {
    
    private String emailRecovery;
    private UsuarioController uc;
    
    @ManagedProperty(value="#{util}")
    private UtilBean util;

    @ManagedProperty(value="#{mail}")
    private MailBean mail;
    
    public String getEmailRecovery() {
        return emailRecovery;
    }

    public void setEmailRecovery(String emailRecovery) {
        this.emailRecovery = emailRecovery;
    }
    
    @PostConstruct
    public void init(){
        uc = new UsuarioController();
    }

    public UtilBean getUtil() {
        return util;
    }

    public void setUtil(UtilBean util) {
        this.util = util;
    }

    public MailBean getMail() {
        return mail;
    }

    public void setMail(MailBean mail) {
        this.mail = mail;
    }
    
    public void sendUsername() throws IOException{
        System.out.println("----------------------------");
        System.out.println("Email: " + emailRecovery);
        Usuario u = uc.byID("email", emailRecovery);
        if (u != null) {
            if (Email.send(emailRecovery, "RECUPERAR NOMBRE DE USUARIO", mail.materializeRecoveryUsername().replace("$username", u.getUsername()))) {
                emailRecovery = "";
                util.info("Enviado. Verifique su casilla", "Nombre de usuario enviado");
            }
            else{
                util.error("Envío fallido. Intentelo de nuevo", "Problema interno");
            }
        }
        else{
            util.error("No se encontró el email en el registro", "Error de busqueda");
        }
    }
    
    public void sendPassword() throws IOException{
        Usuario u = uc.byID("email", emailRecovery);
        if (u != null) {
            String password = uc.generatePassword(10);
            if (password != null) {
                u.setPassword(password);
                if (uc.updateUsuario(u)) {
                    if (Email.send(emailRecovery, "RECUPERAR CONTRASEÑA", mail.materializeCss().replace("$password",password))) {
                        emailRecovery = "";
                        util.info("Enviado. Verifique su casilla", "Nombre de usuario enviado");
                    }
                    else{
                        util.error("Envío fallido. Intentelo de nuevo", "Problema interno");
                    }
                }
                else{
                    util.error("Error al modificar la contraseña", "Error interno");
                }
            }
        }
        else{
            util.error("No se encontró el email en el registro", "Error de busqueda");
        }
    }
}
