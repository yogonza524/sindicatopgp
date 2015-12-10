package org.sindicato.entities;
// Generated 03-dic-2015 16:29:24 by Hibernate Tools 4.3.1


import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Config generated by hbm2java
 */
@Entity
@Table(name="config"
    ,schema="public"
)
public class Config  implements java.io.Serializable {


     private String id;
     private int diaEmision;
     private int diaVencimiento;
     private Date fechaCreacion;
     private Date fechaUltimaModificacion;

    public Config() {
    }

	
    public Config(String id, int diaEmision, int diaVencimiento) {
        this.id = id;
        this.diaEmision = diaEmision;
        this.diaVencimiento = diaVencimiento;
    }
    public Config(String id, int diaEmision, int diaVencimiento, Date fechaCreacion, Date fechaUltimaModificacion) {
       this.id = id;
       this.diaEmision = diaEmision;
       this.diaVencimiento = diaVencimiento;
       this.fechaCreacion = fechaCreacion;
       this.fechaUltimaModificacion = fechaUltimaModificacion;
    }
   
     @Id 

    
    @Column(name="id", unique=true, nullable=false, length=32)
    public String getId() {
        return this.id;
    }
    
    public void setId(String id) {
        this.id = id;
    }

    
    @Column(name="dia_emision", nullable=false)
    public int getDiaEmision() {
        return this.diaEmision;
    }
    
    public void setDiaEmision(int diaEmision) {
        this.diaEmision = diaEmision;
    }

    
    @Column(name="dia_vencimiento", nullable=false)
    public int getDiaVencimiento() {
        return this.diaVencimiento;
    }
    
    public void setDiaVencimiento(int diaVencimiento) {
        this.diaVencimiento = diaVencimiento;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="fecha_creacion", length=35)
    public Date getFechaCreacion() {
        return this.fechaCreacion;
    }
    
    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="fecha_ultima_modificacion", length=35)
    public Date getFechaUltimaModificacion() {
        return this.fechaUltimaModificacion;
    }
    
    public void setFechaUltimaModificacion(Date fechaUltimaModificacion) {
        this.fechaUltimaModificacion = fechaUltimaModificacion;
    }




}

