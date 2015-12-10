/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.util.Date;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Ignore;
import org.sindicato.beans.MailBean;
import org.sindicato.beans.UtilBean;
import org.sindicato.enums.Genero;
import org.sindicato.util.Cuit;
import org.sindicato.util.EmailValidator;

/**
 *
 * @author Gonza
 */
public class UtilTest {
    
    public UtilTest() {
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
//     @Ignore
     public void cuitTest() throws Exception {
         int dni = 34093153;
         assertTrue(Cuit.validate("20-10558322-3"));
         assertEquals(Cuit.generate(Genero.MASCULINO, 17254359),"20-17254359-7");
         System.out.println("CUIT generado:" + Cuit.generate(Genero.MASCULINO, dni));
     }
     
     @Test
     @Ignore
     public void argDateTest(){
         UtilBean ub = new UtilBean();
         System.out.println(ub.argDate(new Date()));
     }
     
     @Test
     @Ignore
     public void monthByNumber(){
         UtilBean ub = new UtilBean();
         System.out.println(ub.monthByNumber(11));
     }
     
     @Test
     @Ignore
     public void monthByDate(){
         UtilBean ub = new UtilBean();
         System.out.println(ub.monthByNumber(new Date()));
     }
     
     @Test
     @Ignore
     public void simpleArgDate(){
         UtilBean ub = new UtilBean();
         System.out.println(ub.simpleArgDate(new Date()));
     }
     @Test
     @Ignore
     public void fullArgDate(){
         UtilBean ub = new UtilBean();
         System.out.println(ub.fullSimpleArgDate(new Date()));
     }
     
     @Test
     @Ignore
     public void StringToDateTest(){
         String fecha = "7 Diciembre 2015";
         String[] parts = fecha.split(" ");
         for(String s : parts){
             System.out.println(s);
         }
     }
     
     @Test
     @Ignore
     public void EmailPatternTest() throws IOException{
         EmailValidator ev = new EmailValidator();
         assertTrue(ev.validate("miguel2002fretes@yahoo.com.ar"));
     }
     
}
