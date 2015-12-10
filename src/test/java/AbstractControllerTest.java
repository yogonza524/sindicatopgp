/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.Iterator;
import java.util.List;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Ignore;
import org.sindicato.controllers.Controller;
import org.sindicato.entities.EstadoCuota;
import org.sindicato.enums.Order;

/**
 *
 * @author Gonza
 */
public class AbstractControllerTest {
    
    public AbstractControllerTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    // TODO add test methods here.
    // The methods must be annotated with annotation @Test. For example:
    //
     @Test
     @Ignore
     public void allOrderByTest() {
         Controller<EstadoCuota> cr = new Controller(EstadoCuota.class);
         List<EstadoCuota> lista = cr.allOrderBy("descripcion", Order.ASC);
         assertNotNull(lista);
         Iterator i = lista.iterator();
         while(i.hasNext()){
             EstadoCuota ec = (EstadoCuota)i.next();
             System.out.println(ec.getDescripcion());
         }
     }
}
