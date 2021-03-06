package org.sindicato.entities;
// Generated 03-dic-2015 16:29:24 by Hibernate Tools 4.3.1


import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * EstadoCuota generated by hbm2java
 */
@Entity
@Table(name="estado_cuota"
    ,schema="public"
    , uniqueConstraints = @UniqueConstraint(columnNames="nombre") 
)
public class EstadoCuota  implements java.io.Serializable {


     private String id;
     private String nombre;
     private String descripcion;

    public EstadoCuota() {
    }

	
    public EstadoCuota(String id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }
    public EstadoCuota(String id, String nombre, String descripcion) {
       this.id = id;
       this.nombre = nombre;
       this.descripcion = descripcion;
    }
   
     @Id 

    
    @Column(name="id", unique=true, nullable=false, length=32)
    public String getId() {
        return this.id;
    }
    
    public void setId(String id) {
        this.id = id;
    }

    
    @Column(name="nombre", unique=true, nullable=false, length=32)
    public String getNombre() {
        return this.nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    
    @Column(name="descripcion")
    public String getDescripcion() {
        return this.descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }




}


