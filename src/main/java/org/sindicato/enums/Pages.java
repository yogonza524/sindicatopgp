/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.enums;

/**
 *
 * @author Gonza
 */
public enum Pages {
    
    INDEX{
        @Override
        public String toString(){
            return "index.xhtml";
        }
    },
    USER_HOME{
        @Override
        public String toString(){
            return "pages/u/user_home.xhtml";
        }
    },
    ADMIN_HOME{
        @Override
        public String toString(){
            return "pages/a/admin_home.xhtml";
        }
    },
    SIN_EMPRESA{
        @Override
        public String toString(){
            return "pages/u/sin_empresa.xhtml";
        }
    }
}
