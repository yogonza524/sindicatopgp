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
 * Mensaje generated by hbm2java
 */
@Entity
@Table(name="mensaje"
    ,schema="public"
)
public class Mensaje  implements java.io.Serializable {


     private String id;
     private Date fechaCreacion;
     private Date fechaUltimaModificacion;
     private String contenido;
     private String nombre;
     private String email;
     private boolean leido;

    public Mensaje() {
    }

    public Mensaje(String id, Date fechaCreacion, Date fechaUltimaModificacion, String contenido, String nombre, String email, boolean leido) {
       this.id = id;
       this.fechaCreacion = fechaCreacion;
       this.fechaUltimaModificacion = fechaUltimaModificacion;
       this.contenido = contenido;
       this.nombre = nombre;
       this.email = email;
       this.leido = leido;
    }
   
     @Id 

    
    @Column(name="id", unique=true, nullable=false, length=32)
    public String getId() {
        return this.id;
    }
    
    public void setId(String id) {
        this.id = id;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="fecha_creacion", nullable=false, length=35)
    public Date getFechaCreacion() {
        return this.fechaCreacion;
    }
    
    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="fecha_ultima_modificacion", nullable=false, length=35)
    public Date getFechaUltimaModificacion() {
        return this.fechaUltimaModificacion;
    }
    
    public void setFechaUltimaModificacion(Date fechaUltimaModificacion) {
        this.fechaUltimaModificacion = fechaUltimaModificacion;
    }

    
    @Column(name="contenido", nullable=false)
    public String getContenido() {
        return this.contenido;
    }
    
    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    
    @Column(name="nombre", nullable=false, length=75)
    public String getNombre() {
        return this.nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    
    @Column(name="email", nullable=false, length=75)
    public String getEmail() {
        return this.email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }

    
    @Column(name="leido", nullable=false)
    public boolean isLeido() {
        return this.leido;
    }
    
    public void setLeido(boolean leido) {
        this.leido = leido;
    }




}

