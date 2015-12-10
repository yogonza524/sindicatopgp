/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.converters;

import java.util.Date;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.ConverterException;
import javax.faces.convert.FacesConverter;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

/**
 *
 * @author Gonza
 */
@FacesConverter("materialDateConverter")
public class DateMaterializeConverter implements Converter{

    @Override
    public Object getAsObject(FacesContext fc, UIComponent uic, String string) {
        Date result = null;
        if (string != null && string.length() > 0) {
            String[] parts = string.split(", ");
            String[] parts1 = parts[0].split(" ");
            int year = Integer.valueOf(parts[1]);
            int day = Integer.valueOf(parts1[0]);
            String monthName = parts1[1];
            int month = -1;
            switch(monthName){
                case "Enero": month = 1; break; 
                case "Febrero": month = 2; break;
                case "Marzo": month = 3; break; 
                case "Abril": month = 4; break;
                case "Mayo": month = 5; break; 
                case "Junio": month = 6; break;
                case "Julio": month = 7; break; 
                case "Agosto": month = 8; break;
                case "Septiembre": month = 9; break; 
                case "Octubre": month = 10; break;
                case "Noviembre": month = 11; break; 
                case "Diciembre": month = 12; break;
            }
            DateTimeFormatter formatter = DateTimeFormat.forPattern("dd/MM/yyyy");
            DateTime dt = formatter.parseDateTime(day + "/" + month + "/" + year);
            if (dt != null) {
                result = dt.toDate();
            }
            else{
                throw new ConverterException("Error al formatear la fecha");
            }
        }
        else{
            throw new ConverterException("No se recibió ninguna fecha (cadena de caracteres)");
        }
        return result;
    }

    @Override
    public String getAsString(FacesContext fc, UIComponent uic, Object o) {
        String result = "";
        if (o != null) {
            DateTime time = new DateTime((Date)o);
            int day = time.getDayOfMonth();
            int month = time.getMonthOfYear();
            int year = time.getYear();
            result += day;
            switch(month){
                case 1: result += " Enero"; break;
                case 2: result += " Febrero"; break;
                case 3: result += " Marzo"; break;
                case 4: result += " Abril"; break;
                case 5: result += " Mayo"; break;
                case 6: result += " Junio"; break;
                case 7: result += " Julio"; break;
                case 8: result += " Agosto"; break;
                case 9: result += " Septiembre"; break;
                case 10: result += " Octubre"; break;
                case 11: result += " Noviembre"; break;
                case 12: result += " Diciembre"; break;
            }
            result += ", " + year;
        }
        else{
            throw new ConverterException("No se recibió ninguna fecha (Objeto)");
        }
        return result;
    }
    
}
