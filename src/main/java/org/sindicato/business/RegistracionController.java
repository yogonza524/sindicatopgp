/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import org.sindicato.controllers.Controller;
import org.sindicato.entities.Registracion;
import org.sindicato.enums.Order;

/**
 *
 * @author Gonza
 */
public class RegistracionController extends AbstractBusinessController<Registracion> {
    
    public RegistracionController() {
        super(Registracion.class);
        c = new Controller(Registracion.class);
    }
    
    public Registracion byId(String id){
        return c.byId("idUsuario", id);
    }
    
    public Registracion byEmail(String email){
        return c.byId("email", email);
    }
    
    public String getToken(String id){
        Registracion r = c.byId("idUsuario", id);
        return r.getToken();
    }
    
    public boolean hasCompany(String id){
        Registracion r = c.byId("idUsuario", id);
        return r.getCompleto();
    }
}
