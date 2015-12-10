/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.beans;

import java.io.IOException;
import java.util.Date;
import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import org.sindicato.business.EmpresaController;
import org.sindicato.business.UsuarioController;
import org.sindicato.entities.Empresa;
import org.sindicato.entities.Usuario;
import org.sindicato.enums.Pages;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="register")
@RequestScoped
public class RegisterBean {
    
    private Usuario user;
    @ManagedProperty(value="#{util}")
    private UtilBean util;
    private String repass;
    private UsuarioController uc;
    private EmpresaController ec;
    private Empresa emp;

    public String getRepass() {
        return repass;
    }

    public void setRepass(String repass) {
        this.repass = repass;
    }

    public UtilBean getUtil() {
        return util;
    }

    public void setUtil(UtilBean util) {
        this.util = util;
    }

    public Usuario getUser() {
        return user;
    }

    public void setUser(Usuario user) {
        this.user = user;
    }

    public Empresa getEmp() {
        return emp;
    }

    public void setEmp(Empresa emp) {
        this.emp = emp;
    }
    
    @PostConstruct
    public void init(){
        user = new Usuario();
        uc = new UsuarioController();
        ec = new EmpresaController(Empresa.class);
        emp = new Empresa();
    }
    
    public void execute(){
        if (user.getPassword().equals(repass)) {
            if (!uc.existEmail(user.getEmail())) {
                if (!uc.existUsername(user.getUsername())) {
                    if (uc.add(user)) {
                        util.info("Registro exitoso", "Completado");
                    }
                    else{
                        util.error("Error. Intentelo de nuevo mas tarde", "Error interno al agregar");
                    }
                }
                else{
                    util.error("El nombre de usuario ya fue ocupado, seleccione otro", "Error de mail");
                }
            }
            else{
                util.error("El email ya fue ocupado, seleccione otro", "Error de mail");
            }
        }
        else{
            util.error("Las contraseñas no coinciden", "Verifique las contraseñas");
        }
    }
    
    //Registra la empresa del usuario común
    public void executeEmpresa() throws IOException{
        if (loggedUser() != null) {
            emp.setUsuario(loggedUser());
        }
        else{
            util.error("No se encontró un usuario conectado", "Error interno");
        }
        if (ec.add(emp)) {
            util.info("Empresa generada", "Se guardaran los cambios");
            Usuario logged = this.loggedUser();
            logged.setEmpresa(emp);
            putLoggedUser(logged);
            FacesContext faceContext = FacesContext.getCurrentInstance();
            faceContext.getExternalContext().redirect("../../index.xhtml");
        }
        else{
            util.error("Hubo un error. Intentelo mas tarde", "Error interno al guardar la empresa");
        }
    }
    
    private Usuario loggedUser(){
        HttpServletRequest context = util.context();
        return (Usuario)context.getSession().getAttribute("user");
    }
    
    private void putLoggedUser(Usuario u){
        HttpServletRequest context = util.context();
        context.getSession().setAttribute("user",u);
    }
}
