/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import org.sindicato.controllers.AbstractController;
import org.sindicato.controllers.Controller;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.EstadoCuota;

/**
 *
 * @author Gonza
 */
public class EstadoCuotaController {
    
    private static Controller<EstadoCuota> ecc;

    public EstadoCuotaController() {
        ecc = new Controller(EstadoCuota.class);
    }
    
    public String getEstado(String id){
        return ecc.byId("id", id).getNombre();
    }
    
    public String getDescripcion(String id){
        return ecc.byId("id", id).getDescripcion();
    }
    
    public EstadoCuota getPendiente(){
        return ecc.byId("nombre", "PENDIENTE");
    }
    public EstadoCuota getVencido(){
        return ecc.byId("nombre", "EN MORA");
    }
    
    public EstadoCuota getAvisado(){
        return ecc.byId("nombre", "AVISADO");
    }
    
    public EstadoCuota getGestionado(){
        return ecc.byId("nombre", "GESTIONADO");
    }
    
    public Boolean isPendiente(Cuota c){
        if (c != null) {
            return getPendiente().getId().equals(c.getIdEstado());
        }
        return false;
    }
    
    public Boolean isAvisado(Cuota c){
        if (c != null) {
            return getAvisado().getId().equals(c.getIdEstado());
        }
        return false;
    }
    
    public Boolean isVencido(Cuota c){
        if (c != null) {
            return getVencido().getId().equals(c.getIdEstado());
        }
        return false;
    }
    
    public Boolean isGestionado(Cuota c){
        if (c != null) {
            return getGestionado().getId().equals(c.getIdEstado());
        }
        return false;
    }
}
