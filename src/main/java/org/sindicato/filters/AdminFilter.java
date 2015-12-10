/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.filters;

import java.io.IOException;
import javax.faces.context.FacesContext;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.sindicato.business.UsuarioController;
import org.sindicato.entities.Usuario;
import org.sindicato.enums.Pages;

/**
 *
 * @author Gonza
 */
public class AdminFilter implements Filter{

    @Override
    public void init(FilterConfig fc) throws ServletException {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain fc) throws IOException, ServletException {
        FacesContext ctx = FacesContext.getCurrentInstance();
        HttpServletRequest context = (HttpServletRequest)request;
        Usuario u = (Usuario) context.getSession().getAttribute("user");
        if (u != null) {
            UsuarioController uc = new UsuarioController();
            if (uc.isAdmin(u)) {
                fc.doFilter(request, response);
            }
            else{
                redirectToIndex(request, response);
            }
        }
        else{
            redirectToIndex(request, response);
        }
    }

    @Override
    public void destroy() {
        
    }
    
    private void redirectToIndex(ServletRequest request,ServletResponse response ) throws IOException{
        ((HttpServletResponse)response).sendRedirect(((HttpServletRequest)request).getContextPath() + Pages.INDEX.toString());
    }
}
