/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.business;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.sindicato.controllers.Controller;
import org.sindicato.entities.Registracion;
import org.sindicato.entities.Rol;
import org.sindicato.entities.Usuario;
import org.sindicato.enums.Order;
import org.sindicato.enums.Roles;

/**
 *
 * @author Gonza
 */
public class UsuarioController extends AbstractBusinessController<Usuario> {
    
    private Controller<Registracion> ur;
    private final static Logger LOGGER = Logger.getLogger(UsuarioController.class.getName()); 
    
    public UsuarioController(){
        super(Usuario.class);
        ur = new Controller(Registracion.class);
    }

    public Controller<Usuario> getDriver() {
        return c;
    }
    
    public boolean add(String username, String pass, String email, Roles rol){
        boolean output = false;
        if (username != null && pass != null && email != null && rol != null) {
            if (validateUsername(username)) {
                if (pass.length() > 0 && pass.length() < 41) {
                    if (email.length() > 0 && email.length() < 76) {
                        if (rol.toString().length() > 0 && rol.toString().length() < 33) {
                            System.out.println("Voy a intentar agregarlo");
                            Usuario u = new Usuario();
                            u.setId("a");
                            u.setActivo(true);
                            u.setUsername(username);
                            u.setPassword(pass);
                            u.setEmail(email);
                            u.setFechaCreacion(new Date());
                            //Creo un Rol
                            Rol r = new Rol();
                            r.setId(rol.toString());
                            u.setRol(r);
                            output = c.add(u);
                        }
                        else{
                            LOGGER.log(Level.WARNING, "Longitud del ID del rol erroneo");
                        }
                    }
                    else{
                        LOGGER.log(Level.WARNING, "Longitud del email erroneo");
                    }
                }
                else{
                    LOGGER.log(Level.WARNING, "Longitud del password erroneo");
                }
            }
            else{
                LOGGER.log(Level.WARNING, "Nombre de usuario no valido");
            }
        }
        else{
            LOGGER.log(Level.WARNING, "Usuario, password, email o rol nulo");
        }
        return output;
    }
    
    public boolean add(Usuario user){
        boolean output = false;
        if (user != null) {
            if (user.getRol() != null) {
                output = add(user.getUsername(),user.getPassword(),user.getEmail(),user.getRol().getDescripcion().equals(Roles.ADMINISTRADOR.toString())? Roles.ADMINISTRADOR : Roles.USUARIO);
            }
            else{
                output = add(user.getUsername(),user.getPassword(),user.getEmail());
            }
        }
        return output;
    }
    
    public boolean add(String username, String pass, String email){
        return this.add(username, pass, email, Roles.USUARIO);
    }
    
    public boolean deleteUsuario(String id_user){
        boolean output = false;
        if (id_user != null && id_user.length() > 0 && id_user.length() < 33) {
            Usuario u = c.byId("id", id_user);
            if (u != null) {
                output = c.remove(u);
            }
        }
        return output;
    }
    
    public boolean deleteUsuario(Usuario user){
        if (user != null) {
            return deleteUsuario(user.getId());
        }
        return false;
    }
    
    public boolean updateUsuario(Usuario user){
        boolean output = false;
        if (user != null) {
            output = c.update(user);
        }
        return output;
    }
    
    public boolean validateUsername(String username){
        String USERNAME_PATTERN = "^[a-zA-Z0-9_-]{5,32}$";
         Pattern pattern = Pattern.compile(USERNAME_PATTERN);
         Matcher matcher = pattern.matcher(username);
         return matcher.matches();
    }
    
    public Usuario login(String username, String password){
        Usuario u = null;
        if (username != null && password != null) {
            if (username.length() > 0 && username.length() < 33 && password.length() > 0 && password.length() < 33) {
                List<Criterion> restrictions = new ArrayList<>();
                restrictions.add(Restrictions.eq("username", username));
                restrictions.add(Restrictions.eq("password", encodePassword(password)));
                restrictions.add(Restrictions.eq("activo", true));
                u = c.byRestrictions(restrictions);
                if (u != null) {
                    u.setFechaUltimaModificacion(new Date());
                    c.update(u);
                }
            }
        }
        return u;
    }
    
    public Usuario loginByStoredProcedure(String username, String password){
        Usuario u = null;
        Map<String,Object> params = new HashMap<>();
        params.put("username", username);
        params.put("password", password);
        String consulta = "SELECT login(:username,:password)";
        List output = c.callProcedure(consulta, params);
        if (output != null) {
            boolean result = (boolean)output.get(0);
            if (result) {
                u = c.byId("username", username);
            }
        }
        return u;
    }
    
    public String encodePassword(String password){
        Map<String,Object> params = new HashMap<>();
        params.put("password", password);
        String query = "SELECT encode(:password)";
        List result = c.callProcedure(query, params);
        if (result != null && result.size() > 0) {
            return (String)result.get(0);
        }
        return null;
    }
    
    public Integer countUsuarios(){
        Integer output = Integer.MIN_VALUE;
        List result = c.callProcedure("SELECT count_users()", null);
        if (result != null) {
            output = (int)result.get(0);
        }
        return output;
    }
    
    public Integer countAdministradores(){
        Integer output = Integer.MIN_VALUE;
        List result = c.callProcedure("SELECT count_admins()", null);
        if (result != null) {
            output = (int)result.get(0);
        }
        return output;
    }
    
    public BigInteger countUsuariosActivos(){
        BigInteger output = BigInteger.ZERO;
        String query = "SELECT * from count_user_actives";
        List result = c.callProcedure(query, null);
        if (result != null) {
            output = (BigInteger) result.get(0);
        }
        return output;
    }
    
    public BigInteger countUsuariosInactivos(){
        BigInteger output = BigInteger.ZERO;
        String query = "SELECT * from count_user_inactives";
        List result = c.callProcedure(query, null);
        if (result != null) {
            output = (BigInteger) result.get(0);
        }
        return output;
    }
    
    public Boolean finalizoRegistro(String id_user){
        Boolean output = false;
        Registracion r = ur.byId("idUsuario", id_user);
        if (r != null) {
            output = r.getCompleto();
        }
        return output;
    }
    
    public Date ultimaConexion(String id_user){
        Date timestamp = null;
        Usuario u = c.byId("id", id_user);
        if (u != null) {
            timestamp = u.getUltimaConexion();
        }
        return timestamp;
    }
    
    public Boolean changePassword(String id_user, String password){
        Boolean output = false;
        Usuario u = c.byId("id", id_user);
        if (u != null) {
            u.setPassword(this.encodePassword(password));
            output = c.update(u);
        }
        return output;
    }
    
    public String generatePassword(int lenght){
        String output = null;
        String query = "SELECT random_string(:longitud)";
        Map<String,Object> params = new HashMap<>();
        params.put("longitud", lenght);
        List result = c.callProcedure(query, params);
        if (result != null) {
            output = String.valueOf(result.get(0));
        }
        return output;
    }
    
    public Boolean changeRandomPassword(String id_user){
        boolean output = false;
        if (id_user != null) {
            output = changePassword(id_user, generatePassword(15));
        }
        return output;
    }
    
    public Boolean isAdmin(Usuario u){
        boolean output = false;
        if (u != null) {
            output = u.getRol().getDescripcion().equals("ADMINISTRADOR");
        }
        return output;
    }
    
    public Boolean isUser(Usuario u){
        boolean output = false;
        if (u != null) {
            output = u.getRol().getDescripcion().equals("USUARIO");
        }
        return output;
    }
    
    public Boolean existEmail(String email){
        return c.byId("email", email) != null;
    }
    
    public Boolean existUsername(String username){
        return c.byId("username", username) != null;
    }
    
    public Usuario byID(String key, Object value){
        return c.byId(key, value);
    }
}
