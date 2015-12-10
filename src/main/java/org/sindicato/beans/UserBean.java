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
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.convert.ConverterException;
import javax.servlet.http.HttpServletRequest;
import net.sf.jasperreports.engine.JRException;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.sindicato.business.CuotaController;
import org.sindicato.business.EmpresaController;
import org.sindicato.business.EstadoCuotaController;
import org.sindicato.business.RolController;
import org.sindicato.business.UsuarioController;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.Empresa;
import org.sindicato.entities.EstadoCuota;
import org.sindicato.entities.Usuario;
import org.sindicato.util.Email;
import org.sindicato.util.Reports;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="usuario")
@ViewScoped
public class UserBean implements Serializable{
    
    private UsuarioController uc;
    private CuotaController cc;
    private RolController rc;
    private EstadoCuotaController ecc;
    private EmpresaController ec;
    
    /*
    Properties
    */
    @ManagedProperty(value="#{util}")
    private UtilBean util;
    @ManagedProperty(value="#{mail}")
    private MailBean mail;
    private int count_pendiente;
    private int count_avisadas;
    private int count_gestionadas;
    private int count_vencidas;
    private Usuario user;
    private Empresa empresa;
    private Cuota pendiente;
    private long cantidad_dias_al_vencimiento;
    private double remuneraciones;
    private String fechaInicioActividades;
    private String pass;

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }
    
    public MailBean getMail() {
        return mail;
    }

    public void setMail(MailBean mail) {
        this.mail = mail;
    }

    public String getFechaInicioActividades() {
        return fechaInicioActividades;
    }

    public void setFechaInicioActividades(String fechaInicioActividades) {
        this.fechaInicioActividades = fechaInicioActividades;
    }

    public double getRemuneraciones() {
        return remuneraciones;
    }

    public void setRemuneraciones(double remuneraciones) {
        this.remuneraciones = remuneraciones;
    }

    public Cuota getPendiente() {
        return pendiente;
    }

    public void setPendiente(Cuota pendiente) {
        this.pendiente = pendiente;
    }

    public long getCantidad_dias_al_vencimiento() {
        return cantidad_dias_al_vencimiento;
    }

    public void setCantidad_dias_al_vencimiento(long cantidad_dias_al_vencimiento) {
        this.cantidad_dias_al_vencimiento = cantidad_dias_al_vencimiento;
    }
    
    @PostConstruct
    public void init(){
        user = getLoggedUser();
        uc = new UsuarioController();
        cc = new CuotaController(Cuota.class);
        rc = new RolController();
        ecc = new EstadoCuotaController();
        ec = new EmpresaController(Empresa.class);
        empresa = ec.byId(user.getId());
        if (empresa != null) {
            fechaInicioActividades = util.materializeDate(empresa.getFechaInicioActividad());
        }
        else{
            fechaInicioActividades = util.materializeDate(new Date());
        }
        loadPendiente();
        loadCountQuotes();
        loadCantidadDiasAlVencimientoPendiente();
    }

    public Empresa getEmpresa() {
        return empresa;
    }

    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }

    public UtilBean getUtil() {
        return util;
    }

    public void setUtil(UtilBean util) {
        this.util = util;
    }

    public Usuario getUser() {
        return user;
    }

    public void setUser(Usuario user) {
        this.user = user;
    }
    
    public int getCount_pendiente() {
        return count_pendiente;
    }

    public void setCount_pendiente(int count_pendiente) {
        this.count_pendiente = count_pendiente;
    }

    public int getCount_avisadas() {
        return count_avisadas;
    }

    public void setCount_avisadas(int count_avisadas) {
        this.count_avisadas = count_avisadas;
    }

    public int getCount_gestionadas() {
        return count_gestionadas;
    }

    public void setCount_gestionadas(int count_gestionadas) {
        this.count_gestionadas = count_gestionadas;
    }

    public int getCount_vencidas() {
        return count_vencidas;
    }

    public void setCount_vencidas(int count_vencidas) {
        this.count_vencidas = count_vencidas;
    }
    
    private Usuario getLoggedUser(){
        FacesContext facecontext = FacesContext.getCurrentInstance();
        HttpServletRequest context = util.context();
        return (Usuario)context.getSession().getAttribute("user");
    }
    
    private void loadCountQuotes(){
        if (user != null) {
            count_avisadas = cc.countAvisadas(user.getId());
            count_gestionadas = cc.countGestionadas(user.getId());
            count_vencidas = cc.countVencidas(user.getId());
            count_pendiente = pendiente != null? 1 : 0;
        }
    }
    
    private void loadCantidadDiasAlVencimientoPendiente(){
        Cuota pendiente = cc.pendiente(user.getId());
        if (pendiente != null) {
            cantidad_dias_al_vencimiento = util.diffDates(new Date(), pendiente.getFechaVencimiento());
        }
    }

    private void loadPendiente() {
        pendiente = cc.pendiente(user.getId());
    }
    
    public void calculateTotal(){
        pendiente.setImporte(pendiente.getRemuneracionTotal() * 0.02);
    }
    
    public void registrarPago(){
        if (pendiente != null && pendiente.getImporte() != null && pendiente.getCantidadEmpleados() != null) {
            if (cc.registrarPago(pendiente)) {
                loadPendiente();
                loadCountQuotes();
                FacesContext context = FacesContext.getCurrentInstance();
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,"Pago registrado",  "Muchas gracias") );
            }
            else{
                FacesContext faceContext= FacesContext.getCurrentInstance();
                FacesMessage facesMessage=new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error al pagar", "Hubo un error interno. Intentelo de nuevo mas tarde");
                faceContext.addMessage(null, facesMessage);
            }
        }
    }
    
    public List<Cuota> cuotas(){
        return cc.imprimiblesDesc(user.getId());
    }
    
    //Print Jasper Report
    public void imprimirComprobante(Cuota c){
        Map<String,Object> params = new HashMap<>();
        params.put("razon_social", user.getEmpresa().getRazonSocial());
        params.put("domicilio",user.getEmpresa().getDomicilio());
        params.put("periodo", c.getPeriodo() + "-" + util.year(c.getFechaEmision()));
        params.put("cantidad_empleados", c.getCantidadEmpleados());
        params.put("total", c.getRemuneracionTotal());
        params.put("importe",c.getImporte());
        params.put("intereses", c.getIntereses());
        params.put("tot", round(c.getImporte() + c.getIntereses()));
        
        List<Cuota> toPrint = new ArrayList<>();
        toPrint.add(cc.listDesc(user.getId()).get(0));
        
        try {
            Reports.PDF(params, "/resources/reports/cupon.jasper", toPrint, "cupon-" + c.getPeriodo() + ".pdf");
        } catch (JRException ex) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, ex);
            util.fatal("Error grave al descargar el cupón", "Intentelo de nuevo mas tarde");
        } catch (IOException ex) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, ex);
            util.fatal("Error grave al descargar el cupón", "Intentelo de nuevo mas tarde");
        }
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
    
    public void updateEmpresa(){
        try {
            if (ec.update(empresa)) {
                util.info("Actualizado", "Datos de la empresa actualizados");
                empresa = ec.byId(user.getId());
            }
            else{
                util.error("Error: se rechazó la solicitud", "Contactese con el administrador");
            }
        } catch (Exception e) {
            util.fatal("Error grave al castear la fecha de inicio de actividades", "Intentelo de nuevo mas tarde");
        }
    }
    
    private Date castFecha(String fecha){
        Date result = null;
        if (fecha != null && !fecha.isEmpty()) {
            String[] parts = fecha.split(", ");
            if (parts != null && parts.length == 2) {
            int day = Integer.valueOf(parts[0].split(" ")[0]);
            int mes = -1;
            switch(parts[0].split(" ")[1]){
                case "Enero": mes = 1; break;
                case "Febrero": mes = 2; break;
                case "Marzo": mes = 3; break;
                case "Abril": mes = 4; break;
                case "Mayo": mes = 5; break;
                case "Junio": mes = 6; break;
                case "Julio": mes = 7; break;
                case "Agosto": mes = 8; break;
                case "Septiembre": mes = 9; break;
                case "Octubre": mes = 10; break;
                case "Noviembre": mes = 11; break;
                case "Diciembre": mes = 12; break;
            }
            int year = Integer.valueOf(parts[1]);
            org.joda.time.format.DateTimeFormatter formatter = DateTimeFormat.forPattern("dd-MM-yyyy");
            DateTime dt = formatter.parseDateTime(day + "-" + mes + "-" + year);
            if (dt.isBeforeNow()) {
                result = dt.toDate();
            }
            else{
                util.error("La fecha de inicio de actividad no puede ser mayor a hoy", "Intentelo de nuevo");
            }
        }
        else{
            util.error("Error de formateo al convertir la cadena", "Intentelo de nuevo");
        }
        }
        return result;
    }
    
    public Locale locale(){
        return new Locale("es","AR");
    }
    
    public void regeneratePassword() throws IOException{
        String password = uc.generatePassword(10);
        //Verifico si la contraseña ingresada es igual a la del login
        if (uc.encodePassword(pass).equals(user.getPassword())) {
            user.setPassword(password);
            if (uc.updateUsuario(user)) {
                if (Email.send(user.getEmail(), "CONTRASEÑA NUEVA", mail.materializeCss().replace("$password", password))) {
                    util.info("Generado. Verifique su casilla", "");
                }
                else{
                    util.error("Envío fallido. Intentelo de nuevo", "");
                }
            }
            else{
                util.error("Error al cambiar la contraseña", "");
            }
        }
        else{
            util.error("Contraseña inválida", "Error de generación");
        }
    }
}
