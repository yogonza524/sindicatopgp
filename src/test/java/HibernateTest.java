/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.math.BigInteger;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.jboss.logging.Logger;
import org.joda.time.DateTime;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Ignore;
import org.sindicato.business.ConfigController;
import org.sindicato.business.CuotaController;
import org.sindicato.business.EmpresaController;
import org.sindicato.business.EstadoCuotaController;
import org.sindicato.business.MensajesController;
import org.sindicato.business.RegistracionController;
import org.sindicato.business.UsuarioController;
import org.sindicato.controllers.Controller;
import org.sindicato.entities.Cuota;
import org.sindicato.entities.CuotaId;
import org.sindicato.entities.Empresa;
import org.sindicato.entities.Mensaje;
import org.sindicato.entities.Registracion;
import org.sindicato.entities.Usuario;
import org.sindicato.enums.Roles;

/**
 *
 * @author Gonza
 */
public class HibernateTest {
    
    private UsuarioController uc;
    private RegistracionController rc;
    private Controller<Usuario> driver;
    private Logger LOGGER;
    private EmpresaController ec = new EmpresaController(Empresa.class);
    private EstadoCuotaController ecc = new EstadoCuotaController();
    private ConfigController cc = new ConfigController();
    private CuotaController cuotac = new CuotaController(Cuota.class);
    
    public HibernateTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
        uc = new UsuarioController();
        driver = new Controller(Usuario.class);
        rc = new RegistracionController();
        LOGGER = Logger.getLogger(HibernateTest.class);
    }
    
    @After
    public void tearDown() {
    }

    // TODO add test methods here.
    // The methods must be annotated with annotation @Test. For example:
    //
     @Test
     @Ignore
     public void primerTest() {
         Controller<Usuario> uc = new Controller(Usuario.class);
         Usuario u = uc.byId("id","b07f19eceaa67f48581d9babfe2a1b5c");
         if (u != null) {
             u.setPassword("anda!!!");
             if (uc.update(u)) {
                 System.out.println("Usuario modificado y guardado");
             }
         }
         
     }
     
     @Test
     @Ignore
     public void addUserTest(){
         uc = new UsuarioController();
         assertTrue("No se agregó el usuario",uc.add("Gonzaloo1", "buenisimo", "gonza@gmail.com", Roles.ADMINISTRADOR));
     }
     
     @Test
     @Ignore
     public void removeUserTest(){
         assertTrue("No se pudo eliminar",uc.deleteUsuario("d0c92e2f086b22b11c94721a15975a08"));
     }
     
     @Test
     @Ignore
     public void updateTest(){
         Usuario u = new Usuario();
         u.setId("b8bc20cd2db355a67e32f898dbb8eb1f");
         u.setUsername("Gonzalo");
         u.setPassword("copado");
         u.setEmail("yogonza525@gmail.com");
         assertTrue("No se pudo modificar",uc.updateUsuario(u));
     }
     
     @Test
     @Ignore
     public void loginTest(){
         assertNotNull("Login fallido", uc.login("Gonzalo", "copado"));
     }
     
     @Test
     @Ignore
     public void loginProcedureTest(){
         assertNotNull(uc.loginByStoredProcedure("Gonzalo", "copado"));
     }
     
     @Test
     @Ignore
     public void countUsuariosTest(){
         Integer count = uc.countUsuarios();
         assertFalse(count.equals(Integer.MIN_VALUE));
         System.out.println("Cantidad de usuarios: " + count);
     }
     
     @Test
     @Ignore
     public void countAdministradoresTest(){
         Integer count = uc.countAdministradores();
         assertFalse(count.equals(Integer.MIN_VALUE));
         System.out.println("Cantidad de administradores: " + count);
     }
     
     @Test
     @Ignore
     public void registroCompletoTest(){
         String id_user = "b8bc20cd2db355a67e32f898dbb8eb1f";
         assertTrue(uc.finalizoRegistro(id_user));
     }
     
     @Test
     @Ignore
     public void ultimaConexionTest(){
         String id_user = "b8bc20cd2db355a67e32f898dbb8eb1f";
         Date timestamp = uc.ultimaConexion(id_user);
         assertNotNull(timestamp);
         System.out.println("El usuario se logueó por ultima vez: " + timestamp);
     }
     
     @Test
     @Ignore
     public void changePasswordTest(){
         String id_user = "b8bc20cd2db355a67e32f898dbb8eb1f";
         String new_password = "rrrr";
         Boolean result = uc.changePassword(id_user, new_password);
         assertTrue(result);
         System.out.println(result);
     }
     
     @Test
     @Ignore
     public void lastCreatedTest(){
         UsuarioController uc = new UsuarioController();
         Usuario last = uc.lastCreated();
         assertNotNull(last);
         System.out.println("Creado el: " + last.getFechaCreacion());
     }
     
     @Test
     @Ignore
     public void empresaTest(){
         Controller<Empresa> ce = new Controller(Empresa.class);
         Empresa e = new Empresa();
         e.setResponsable("Gonzalo Mendoza");
         e.setCuit("20-34093153-0");
         e.setDomicilio("Bº Pujol M4 C7");
         e.setEmail("yogonza524@gmail.com");
         e.setRazonSocial("Div ID Software");
         e.setActividadPrincipal("Desarrollo Web");
         e.setFechaInicioActividad(new Date());
         //Load the user
         Usuario u = new Usuario();
         u.setId("1c92f19e769168e269fc4e404b1f0820");
         e.setUsuario(u);
         assertTrue(ce.add(e));
     }
     
     @Test
     @Ignore
     public void mensajeTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         assertTrue(mc.addMensaje("gonza", "yogonza524@gmail.com", "Testeando"));
     }
     
     @Test
     @Ignore
     public void mensajesNoLeidosTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         List noLeidos = mc.noLeidos();
         assertNotNull(noLeidos);
         Iterator i = noLeidos.iterator();
         while(i.hasNext()){
             Mensaje m = (Mensaje)i.next();
             System.out.println(m.getNombre());
         }
     }
     
     @Test
     @Ignore
     public void leerMensajeTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         assertTrue(mc.leer("580132d15a57607d72ef8f36d5e6f424"));
     }
     
     @Test
     @Ignore
     public void leerMensajeByObjectTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         Mensaje m = new Mensaje();
         m.setId("580132d15a57607d72ef8f36d5e6f424");
         assertTrue(mc.leer(m));
     }
     
     @Test
     @Ignore
     public void updateMensajeTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         Mensaje m = new Mensaje();
         m.setId("580132d15a57607d72ef8f36d5e6f424");
         m.setFechaCreacion(new Date());
         m.setFechaUltimaModificacion(new Date());
         m.setEmail("yogonza524@gmail.com");
         m.setNombre("Gonzalo");
         m.setContenido("Contenido cambiado");
         m.setLeido(true);
         assertTrue(mc.modificarMensaje(m));
     }
     
     @Test
     @Ignore
     public void deleteMensajeObject(){
         MensajesController mc = new MensajesController(Mensaje.class);
         Mensaje m = new Mensaje();
         m.setId("580132d15a57607d72ef8f36d5e6f424");
         m.setFechaCreacion(new Date());
         m.setFechaUltimaModificacion(new Date());
         m.setEmail("yogonza524@gmail.com");
         m.setNombre("Gonzalo");
         m.setContenido("Contenido cambiado");
         m.setLeido(true);
         assertTrue(mc.eliminarMensaje(m));
     }
     
     @Test
     @Ignore
     public void deleteMensajeId(){
         MensajesController mc = new MensajesController(Mensaje.class);
         assertTrue(mc.eliminarMensaje("cfc40034fb2db51025be3548362b8d4c"));
     }
     
     @Test
     @Ignore
     public void generatePasswordTest(){
         UsuarioController uc = new UsuarioController();
         int lenght = 15;
         String result = uc.generatePassword(lenght);
         assertNotNull(result);
         System.out.println("Password de longitud " + lenght + ": " + result);
     }
     
     @Test
     @Ignore
     public void changeRandomPassword(){
         UsuarioController uc = new UsuarioController();
         assertTrue(uc.changeRandomPassword("439d131f7eca88d3ecb9c6a5cad708a2"));
     }
     
     @Test
     @Ignore
     public void isFromuserTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         assertTrue(mc.isFromUser("e1b6bf37d50be699334f442e876af81c"));
     }
     
     @Test
     @Ignore
     public void allFromUserTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         List<Mensaje> mensajes = mc.allFromUser();
         Iterator i = mensajes.iterator();
         while(i.hasNext()){
             Mensaje m = (Mensaje)i.next();
             System.out.println(m.getEmail());
         }
     }
     
     @Test
     @Ignore
     public void allFromUnknownTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         List<Mensaje> mensajes = mc.allFromUnknown();
         Iterator i = mensajes.iterator();
         while(i.hasNext()){
             Mensaje m = (Mensaje)i.next();
             System.out.println(m.getEmail());
         }
     }
     
     @Test
     @Ignore
     public void cantidadTipoMensajes(){
         MensajesController mc = new MensajesController(Mensaje.class);
         BigInteger cantidad = mc.cantidadMensajesUsuarios();
         assertTrue(cantidad != BigInteger.ZERO);
         System.out.println("Hay " + cantidad + " usuarios registrados que enviaron mensajes");
     }
     
     @Test
     @Ignore
     public void cantidadTipoMensajesDesconocidosTest(){
         MensajesController mc = new MensajesController(Mensaje.class);
         BigInteger cantidad = mc.cantidadMensajesUsuariosDesconocidos();
//         assertTrue(cantidad != BigInteger.ZERO);
         System.out.println("Hay " + cantidad + " usuarios desconocidos que enviaron mensajes");
     }
     
     @Test
     @Ignore
     public void cantidadUsuariosActivosTest(){
         System.out.println(uc.countUsuariosActivos());
     }
     
     @Test
     @Ignore
     public void cantidadUsuariosInactivosTest(){
         System.out.println(uc.countUsuariosInactivos());
     }
     
     @Test
     @Ignore
     public void cuotasPendientesTest(){
         CuotaController cc = new CuotaController(Cuota.class);
         Cuota c = cc.pendiente("439d131f7eca88d3ecb9c6a5cad708a2");
         assertNotNull(c);
         System.out.println("Su cuota vence el " + c.getFechaVencimiento());
     }
     
     @Test
     @Ignore
     public void listaAvisadasTest(){
         CuotaController cc = new CuotaController(Cuota.class);
         List<Cuota> cuotas = cc.gestionadas("439d131f7eca88d3ecb9c6a5cad708a2");
         assertNotNull(cuotas);
         Iterator i = cuotas.iterator();
         while(i.hasNext()){
             Cuota c = (Cuota)i.next();
             System.out.println("ID: " + c.getId().getId());
         }
     }
     
     @Test
     @Ignore
     public void cuotaConRemuneracionTest(){
         CuotaController cc = new CuotaController(Cuota.class);
         Cuota c = cc.pendiente("439d131f7eca88d3ecb9c6a5cad708a2");
     }
     
     @Test
     @Ignore
     public void getAvisadoTest(){
         EstadoCuotaController ecc = new EstadoCuotaController();
         assertNotNull(ecc.getAvisado());
         System.out.println(ecc.getAvisado().getId());
     }
     
     @Test
     @Ignore
     public void registerTest(){
         UsuarioController uc = new UsuarioController();
         assertTrue(uc.add("humen", "copado", "alguien@humen.net"));
     }
     
     @Test
     @Ignore
     public void existMail(){
         UsuarioController uc = new UsuarioController();
         assertTrue(uc.existEmail("humen@arnet.net"));
     }
     
     @Test
     @Ignore
     public void isAdminTest(){
         UsuarioController uc = new UsuarioController();
         Usuario u = uc.login("Gonza", "lJ8CRdpW3X");
         System.out.println(u.getRol().getDescripcion());
         assertTrue(uc.isAdmin(u));
     }
     
     @Test
     @Ignore
     public void generateNextEmisionTest(){
         ConfigController cc = new ConfigController();
         Date emision = cc.generateFechaEmision();
         assertNotNull(cc.generateFechaEmision());
         System.out.println(emision);
     }
     
     @Test
     @Ignore
     public void addCuotaTest(){
         EmpresaController ec = new EmpresaController(Empresa.class);
         CuotaController cc = new CuotaController(Cuota.class);
         EstadoCuotaController ecc = new EstadoCuotaController();
         Empresa e = ec.byId("259706262757c736fabc8a2b36b7d9b6");
         assertNotNull(e);
         Cuota c = new Cuota();
         CuotaId id = new CuotaId();
         id.setIdEmpresa(e.getIdUsuario());
         
         c.setCantidadEmpleados(0);
         c.setEmpresa(e);
         c.setFechaCreacion(new Date());
         c.setFechaEmision(new Date());
         c.setFechaUltimaModificacion(new Date());
         c.setFechaVencimiento(new Date());
         c.setIdEstado(ecc.getPendiente().getId());
         c.setId(id);
         c.setImporte(0.0);
         c.setRemuneracionTotal(0.0);
         c.setPeriodo("");
         c.setIntereses(0.0);
         
         assertTrue(cc.add(c));
     }
     
     @Test
     @Ignore
     public void iterateTest(){
         EmpresaController ec = new EmpresaController(Empresa.class);
         Iterator i = ec.all().iterator();
         while(i.hasNext()){
             Empresa e = (Empresa)i.next();
             System.out.println(e.getRazonSocial());
         }
     }
     
     @Test
     @Ignore
     public void listDescTest(){
         CuotaController cc = new CuotaController(Cuota.class);
         Iterator i = cc.listDesc("259706262757c736fabc8a2b36b7d9b6").iterator();
         while(i.hasNext()){
             Cuota c = (Cuota)i.next();
             System.out.println(c.getId().getId());
         }
     }
     
     @Test
     @Ignore
     public void isPendienteTest(){
         CuotaController cc = new CuotaController(Cuota.class);
         EmpresaController ec = new EmpresaController(Empresa.class);
         EstadoCuotaController ecc = new EstadoCuotaController();
         Empresa e = ec.byId("259706262757c736fabc8a2b36b7d9b6");
         Iterator i = cc.list(e.getIdUsuario()).iterator();
         DateTime now = new DateTime(new Date());
         while(i.hasNext()){
             Cuota c = (Cuota)i.next();
             DateTime vencimiento = new DateTime(c.getFechaVencimiento());
             if (ecc.isPendiente(c) && vencimiento.isBefore(now)) {
                 c.setIdEstado(ecc.getVencido().getId());
                 if (cc.update(c)) {
                     System.out.println("Actualizacion existosa");
                 }
                 else{
                     System.out.println("Error al actualizar");
                 }
                 break;
             }
             
         }
     }
     
     @Test
     @Ignore
     public void cronTest(){
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
            Iterator cuotas = concuota.listDesc(e.getIdUsuario()).iterator();
            while(cuotas.hasNext()){
                Cuota cuota = (Cuota)cuotas.next();
                LOGGER.log(Logger.Level.INFO, "Cuota inspeccionada: " + cuota.getId().getId());
                DateTime vencimiento = new DateTime(cuota.getFechaVencimiento());
                if (ecc.isPendiente(cuota)) {
                    LOGGER.log(Logger.Level.INFO, "Pendiente: " + ecc.isPendiente(cuota));
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
     
     @Test
     @Ignore
     public void generateCuotaTest(){
         LOGGER.log(Logger.Level.INFO, "Generando pendientes - fecha " + new Date());
        DateTime now = new DateTime(new Date()); //Obtengo la hora actual
        EmpresaController ec = new EmpresaController(Empresa.class);
        EstadoCuotaController ecc = new EstadoCuotaController();
        ConfigController cc = new ConfigController();
        CuotaController cuotac = new CuotaController(Cuota.class);
        Iterator i = ec.all().iterator();
        while(i.hasNext()){
            Empresa e = (Empresa)i.next();
            DateTime nextEmision = new DateTime(e.getFechaEmisionProximaCuota());
            if (nextEmision.isBefore(now)) {
                
                LOGGER.log(Logger.Level.INFO, "Fecha de emisión: " + nextEmision.toString());
                LOGGER.log(Logger.Level.INFO, "Fecha actual: " + now.toString());
                
                //Actualizo la fecha de la siguiente emision
                e.setFechaEmisionProximaCuota(cc.generateFechaEmision());
                if (ec.update(e)) {
                    LOGGER.log(Logger.Level.INFO, "Empresa " + e.getIdUsuario() + " actualizada");
                    
                    //Emito una nueva cuota
                    Cuota c = new Cuota();
                    CuotaId id = new CuotaId();
                    id.setIdEmpresa(e.getIdUsuario());

                    c.setCantidadEmpleados(0);
    //                c.setEmpresa(e);
                    c.setFechaCreacion(new Date());
                    c.setFechaEmision(new Date());
                    c.setFechaUltimaModificacion(new Date());
                    c.setFechaVencimiento(new Date());
                    c.setIdEstado(ecc.getPendiente().getId());
                    c.setId(id);
                    c.setImporte(0.0);
                    c.setRemuneracionTotal(0.0);
                    c.setPeriodo("");
                    c.setIntereses(0.0);
                    if (cuotac.add(c)) {
                    LOGGER.log(Logger.Level.INFO, "Cuota nueva agregada");
                    }
                    else{
                        LOGGER.log(Logger.Level.INFO, "Error al agregar");
                    }
                }
                else{
                    LOGGER.log(Logger.Level.INFO, "Empresa " + e.getIdUsuario() + ": Actualización fallida");
                }
            }
        }
     }
     
     @Test
     @Ignore
     public void generatePendienteTest(){
         generatePendiente();
     }
     
     @Test
     @Ignore
     public void addCuotaProcedureTest(){
         CuotaController cc = new CuotaController(Cuota.class);
         assertTrue(cc.generateCuotaProcedure("dcc8bc31404b7fad19486409422cbb15"));
     }
     
     @Test
     @Ignore
     public void generateCuotaNuevaTest(){
         CuotaController cc = new CuotaController(Cuota.class);
         assertTrue(cc.generateCuota("91009653ba1016b60a92ca6ee12eec48"));
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
                    
                    e.setFechaEmisionProximaCuota(cc.generateFechaEmision());
                    
                    LOGGER.log(Logger.Level.INFO, "No tiene cuotas pendientes y la fecha de emision ya pasó, intentaré agregar una nueva");
                    Cuota c = new Cuota();
                    CuotaId id = new CuotaId();
//                    id.setIdEmpresa(e.getIdUsuario());
                    c.setId(id);
                    c.setEmpresa(e);
                    c.setCantidadEmpleados(0);
                    c.setFechaCreacion(new Date());
                    c.setFechaEmision(new Date());
                    c.setFechaUltimaModificacion(new Date());
                    c.setFechaVencimiento(new Date());
                    c.setIdEstado(ecc.getPendiente().getId());
                    c.setPeriodo("");
                    c.setRemuneracionTotal(0.0);
                    c.setIntereses(0.0);
                    c.setImporte(0.0);
                    
                    if (cuotac.add(c)) {
                        //Cuota generada
                        LOGGER.log(Logger.Level.INFO, "Cuota nueva generada");
                        e.setFechaEmisionProximaCuota(cc.generateFechaEmision());
                        if (ec.update(e)) {
                            LOGGER.log(Logger.Level.INFO, "Fecha de emision siguiente actualizada");
                        }
                        else{
                            LOGGER.log(Logger.Level.INFO, "Error al actualizar la fecha de emision siguiente");
                        }
                    }
                    else{
                        LOGGER.log(Logger.Level.INFO, "Error al generar la nueva cuota");
                    }
                }
                else{
                    LOGGER.log(Logger.Level.INFO, "La fecha de emisión aun no ha llegado");
                }
            }
        }
    }
}
