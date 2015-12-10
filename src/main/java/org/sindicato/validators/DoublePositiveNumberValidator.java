/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.validators;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.FacesValidator;
import javax.faces.validator.Validator;
import javax.faces.validator.ValidatorException;

/**
 *
 * @author Gonza
 */
@FacesValidator("doublePositiveNumberValidator")
public class DoublePositiveNumberValidator implements Validator{
    
    @Override
    public void validate(FacesContext fc, UIComponent uic, Object o) throws ValidatorException {
        Double result = null;
        try {
            result = Double.valueOf(String.valueOf(o));
        } catch (Exception e) {
            FacesMessage msg = new FacesMessage("Error al convertir el objeto a número","Error de validación");
            msg.setSeverity(FacesMessage.SEVERITY_ERROR);
            throw new ValidatorException(msg);
        }
        if (result <= 0) {
            FacesMessage msg = new FacesMessage("El número debe ser positivo","Error de validación");
            msg.setSeverity(FacesMessage.SEVERITY_ERROR);
            throw new ValidatorException(msg);
        }
    }
}
