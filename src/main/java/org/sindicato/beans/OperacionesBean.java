/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.beans;

import java.util.List;
import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.ViewScoped;
import org.sindicato.business.CuotaController;
import org.sindicato.business.EmpresaController;
import org.sindicato.business.EstadoCuotaController;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.Empresa;
import org.sindicato.entities.Usuario;

/**
 *
 * @author Gonza
 */
@ManagedBean(name="operaciones")
@ViewScoped
public class OperacionesBean {
    
    private CuotaController cc;
    private EmpresaController ec;
    private EstadoCuotaController ecc;
    private List<Cuota> vencidas;
    private List<Cuota> lista;
    private Usuario logged;
    private Cuota selected;
    private Cuota dropdownSelected;

    public Cuota getDropdownSelected() {
        return dropdownSelected;
    }

    public void setDropdownSelected(Cuota dropdownSelected) {
        this.dropdownSelected = dropdownSelected;
    }

    public Cuota getSelected() {
        return selected;
    }

    public void setSelected(Cuota selected) {
        this.selected = selected;
    }

    public List<Cuota> getLista() {
        return lista;
    }

    public void setLista(List<Cuota> lista) {
        this.lista = lista;
    }

    public Usuario getLogged() {
        return logged;
    }

    public void setLogged(Usuario logged) {
        this.logged = logged;
    }
    
    @ManagedProperty(value="#{login}")
    private LoginBean login;
    
    @ManagedProperty(value="#{util}")
    private UtilBean util;

    public UtilBean getUtil() {
        return util;
    }

    public void setUtil(UtilBean util) {
        this.util = util;
    }
   
    public LoginBean getLogin() {
        return login;
    }

    public void setLogin(LoginBean login) {
        this.login = login;
    }
    
    public List<Cuota> getVencidas() {
        return vencidas;
    }

    public void setVencidas(List<Cuota> vencidas) {
        this.vencidas = vencidas;
    }
    
    @PostConstruct
    public void init(){
        cc = new CuotaController(Cuota.class);
        ec = new EmpresaController(Empresa.class);
        ecc = new EstadoCuotaController();
        logged = login.getLoggedUser();
        if (logged != null) {
            vencidas = cc.vencidas(logged.getId());
            if (vencidas != null && vencidas.size() > 0) {
                selected = vencidas.get(0);
            }
            lista = cc.imprimiblesDesc(logged.getId());
        }
//        dropdownSelected = new Cuota();
        
    }
    
    public Double subTotal(){
        Double result = 0.0;
        if (selected != null && selected.getCantidadEmpleados() != null && selected.getRemuneracionTotal() != null) {
            result = round(selected.getRemuneracionTotal() * .02);
            selected.setImporte(result);
        }
        return result;
    }
    
    public Double intereses(){
        Double result = 0.0;
        if (selected != null) {
            result = round(subTotal() * .01 * util.diffNow(selected.getFechaVencimiento()));
            selected.setIntereses(result);
        }
        return result;
    }
    
    public void abonarVencida(){
        if (selected != null) {
            selected.setIdEstado(ecc.getAvisado().getId());
            if (cc.update(selected)) {
                init();
                util.info("Cuota abonada. Ya puede imprimir el cupon", "Pago concretado");
            }
            else{
                util.error("Hubo un error al concretar el pago. Intentelo de nuevo mas tarde", "Error interno");
            }
        }
        else{
            util.error("No seleccionó una cuota", "Error externo");
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
    
    public int vencidas(){
        return logged != null? cc.countVencidas(logged.getId()) : 0;
    }
    
    public int avisadas(){
        return logged != null? cc.countAvisadas(logged.getId()) : 0;
    }
    
    public int cerradas(){
        return logged != null? cc.countGestionadas(logged.getId()) : 0;
    }
    
    public int pendiente(){
        int result = 0;
        if (logged != null && cc.pendiente(logged.getId()) != null) {
            result = cc.pendiente(logged.getId()) != null ? 1 : 0;
        }
        return result;
    }
}
