/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.validators;

import java.util.Date;
import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.FacesValidator;
import javax.faces.validator.Validator;
import javax.faces.validator.ValidatorException;
import org.joda.time.DateTime;

/**
 *
 * @author Gonza
 */
@FacesValidator("dateNowValidator")
public class DateValidator implements Validator{

    @Override
    public void validate(FacesContext fc, UIComponent uic, Object o) throws ValidatorException {
        DateTime time = new DateTime((Date)o);
        if (!time.isBeforeNow()) {
            FacesMessage msg = new FacesMessage("La fecha no puede ser mayor a hoy","Error de validación");
            msg.setSeverity(FacesMessage.SEVERITY_ERROR);
            throw new ValidatorException(msg);
        }
    }
    
}
