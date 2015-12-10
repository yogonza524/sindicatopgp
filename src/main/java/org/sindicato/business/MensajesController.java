/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import org.sindicato.controllers.Controller;
import org.sindicato.entities.Mensaje;
import org.sindicato.entities.Usuario;

/**
 *
 * @author Gonza
 */
public class MensajesController extends AbstractBusinessController<Mensaje>{

    public MensajesController(Class clazz) {
        super(clazz);
    }
    
    public List<Mensaje> noLeidos(){
        return c.widthOneRestriction("leido", false);
    }
    
    public List<Mensaje> leidos(){
        return c.widthOneRestriction("leido", true);
    }
    
    public boolean isFromUser(String id){
        boolean output = false;
        Mensaje m = c.byId("id", id);
        if (m != null) {
            Controller<Usuario> uc = new Controller(Usuario.class);
            Usuario u = uc.byId("email", m.getEmail());
            if (u != null) {
                output = true;
            }
        }
        return output;
    }
    
    public boolean isFromUser(Mensaje m){
        boolean output = false;
        if (m != null && m.getId() != null) {
            output = isFromUser(m.getId());
        }
        return output;
    }
    
    public boolean isFromUnknown(String id){
        return !isFromUser(id);
    }
    
    public boolean isFromUnknown(Mensaje m){
        return !isFromUser(m);
    }
    
    public List<Mensaje> all(){
        return c.all();
    }
    
    public List<Mensaje> allFromUser(){
        List<Mensaje> output = new ArrayList<>();
        List<Mensaje> mensajes = all();
        if (mensajes != null) {
            Iterator i = mensajes.iterator();
            while(i.hasNext()){
                Mensaje m = (Mensaje)i.next();
                if (this.isFromUser(m)) {
                    output.add(m);
                }
            }
        }
        return output;
    }
    
    public List<Mensaje> allFromUnknown(){
        List<Mensaje> output = new ArrayList<>();
        List<Mensaje> mensajes = all();
        if (mensajes != null) {
            Iterator i = mensajes.iterator();
            while(i.hasNext()){
                Mensaje m = (Mensaje)i.next();
                if (this.isFromUnknown(m)) {
                    output.add(m);
                }
            }
        }
        return output;
    }
    
    public Boolean addMensaje(String nombre, String email, String contenido){
        Mensaje m = new Mensaje();
        m.setNombre(nombre);
        m.setContenido(contenido);
        m.setEmail(email);
        m.setFechaCreacion(new Date());
        m.setFechaUltimaModificacion(new Date());
        return c.add(m);
    }
    
    public Boolean leer(String id){
        boolean output = false;
        if (id != null && id.length() > 0) {
            Mensaje m = c.byId("id", id);
            if (m != null) {
                m.setLeido(true);
                output = c.update(m);
            }
        }
        return output;
    }
    
    public Boolean leer(Mensaje m){
        boolean output = false;
        if (m != null && m.getId() != null) {
            output = leer(m.getId());
        }
        return output;
    }
    
    public boolean modificarMensaje(Mensaje m){
        boolean output = false;
        if (m != null && m.getId() != null) {
            output = c.update(m);
        }
        return output;
    }
    
    public boolean eliminarMensaje(Mensaje m){
        boolean output = false;
        if (m != null && m.getId() != null) {
            output = c.remove(m);
        }
        return output;
    }
    
    public boolean eliminarMensaje(String id){
        boolean output = false;
        if (id != null) {
            Mensaje m = c.byId("id", id);
            if (m != null) {
                output = c.remove(m);
            }
        }
        return output;
    }
    
    public BigInteger cantidadMensajesUsuarios(){
        BigInteger output = BigInteger.ZERO;
        String query = "SELECT * from cantidad_tipo_mensajes";
        List cantidad = c.callProcedure(query, null); 
        if (cantidad != null) {
            Object[] data = (Object[])cantidad.get(0);
            output = (BigInteger)data[0];
        }
        return output;
    }
    
    public BigInteger cantidadMensajesUsuariosDesconocidos(){
        BigInteger output = BigInteger.ZERO;
        String query = "SELECT * from cantidad_tipo_mensajes";
        List cantidad = c.callProcedure(query, null); 
        if (cantidad != null) {
            Object[] data = (Object[])cantidad.get(0);
            output = (BigInteger)data[1];
        }
        return output;
    }
}
