/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.converters;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.ConverterException;
import javax.faces.convert.FacesConverter;
import org.sindicato.business.CuotaController;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.CuotaId;

/**
 *
 * @author Gonza
 */
@FacesConverter(value="cuotaconverter")
public class CuotaConverter implements Converter {

    @Override
    public Object getAsObject(FacesContext fc, UIComponent uic, String id_cuota) {
        CuotaController cc = new CuotaController(Cuota.class);
        Cuota c = cc.byId(id_cuota);
        if (c == null) {
            throw new ConverterException("No se encontró la cuota. Error de conversión");
        }
        return c;
    }

    @Override
    public String getAsString(FacesContext fc, UIComponent uic, Object o) {
        if (o == null) {
            throw new ConverterException("No se pudo convertir la cuota");
        }
        return ((Cuota)o).getId().getId();
    }
    
}
