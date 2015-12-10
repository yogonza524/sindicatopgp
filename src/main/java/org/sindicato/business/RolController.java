/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import org.sindicato.controllers.Controller;
import org.sindicato.entities.Rol;

/**
 *
 * @author Gonza
 */
public class RolController {
    
    private Controller<Rol> rc;

    public RolController() {
        rc = new Controller(Rol.class);
    }
    
    public Rol getUser(){
        return rc.byId("descripcion", "USUARIO");
    }
    
    public Rol getAdmin(){
        return rc.byId("descripcion", "ADMINISTRADOR");
    }
    
}
