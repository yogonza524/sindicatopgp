/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import java.util.logging.Logger;
import org.sindicato.controllers.Controller;
import org.sindicato.enums.Order;

/**
 *
 * @author Gonza
 */
public abstract class AbstractBusinessController<T> {
    
    protected Controller<T> c;
    
    public AbstractBusinessController(Class clazz){
        c = new Controller(clazz);
    }
    
    public T lastCreated(){
        return c.allOrderBy("fechaCreacion", Order.DESC).get(0);
    }
    
    public T lastModified(){
        return c.allOrderBy("fechaCreacion", Order.DESC).get(0);
    }
    
}
