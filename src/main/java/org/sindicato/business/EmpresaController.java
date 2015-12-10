/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import java.util.List;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.Empresa;

/**
 *
 * @author Gonza
 */
public class EmpresaController extends AbstractBusinessController<Empresa>{

    public EmpresaController(Class clazz) {
        super(clazz);
    }
    
    public Empresa byId(String id){
        return c.byId("idUsuario", id);
    }
    
    public Boolean update(Empresa e){
        return c.update(e);
    }
    
    public boolean add(Empresa e){
        return c.add(e);
    }
    
    public List<Empresa> all(){
        return c.all();
    }
    
}
