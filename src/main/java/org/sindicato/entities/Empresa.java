package org.sindicato.entities;
// Generated 03-dic-2015 16:29:24 by Hibernate Tools 4.3.1


import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Parameter;

/**
 * Empresa generated by hbm2java
 */
@Entity
@Table(name="empresa"
    ,schema="public"
)
public class Empresa  implements java.io.Serializable {


     private String idUsuario;
     private Usuario usuario;
     private String responsable;
     private String actividadPrincipal;
     private Date fechaInicioActividad;
     private String email;
     private String domicilio;
     private String telefonoUno;
     private String telefonoDos;
     private Date fechaEmisionProximaCuota;
     private Date fechaCreacion;
     private Date fechaUltimaModificacion;
     private String razonSocial;
     private String cuit;
     private Set cuotas = new HashSet(0);

    public Empresa() {
    }

	
    public Empresa(Usuario usuario, String responsable, String actividadPrincipal, Date fechaInicioActividad, String email, String domicilio, String razonSocial, String cuit) {
        this.usuario = usuario;
        this.responsable = responsable;
        this.actividadPrincipal = actividadPrincipal;
        this.fechaInicioActividad = fechaInicioActividad;
        this.email = email;
        this.domicilio = domicilio;
        this.razonSocial = razonSocial;
        this.cuit = cuit;
    }
    public Empresa(Usuario usuario, String responsable, String actividadPrincipal, Date fechaInicioActividad, String email, String domicilio, String telefonoUno, String telefonoDos, Date fechaEmisionProximaCuota, Date fechaCreacion, Date fechaUltimaModificacion, String razonSocial, String cuit, Set cuotas) {
       this.usuario = usuario;
       this.responsable = responsable;
       this.actividadPrincipal = actividadPrincipal;
       this.fechaInicioActividad = fechaInicioActividad;
       this.email = email;
       this.domicilio = domicilio;
       this.telefonoUno = telefonoUno;
       this.telefonoDos = telefonoDos;
       this.fechaEmisionProximaCuota = fechaEmisionProximaCuota;
       this.fechaCreacion = fechaCreacion;
       this.fechaUltimaModificacion = fechaUltimaModificacion;
       this.razonSocial = razonSocial;
       this.cuit = cuit;
       this.cuotas = cuotas;
    }
   
     @GenericGenerator(name="generator", strategy="foreign", parameters=@Parameter(name="property", value="usuario"))@Id @GeneratedValue(generator="generator")

    
    @Column(name="id_usuario", unique=true, nullable=false, length=32)
    public String getIdUsuario() {
        return this.idUsuario;
    }
    
    public void setIdUsuario(String idUsuario) {
        this.idUsuario = idUsuario;
    }

@OneToOne(fetch=FetchType.LAZY)@PrimaryKeyJoinColumn
    public Usuario getUsuario() {
        return this.usuario;
    }
    
    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    
    @Column(name="responsable", nullable=false, length=75)
    public String getResponsable() {
        return this.responsable;
    }
    
    public void setResponsable(String responsable) {
        this.responsable = responsable;
    }

    
    @Column(name="actividad_principal", nullable=false, length=75)
    public String getActividadPrincipal() {
        return this.actividadPrincipal;
    }
    
    public void setActividadPrincipal(String actividadPrincipal) {
        this.actividadPrincipal = actividadPrincipal;
    }

    @Temporal(TemporalType.DATE)
    @Column(name="fecha_inicio_actividad", nullable=false, length=13)
    public Date getFechaInicioActividad() {
        return this.fechaInicioActividad;
    }
    
    public void setFechaInicioActividad(Date fechaInicioActividad) {
        this.fechaInicioActividad = fechaInicioActividad;
    }

    
    @Column(name="email", nullable=false, length=75)
    public String getEmail() {
        return this.email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }

    
    @Column(name="domicilio", nullable=false, length=75)
    public String getDomicilio() {
        return this.domicilio;
    }
    
    public void setDomicilio(String domicilio) {
        this.domicilio = domicilio;
    }

    
    @Column(name="telefono_uno", length=20)
    public String getTelefonoUno() {
        return this.telefonoUno;
    }
    
    public void setTelefonoUno(String telefonoUno) {
        this.telefonoUno = telefonoUno;
    }

    
    @Column(name="telefono_dos", length=20)
    public String getTelefonoDos() {
        return this.telefonoDos;
    }
    
    public void setTelefonoDos(String telefonoDos) {
        this.telefonoDos = telefonoDos;
    }

    @Temporal(TemporalType.DATE)
    @Column(name="fecha_emision_proxima_cuota", length=13)
    public Date getFechaEmisionProximaCuota() {
        return this.fechaEmisionProximaCuota;
    }
    
    public void setFechaEmisionProximaCuota(Date fechaEmisionProximaCuota) {
        this.fechaEmisionProximaCuota = fechaEmisionProximaCuota;
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

    
    @Column(name="razon_social", nullable=false, length=75)
    public String getRazonSocial() {
        return this.razonSocial;
    }
    
    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    
    @Column(name="cuit", nullable=false, length=13)
    public String getCuit() {
        return this.cuit;
    }
    
    public void setCuit(String cuit) {
        this.cuit = cuit;
    }

@OneToMany(fetch=FetchType.LAZY, mappedBy="empresa")
    public Set getCuotas() {
        return this.cuotas;
    }
    
    public void setCuotas(Set cuotas) {
        this.cuotas = cuotas;
    }




}


