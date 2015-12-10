/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.jboss.logging.Logger;
import org.jboss.logging.Logger.Level;
import org.joda.time.DateTime;
import org.sindicato.controllers.Controller;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.CuotaId;
import org.sindicato.entities.Empresa;
import org.sindicato.entities.EstadoCuota;
import org.sindicato.enums.Order;

/**
 *
 * @author Gonza
 */
public class CuotaController extends AbstractBusinessController<Cuota>{

//    private Controller<EstadoCuota> cec;
    private EstadoCuotaController ecc;
    private ConfigController cc;
    private final Logger Log = Logger.getLogger(CuotaController.class);
    
    public CuotaController(Class clazz) {
        super(clazz);
        ecc = new EstadoCuotaController();
        cc = new ConfigController();
    }
    
    public Cuota pendiente(String id_user){
        Cuota result = null;
        EstadoCuotaController ecc = new EstadoCuotaController();
        EmpresaController emc = new EmpresaController(Empresa.class);
        EstadoCuota ec = ecc.getPendiente();
        EstadoCuota pendiente = ecc.getPendiente();
        if (pendiente != null) {
            Map<String,Object> params = new HashMap<>();
            params.put("empresa", emc.byId(id_user));
            params.put("idEstado", pendiente.getId());
            result = c.withParams(params);
        }
        return result;
    }
    
    public List<Cuota> gestionadas(String id_user){
        List<Cuota> result = null;
        if (id_user != null && !id_user.isEmpty()) {
            EstadoCuotaController ecc = new EstadoCuotaController();
            EstadoCuota ec = ecc.getGestionado();
            if (ec != null) {
                Map<String,Object> params = new HashMap<>();
                params.put("idEstado", ec.getId());
                params.put("empresa.idUsuario", id_user);
                result = c.widthRestrictions(params);
            }
        }
        return result;
    }
    
    public List<Cuota> vencidas(String id_user){
        List<Cuota> result = null;
        if (id_user != null && !id_user.isEmpty()) {
            EstadoCuotaController ecc = new EstadoCuotaController();
            EstadoCuota ec = ecc.getVencido();
            if (ec != null) {
                Map<String,Object> params = new HashMap<>();
                params.put("idEstado", ec.getId());
                params.put("empresa.idUsuario", id_user);
                result = c.widthRestrictions(params);
            }
        }
        return result;
    }
    
    public List<Cuota> avisadas(String id_user){
        List<Cuota> result = null;
        if (id_user != null && !id_user.isEmpty()) {
            EstadoCuotaController ecc = new EstadoCuotaController();
            EstadoCuota ec = ecc.getAvisado();
            if (ec != null) {
                Map<String,Object> params = new HashMap<>();
                params.put("idEstado", ec.getId());
                params.put("empresa.idUsuario", id_user);
                result = c.widthRestrictions(params);
            }
        }
        return result;
    }
    
    public int countVencidas(String id_user){
        int result = 0;
        List<Cuota> list = vencidas(id_user);
        if (list != null && !list.isEmpty()) {
            result = list.size();
        }
        return result;
    }
    
    public int countGestionadas(String id_user){
        int result = 0;
        List<Cuota> list = gestionadas(id_user);
        if (list != null && !list.isEmpty()) {
            result = list.size();
        }
        return result;
    }
    
    public int countAvisadas(String id_user){
        int result = 0;
        List<Cuota> list = avisadas(id_user);
        if (list != null && !list.isEmpty()) {
            result = list.size();
        }
        return result;
    }
    
    public boolean registrarPago(Cuota pendiente){
        boolean output = false;
        if (pendiente != null) {
            EstadoCuotaController ecc = new EstadoCuotaController();
            EstadoCuota e = ecc.getAvisado();
            if (e != null) {
                pendiente.setIdEstado(e.getId());
                output = c.update(pendiente);
                System.out.println("ID del estado avisado: " + pendiente.getIdEstado());
                System.out.println("resultado de la actualizacion: " + output);
            }
        }
        return output;
    }
    
    public List<Cuota> list(String id_user){
        return c.widthOneRestriction("empresa.idUsuario", id_user);
    }
    
    public List<Cuota> listDesc(String id_user){
        Map<String,Object> params = new HashMap<>();
        params.put("empresa.idUsuario", id_user);
        return c.withRestrictionsOrderBy(params, "fechaCreacion", Order.DESC);
    }
    
    public List<Cuota> listDesc(String id_user, String keyDesc){
        Map<String,Object> params = new HashMap<>();
        params.put("empresa.idUsuario", id_user);
        return c.withRestrictionsOrderBy(params, keyDesc, Order.DESC);
    }
    
    public List<Cuota> gestionados(String id_user){
        List<Cuota> result = null;
        EstadoCuotaController ecc = new EstadoCuotaController();
        EstadoCuota gestionado = ecc.getGestionado();
        Map<String,Object> params = new HashMap<>();
        params.put("empresa.idUsuario", id_user);
        params.put("idEstado", gestionado.getId());
        return c.widthRestrictions(params);
    }
    
    public List<Cuota> avisados(String id_user){
        List<Cuota> result = null;
        EstadoCuotaController ecc = new EstadoCuotaController();
        EstadoCuota avisado = ecc.getAvisado();
        Map<String,Object> params = new HashMap<>();
        params.put("empresa.idUsuario", id_user);
        params.put("idEstado", avisado.getId());
        return c.widthRestrictions(params);
    }
    
    public List<Cuota> imprimiblesDesc(String id_user){
        List<Cuota> result = new ArrayList<>();
        List<Cuota> gestionados = gestionados(id_user);
        List<Cuota> avisados = avisados(id_user);
        Iterator i = gestionados.iterator();
        Iterator j = avisados.iterator();
        while(i.hasNext()){
            result.add((Cuota)i.next());
        }
        while(j.hasNext()){
            result.add((Cuota)j.next());
        }
        return result;
    }
    
    public Boolean add(Cuota cuota){
        return c.add(cuota);
    }
    
    public Boolean update(Cuota cuota){
        return c.update(cuota);
    }
    
    public Boolean generateCuotaProcedure(String id_empresa){
        boolean output = false;
        if (id_empresa != null) {
            Map<String,Object> params = new HashMap<>();
            params.put("idEmpresa", id_empresa);
            String query = "SELECT * FROM generate_cuota(:idEmpresa);";
            List result = null;
            try {
               result = c.callProcedure(query, params); 
            } catch (Exception e) {
                Log.log(Level.FATAL, "Excepcion capturada: " + e.getMessage());
            }
            
            if (result != null) {
                output = (boolean) result.get(0);
                System.out.println("El resultado de llamar al metodo almacenado fue: " + output);
                Log.log(Level.INFO, "El resultado de llamar al metodo almacenado fue: " + output);
            }
        }
        return output;
    }
    
    public Boolean generateCuota(String id_empresa){
        Boolean result = false;
        //Obtengo la empresa
        EmpresaController ec = new EmpresaController(Empresa.class);
        Empresa e = ec.byId(id_empresa);
        if (e != null) {
            DateTime now = new DateTime(new Date());
            DateTime emision = new DateTime(e.getFechaEmisionProximaCuota());
            if (emision.isBefore(now)) {
                //Ya paso la fecha de emision, verifico si hay cuotas pendientes
                Log.log(Level.INFO, "Ya pasó la fecha de emisión");
                Cuota c = pendiente(id_empresa);
                if (c == null) {
                    //No tiene cuotas pendientes
                    Cuota nueva = new Cuota();
                    CuotaId id = new CuotaId();
                    id.setIdEmpresa(id_empresa);
                    nueva.setId(id);
                    nueva.setEmpresa(e);
                    nueva.setCantidadEmpleados(0);
                    nueva.setFechaCreacion(new Date());
                    nueva.setFechaEmision(new Date());
                    nueva.setFechaUltimaModificacion(new Date());
                    nueva.setFechaVencimiento(new Date());
                    nueva.setIdEstado(ecc.getPendiente().getId());
                    nueva.setImporte(0.0);
                    nueva.setIntereses(0.0);
                    nueva.setPeriodo("");
                    nueva.setRemuneracionTotal(0.0);
                    
                    //Actualizo la fecha de emision siguiente
                    e.setFechaEmisionProximaCuota(cc.generateFechaEmision());
                    
                    //Agrego la cuota
                    if (this.add(nueva)) {
                        //Agregado correctamente
                         Log.log(Level.INFO, "Excelente! Se agregó la cuota");
                         
                         //Modifico la fecha de emision
                         if (ec.update(e)) {
                            Log.log(Level.INFO, "Excelente! Se modificó la fecha de emision de la empresa");
                            result = true;
                        }
                         else{
                             Log.log(Level.INFO, "Error al actualizar la fecha de emision siguiente");
                         }
                    }
                    else{
                        Log.log(Level.INFO, "Error al agregar la cuota");
                    }
                }
                else{
                    Log.log(Level.INFO, "No se puede seguir: tiene cuotas pendientes");
                }
            }
        }
        else{
            Log.log(Level.INFO, "Empresa no encontrada");
        }
        return result;
    }
    
    public Cuota byId(String id_cuota){
        return c.byId("id.id", id_cuota);
    }
    
    public Cuota byIdUser(String id_user){
        return c.byId("empresa.idUsuario", id_user);
    }
}
