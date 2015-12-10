package org.sindicato.entities;
// Generated 03-dic-2015 16:29:24 by Hibernate Tools 4.3.1


import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * CuotaId generated by hbm2java
 */
@Embeddable
public class CuotaId  implements java.io.Serializable {


     private String id;
     private String idEmpresa;

    public CuotaId() {
    }

    public CuotaId(String id, String idEmpresa) {
       this.id = id;
       this.idEmpresa = idEmpresa;
    }
   


    @Column(name="id", nullable=false, length=32)
    public String getId() {
        return this.id;
    }
    
    public void setId(String id) {
        this.id = id;
    }


    @Column(name="id_empresa", nullable=false, length=32)
    public String getIdEmpresa() {
        return this.idEmpresa;
    }
    
    public void setIdEmpresa(String idEmpresa) {
        this.idEmpresa = idEmpresa;
    }


   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof CuotaId) ) return false;
		 CuotaId castOther = ( CuotaId ) other; 
         
		 return ( (this.getId()==castOther.getId()) || ( this.getId()!=null && castOther.getId()!=null && this.getId().equals(castOther.getId()) ) )
 && ( (this.getIdEmpresa()==castOther.getIdEmpresa()) || ( this.getIdEmpresa()!=null && castOther.getIdEmpresa()!=null && this.getIdEmpresa().equals(castOther.getIdEmpresa()) ) );
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + ( getId() == null ? 0 : this.getId().hashCode() );
         result = 37 * result + ( getIdEmpresa() == null ? 0 : this.getIdEmpresa().hashCode() );
         return result;
   }   


}

