/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.util;

import java.util.Objects;
import org.sindicato.enums.Genero;

/**
 *
 * @author Gonza
 */
public class Cuit {
    
        public static boolean validate(String cuit){
            //Eliminamos todos los caracteres que no son números
            cuit = cuit.replaceAll("[^\\d]", "");
            //Controlamos si son 11 números los que quedaron, si no es el caso, ya devuelve falso
            if (cuit.length() != 11){
                return false;
            }
            //Convertimos la cadena que quedó en una matriz de caracteres
            String[] cuitArray = cuit.split("");
            //Inicializamos una matriz por la cual se multiplicarán cada uno de los dígitos
            Integer[] serie = {5, 4, 3, 2, 7, 6, 5, 4, 3, 2};
            //Creamos una variable auxiliar donde guardaremos los resultados del calculo del número validador
            Integer aux = 0;
            //Recorremos las matrices de forma simultanea, sumando los productos de la serie por el número en la misma posición
            try {
                for (int i=0; i<10; i++){
                    if (!cuitArray[i].isEmpty()) {
                        aux += Integer.valueOf(cuitArray[i]) * serie[i];
                    }
                }
            } catch (Exception e) {
                for(int i=0; i < 10; i++){
                    System.out.println("Valor: '" + cuitArray[i] + "', Valor de la serie a multiplicar: " + serie[i]);
                }
                 e.printStackTrace();
            }
            //Hacemos como se especifica: 11 menos el resto de de la división de la suma de productos anterior por 11
            aux = 11 - (aux % 11);
            //Si el resultado anterior es 11 el código es 0
            if (aux == 11){
                aux = 0;
            //o si el resultado anterior es 10 el código es 9
            } else if (aux == 10){
                aux = 9;
            }
            //Devuelve verdadero si son iguales, falso si no lo son
            //(Esta forma esta dada para prevenir errores, se puede usar: return Integer.valueOf(cuitArray[11]) == aux;)
            return Objects.equals(Integer.valueOf(cuitArray[10]), aux);
        }
    
        public static String generate(Genero g,int dni) throws Exception{
            int tipo;
            if (g.equals(Genero.MASCULINO)) {
                tipo = 20;
            }
            else{
                if (g.equals(Genero.FEMENINO)) {
                    tipo = 27;
                }
                else{
                    tipo = 30;
                }
            }
            String aux = String.valueOf(tipo) + String.valueOf(dni);
            String[] cuitArray = aux.split("");
            int codigo = 0;
            if (aux.length() != 10) {
                throw new Exception("Sexo o DNI no valido. La longitud no corresponde");
            }
            Integer[] serie = {5, 4, 3, 2, 7, 6, 5, 4, 3, 2};
            for (int i=0; i<10; i++){
                codigo += Integer.valueOf(cuitArray[i]) * serie[i];
            }
            codigo = 11 - (codigo % 11);
            //Si el resultado anterior es 11 el código es 0
            if (codigo == 11){
                codigo = 0;
            //o si el resultado anterior es 10 el código es 9
            } else if (codigo == 10){
                codigo = 9;
            }
            return tipo + "-" + dni + "-" + codigo;
        }
}
