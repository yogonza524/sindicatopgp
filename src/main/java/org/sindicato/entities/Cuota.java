package org.sindicato.entities;
// Generated 03-dic-2015 16:29:24 by Hibernate Tools 4.3.1


import java.util.Date;
import java.util.Objects;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Cuota generated by hbm2java
 */
@Entity
@Table(name="cuota"
    ,schema="public"
)
public class Cuota  implements java.io.Serializable {


     private CuotaId id;
     private Empresa empresa;
     private Date fechaEmision;
     private Date fechaVencimiento;
     private Integer cantidadEmpleados;
     private Double importe;
     private Double intereses;
     private String periodo;
     private String idEstado;
     private Date fechaCreacion;
     private Date fechaUltimaModificacion;
     private Double remuneracionTotal;

    public Cuota() {
    }

	
    public Cuota(CuotaId id, Empresa empresa, Date fechaEmision, Date fechaVencimiento, String idEstado, Date fechaCreacion, Date fechaUltimaModificacion) {
        this.id = id;
        this.empresa = empresa;
        this.fechaEmision = fechaEmision;
        this.fechaVencimiento = fechaVencimiento;
        this.idEstado = idEstado;
        this.fechaCreacion = fechaCreacion;
        this.fechaUltimaModificacion = fechaUltimaModificacion;
    }
    public Cuota(CuotaId id, Empresa empresa, Date fechaEmision, Date fechaVencimiento, Integer cantidadEmpleados, Double importe, Double intereses, String periodo, String idEstado, Date fechaCreacion, Date fechaUltimaModificacion, Double remuneracionTotal) {
       this.id = id;
       this.empresa = empresa;
       this.fechaEmision = fechaEmision;
       this.fechaVencimiento = fechaVencimiento;
       this.cantidadEmpleados = cantidadEmpleados;
       this.importe = importe;
       this.intereses = intereses;
       this.periodo = periodo;
       this.idEstado = idEstado;
       this.fechaCreacion = fechaCreacion;
       this.fechaUltimaModificacion = fechaUltimaModificacion;
       this.remuneracionTotal = remuneracionTotal;
    }
   
     @EmbeddedId

    
    @AttributeOverrides( {
        @AttributeOverride(name="id", column=@Column(name="id", nullable=false, length=32) ), 
        @AttributeOverride(name="idEmpresa", column=@Column(name="id_empresa", nullable=false, length=32) ) } )
    public CuotaId getId() {
        return this.id;
    }
    
    public void setId(CuotaId id) {
        this.id = id;
    }

@ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="id_empresa", nullable=false, insertable=false, updatable=false)
    public Empresa getEmpresa() {
        return this.empresa;
    }
    
    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }

    @Temporal(TemporalType.DATE)
    @Column(name="fecha_emision", nullable=false, length=13)
    public Date getFechaEmision() {
        return this.fechaEmision;
    }
    
    public void setFechaEmision(Date fechaEmision) {
        this.fechaEmision = fechaEmision;
    }

    @Temporal(TemporalType.DATE)
    @Column(name="fecha_vencimiento", nullable=false, length=13)
    public Date getFechaVencimiento() {
        return this.fechaVencimiento;
    }
    
    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    
    @Column(name="cantidad_empleados")
    public Integer getCantidadEmpleados() {
        return this.cantidadEmpleados;
    }
    
    public void setCantidadEmpleados(Integer cantidadEmpleados) {
        this.cantidadEmpleados = cantidadEmpleados;
    }

    
    @Column(name="importe", precision=17, scale=17)
    public Double getImporte() {
        return this.importe;
    }
    
    public void setImporte(Double importe) {
        if (importe != null) {
            long factor = (long) Math.pow(10, 2);
            importe = importe * factor;
            long tmp = Math.round(importe);
            importe = (double) tmp / factor;
        }
        this.importe = importe;
    }

    
    @Column(name="intereses", precision=17, scale=17)
    public Double getIntereses() {
        return this.intereses;
    }
    
    public void setIntereses(Double intereses) {
        this.intereses = intereses;
    }

    
    @Column(name="periodo", length=32)
    public String getPeriodo() {
        return this.periodo;
    }
    
    public void setPeriodo(String periodo) {
        this.periodo = periodo;
    }

    
    @Column(name="id_estado", nullable=false, length=32)
    public String getIdEstado() {
        return this.idEstado;
    }
    
    public void setIdEstado(String idEstado) {
        this.idEstado = idEstado;
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

//    @Column(name="remuneracion_total", precision=17, scale=17)
//    public Double getRemuneracionTotal() {
//        return this.remuneracionTotal;
//    }
//    
//    public void setRemuneracionTotal(Double remuneracionTotal) {
//        this.remuneracionTotal = remuneracionTotal;
//    }
    @Column(name="remuneracion_total", precision=17, scale=17)
    public Double getRemuneracionTotal() {
        return remuneracionTotal;
    }

    public void setRemuneracionTotal(Double remuneracionTotal) {
        this.remuneracionTotal = remuneracionTotal;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 23 * hash + Objects.hashCode(this.id);
        hash = 23 * hash + Objects.hashCode(this.empresa);
        hash = 23 * hash + Objects.hashCode(this.idEstado);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Cuota other = (Cuota) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }
    

}


