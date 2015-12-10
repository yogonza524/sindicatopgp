/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.beans;

import com.hp.gagawa.java.elements.Style;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="mail")
@ViewScoped
public class MailBean {
    
    private String materialRoute;
    private String username_recovery;
    
    @PostConstruct
    public void init(){
        materialRoute = FacesContext.getCurrentInstance().getExternalContext().getRealPath("/resources/mails/mail.html");
        username_recovery = FacesContext.getCurrentInstance().getExternalContext().getRealPath("/resources/mails/username_recovery.html");
    }
    
    public String materializeCss() throws FileNotFoundException, IOException{
        File materialize = new File(materialRoute);
//        File body = new File(bodyRoute);
        FileReader f = new FileReader(materialize);
        BufferedReader bf = new BufferedReader(f);
        String line = bf.readLine();
        String material = "";
        while(line != null){
            material += line;
            line = bf.readLine();
        }
        return material;
    }
    
    public String materializeRecoveryUsername() throws FileNotFoundException, IOException{
        File materialize = new File(username_recovery);
//        File body = new File(bodyRoute);
        FileReader f = new FileReader(materialize);
        BufferedReader bf = new BufferedReader(f);
        String line = bf.readLine();
        String material = "";
        while(line != null){
            material += line;
            line = bf.readLine();
        }
        return material;
    }
    
}
