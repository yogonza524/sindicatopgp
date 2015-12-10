/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.beans;

import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;
import org.sindicato.business.MensajesController;
import org.sindicato.entities.Mensaje;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="contact")
@RequestScoped
public class ContactBean {
    
    private String nombre;
    private String email;
    private String content;
    private MensajesController mc;
    
    @ManagedProperty(value="#{util}")
    private UtilBean util;

    public UtilBean getUtil() {
        return util;
    }

    public void setUtil(UtilBean util) {
        this.util = util;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
    
    @PostConstruct
    public void init(){
        mc = new MensajesController(Mensaje.class);
    }
    
    public void send(){
        if (mc.addMensaje(nombre, email, content)) {
            initValues();
            util.info("Enviado", "Le contestaremos a la brevedar");
        }
        else{
            util.error("Error de envío", "No se envió el mensaje. Intentelo de nuevo mas tarde");
        }
    }
    
    private void initValues(){
        nombre = "";
        email = "";
        content = "";
    }
}
