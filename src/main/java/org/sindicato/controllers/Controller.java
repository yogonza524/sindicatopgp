/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.controllers;

/**
 *
 * @author Gonza
 */
public class Controller<T> extends AbstractController<T> {
    
        private Class<T> type;
    
        public Controller(Class<T> type){
            this.type = type;
        }

    public Controller() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Class<T> classResult() {
        return type;
    }
    
}
