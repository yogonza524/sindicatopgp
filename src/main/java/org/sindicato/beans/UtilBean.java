/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.beans;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import net.sf.jasperreports.engine.JRException;
import org.joda.time.DateTime;
import org.joda.time.Duration;
import org.sindicato.business.CuotaController;
import org.sindicato.entities.Cuota;
import org.sindicato.util.Reports;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="util")
@ViewScoped
public class UtilBean implements Serializable{
    
    private CuotaController cc;
    
    @PostConstruct
    public void init(){
        cc = new CuotaController(Cuota.class);
    }
    
    public String argDate(Date fecha){
        DateTime dt = new DateTime(fecha);
        String output = String.valueOf(dt.getDayOfMonth()) + " de ";
        switch(dt.getMonthOfYear()){
            case 1 : output += "Enero" ;break;
            case 2 : output += "Febrero" ;break;
            case 3 : output += "Marzo" ;break;
            case 4 : output += "Abril" ;break;
            case 5 : output += "Mayo" ;break;
            case 6 : output += "Junio" ;break;
            case 7 : output += "Julio" ;break;
            case 8 : output += "Agosto" ;break;
            case 9 : output += "Septiembre" ;break;
            case 10 : output += "Octubre" ;break;
            case 11 : output += "Noviembre" ;break;
            case 12 : output += "Diciembre" ;break;
        }
        return output + " de " + dt.getYear();
    }
    
    public String simpleArgDate(Date fecha){
        String output = "";
        if (fecha != null) {
            DateTime time = new DateTime(fecha);
            switch(time.getMonthOfYear()){
                case 1: output = "Enero"; break;
                case 2: output = "Febrero"; break;
                case 3: output = "Marzo"; break;
                case 4: output = "Abril"; break;
                case 5: output = "Mayo"; break;
                case 6: output = "Junio"; break;
                case 7: output = "Julio"; break;
                case 8: output = "Agosto"; break;
                case 9: output = "Septiembre"; break;
                case 10: output = "Octubre"; break;
                case 11: output = "Noviembre"; break;
                case 12: output = "Diciembre"; break;
            }
            if (!output.equals("")) {
                output += "-" + time.getYear();
            }
        }
        return output;
    }
    
    public String materializeDate(Date fecha){
        String output = "";
        if (fecha != null) {
            DateTime time = new DateTime(fecha);
            int day = time.getDayOfMonth();
            int month = time.getMonthOfYear();
            int year = time.getYear();
            output += day;
            switch(month){
                case 1: output += " Enero"; break;
                case 2: output += " Febrero"; break;
                case 3: output += " Marzo"; break;
                case 4: output += " Abril"; break;
                case 5: output += " Mayo"; break;
                case 6: output += " Junio"; break;
                case 7: output += " Julio"; break;
                case 8: output += " Agosto"; break;
                case 9: output += " Septiembre"; break;
                case 10: output += " Octubre"; break;
                case 11: output += " Noviembre"; break;
                case 12: output += " Diciembre"; break;
            }
            output += ", " + year;
        }
        return output;
    }
    
    public String fullSimpleArgDate(Date fecha){
        String output = "";
        if (fecha != null) {
            DateTime time = new DateTime(fecha);
            int day = time.getDayOfMonth();
            int month = time.getMonthOfYear();
            int year = time.getYear();
            output = day + "-" + month + "-" + year;
        }
        return output;
    }
    
    public String fullSimpleMonthArgDate(Date fecha){
        String output = "";
        if (fecha != null) {
            DateTime time = new DateTime(fecha);
            output = String.valueOf(time.getDayOfMonth()) + "-";
            switch(time.getMonthOfYear()){
                case 1: output += "ENE"; break;
                case 2: output += "FEB"; break;
                case 3: output += "MAR"; break;
                case 4: output += "ABR"; break;
                case 5: output += "MAY"; break;
                case 6: output += "JUN"; break;
                case 7: output += "JUL"; break;
                case 8: output += "AGO"; break;
                case 9: output += "SEP"; break;
                case 10: output += "JUL"; break;
                case 11: output += "NOV"; break;
                case 12: output += "DIC"; break;
            }
            if (!output.equals("")) {
                output += "-" + time.getYear();
            }
        }
        return output;
    }
    
    public String monthByNumber(int n){
        String output = "";
        if (n > 0 && n < 13) {
            switch(n){
                case 1: output = "Enero"; break;
                case 2: output = "Febrero"; break;
                case 3: output = "Marzo"; break;
                case 4: output = "Abril"; break;
                case 5: output = "Mayo"; break;
                case 6: output = "Junio"; break;
                case 7: output = "Julio"; break;
                case 8: output = "Agosto"; break;
                case 9: output = "Septiembre"; break;
                case 10: output = "Octubre"; break;
                case 11: output = "Noviembre"; break;
                case 12: output = "Diciembre"; break;
            }
        }
        return output;
    }
    
    public String monthByNumber(Date fecha){
        String output = "";
        if (fecha != null) {
            DateTime time = new DateTime(fecha);
            output = monthByNumber(time.getMonthOfYear());
        }
        return output;
    }
    
    public HttpServletRequest context(){
        FacesContext faceContext=FacesContext.getCurrentInstance();
        return (HttpServletRequest)faceContext.getExternalContext().getRequest();
    }
    
    public int year(Date fecha){
        DateTime time = new DateTime(new Date());
        int result = time.getYear();
        if (fecha != null) {
            time = new DateTime(fecha);
            result = time.getYear();
        }
        return result - 1;
    }
    
    public void info(String title, String detail){
        FacesContext faceContext= FacesContext.getCurrentInstance();
        FacesMessage facesMessage=new FacesMessage(FacesMessage.SEVERITY_INFO, title, detail);
        faceContext.addMessage(null, facesMessage);
    }
    
    public void error(String title, String detail){
        FacesContext faceContext= FacesContext.getCurrentInstance();
        FacesMessage facesMessage=new FacesMessage(FacesMessage.SEVERITY_ERROR, title, detail);
        faceContext.addMessage(null, facesMessage);
    }
    
    public void warn(String title, String detail){
        FacesContext faceContext= FacesContext.getCurrentInstance();
        FacesMessage facesMessage=new FacesMessage(FacesMessage.SEVERITY_WARN, title, detail);
        faceContext.addMessage(null, facesMessage);
    }
    
    public void fatal(String title, String detail){
        FacesContext faceContext= FacesContext.getCurrentInstance();
        FacesMessage facesMessage=new FacesMessage(FacesMessage.SEVERITY_FATAL, title, detail);
        faceContext.addMessage(null, facesMessage);
    }
    
    public long diffDates(Date first, Date second){
        long result = 0;
        if (first != null && second != null) {
            DateTime f = new DateTime(first);
            DateTime s = new DateTime(second);
            Duration d = new Duration(f,s);
            result = d.getStandardDays();
        }
        return result;
    }
    
    public long diffNow(Date fecha){
        return diffDates(fecha, new Date());
    }
    
    public Double round(Double n){
        if(n != null) {
            long factor = (long) Math.pow(10, 2);
            n = n * factor;
            long tmp = Math.round(n);
            n = (double) tmp / factor;
        }
        return n;
    }
    //Print Jasper Report
    public void imprimirComprobante(Cuota c){
        Map<String,Object> params = new HashMap<>();
        params.put("razon_social", c.getEmpresa().getRazonSocial());
        params.put("domicilio",c.getEmpresa().getDomicilio());
        params.put("periodo", c.getPeriodo() + "-" + year(c.getFechaEmision()));
        params.put("cantidad_empleados", c.getCantidadEmpleados());
        params.put("total", c.getRemuneracionTotal());
        params.put("importe",c.getImporte());
        params.put("intereses", c.getIntereses());
        params.put("tot", round(c.getImporte() + c.getIntereses()));
        
        List<Cuota> toPrint = new ArrayList<>();
        toPrint.add(cc.listDesc(c.getId().getIdEmpresa()).get(0));
        
        try {
            Reports.PDF(params, "/resources/reports/cupon.jasper", toPrint, "cupon-" + c.getPeriodo() + ".pdf");
        } catch (JRException ex) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, ex);
            fatal("Error grave al descargar el cupón", "Intentelo de nuevo mas tarde");
        } catch (IOException ex) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, ex);
            fatal("Error grave al descargar el cupón", "Intentelo de nuevo mas tarde");
        }
    }
}
