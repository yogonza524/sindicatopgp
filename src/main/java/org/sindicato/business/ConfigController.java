/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import java.util.Date;
import java.util.List;
import org.sindicato.controllers.Controller;
import org.sindicato.entities.Config;

/**
 *
 * @author Gonza
 */
public class ConfigController {
    
    private Controller<Config> cc;
    private Config instance;
    
    public ConfigController() {
        cc = new Controller(Config.class);
        instance = cc.all().get(0); //Singleton record in database
    }
    
    public int diaEmision(){
        return instance.getDiaEmision();
    }
    
    public int diaVencimiento(){
        return instance.getDiaVencimiento();
    }
    
    public int tiempoDePago(){
        return instance.getDiaVencimiento() - instance.getDiaEmision();
    }
    
    public Date generateFechaEmision(){
        Date output = null;
        Controller c = new Controller(Config.class);
        String query = "SELECT * FROM get_fecha_emision()";
        List result = c.callProcedure(query, null);
        if (result != null) {
            output = (Date) result.get(0);
        }
        return output;
    }
}
