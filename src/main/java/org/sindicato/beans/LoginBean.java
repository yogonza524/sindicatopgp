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
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import org.sindicato.business.UsuarioController;
import org.sindicato.entities.Usuario;
import org.sindicato.enums.Pages;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="login")
@ViewScoped
public class LoginBean {
    
    private String username;
    private String password;
    @ManagedProperty(value="#{util}")
    private UtilBean util;

    public UtilBean getUtil() {
        return util;
    }

    public void setUtil(UtilBean util) {
        this.util = util;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    @PostConstruct
    public void init(){
        
    }
    
    public void login() throws IOException{
        UsuarioController uc = new UsuarioController();
        Usuario u = uc.login(username, password);
        if (u != null) {
            FacesContext facecontext = FacesContext.getCurrentInstance();
            HttpServletRequest context = util.context();
            context.getSession().setAttribute("user", u);
            if (uc.isAdmin(u)) {
                facecontext.getExternalContext().redirect(Pages.ADMIN_HOME.toString());
            }
            else{
                if (uc.isUser(u)) {
                    facecontext.getExternalContext().redirect(Pages.USER_HOME.toString());
                }
            }
        }
        else{
            util.error("Error de acceso", "Hubo un error al ingresar. Contactese con administración");
        }
    }
    
    public void logout() throws IOException{
        FacesContext facecontext = FacesContext.getCurrentInstance();
        HttpServletRequest context = util.context();
        Usuario u = (Usuario)context.getSession().getAttribute("user");
        if (u != null) {
            context.getSession().setAttribute("user", null);
        }
        context.getSession().invalidate();
        facecontext.getExternalContext().redirect(Pages.USER_HOME.toString());
    }
    
    public Usuario getLoggedUser(){
        FacesContext facecontext = FacesContext.getCurrentInstance();
        HttpServletRequest context = util.context();
        return (Usuario)context.getSession().getAttribute("user");
    }
}
