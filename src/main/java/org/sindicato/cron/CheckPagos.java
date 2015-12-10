/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.cron;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import org.jboss.logging.Logger;
import org.joda.time.DateTime;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.sindicato.business.ConfigController;
import org.sindicato.business.CuotaController;
import org.sindicato.business.EmpresaController;
import org.sindicato.business.EstadoCuotaController;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.CuotaId;
import org.sindicato.entities.Empresa;

/**
 *
 * @author Gonzalo
 */
public class CheckPagos implements Job{

    private final Logger LOGGER;
    private EmpresaController ec = new EmpresaController(Empresa.class);
    private EstadoCuotaController ecc = new EstadoCuotaController();
    private ConfigController cc = new ConfigController();
    private CuotaController cuotac = new CuotaController(Cuota.class);

    public CheckPagos() {
        LOGGER = Logger.getLogger(CheckPagos.class);
    }
    
    @Override
    public void execute(JobExecutionContext jec) throws JobExecutionException {
        generatePendiente();
        checkVencimiento();
    }
    
    private void generatePendiente(){
        LOGGER.log(Logger.Level.INFO, "Metodo: generatedPendientes - fecha " + new Date());
        DateTime now = new DateTime(new Date()); //Obtengo la hora actual
        Iterator i = ec.all().iterator();
        while(i.hasNext()){
            Empresa e = (Empresa)i.next();
            DateTime nextEmision = new DateTime(e.getFechaEmisionProximaCuota());
            LOGGER.log(Logger.Level.INFO, "Empresa: " + e.getRazonSocial());
            Cuota pendiente = cuotac.pendiente(e.getIdUsuario());
            if (pendiente != null) {
                LOGGER.log(Logger.Level.INFO, "Tiene una cuota pendiente");
            }
            else{
                if (nextEmision.isBefore(now)) {
                    LOGGER.log(Logger.Level.INFO, "No tiene cuotas pendientes y la fecha de emision ya pasó, intentaré agregar una nueva");
                    boolean result = cuotac.generateCuota(e.getIdUsuario());
                    if (result) {
                        LOGGER.log(Logger.Level.INFO, "Cuota generada y fecha de emision siguiente en empresa actualizada");
                    }
                    else{
                        LOGGER.log(Logger.Level.INFO, "Sucedio un error al agregar la cuota y actualizar la fecha de emision en la empresa");
                    }
                }
                else{
                    LOGGER.log(Logger.Level.INFO, "La fecha de emisión aun no ha llegado");
                }
            }
        }
    }
    
    private void checkVencimiento(){
        LOGGER.log(Logger.Level.INFO, "Inspeccionando vencimiento - fecha " + new Date());
        DateTime now = new DateTime(new Date()); //Obtengo la hora actual
        EmpresaController ec = new EmpresaController(Empresa.class);
        EstadoCuotaController ecc = new EstadoCuotaController();
        CuotaController concuota = new CuotaController(Cuota.class);
        ConfigController cc = new ConfigController();
        CuotaController cuotac = new CuotaController(Cuota.class);
        Iterator i = ec.all().iterator();
        while(i.hasNext()){
            Empresa e = (Empresa)i.next();
            Cuota cuota = cuotac.pendiente(e.getIdUsuario());
            if (ecc.isPendiente(cuota)) {
                LOGGER.log(Logger.Level.INFO, "Pendiente: " + ecc.isPendiente(cuota));
                DateTime vencimiento = new DateTime(cuota.getFechaVencimiento());
                if (vencimiento.isBefore(now)) {
                    LOGGER.log(Logger.Level.INFO, "Cuota vencida");
                    cuota.setIdEstado(ecc.getVencido().getId());
                    if (cuotac.update(cuota)) {
                        LOGGER.log(Logger.Level.INFO, "Se modifico la cuota");
                    }
                    else{
                        LOGGER.log(Logger.Level.INFO, "Error al modificar la cuota");
                    }
                }
            }
        }
    }
}
