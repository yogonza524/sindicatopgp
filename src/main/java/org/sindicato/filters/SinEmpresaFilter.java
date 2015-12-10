/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sindicato.filters;

import java.io.IOException;
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
public class SinEmpresaFilter implements Filter{

    @Override
    public void init(FilterConfig fc) throws ServletException {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain fc) throws IOException, ServletException {
        HttpServletResponse httpres = (HttpServletResponse) response;
        HttpServletRequest httpreq = (HttpServletRequest) request;
        //Take the URI
        String uri = httpreq.getRequestURI();
        Usuario u = (Usuario)httpreq.getSession().getAttribute("user");
        UsuarioController uc = new UsuarioController();
        if (u != null && uc.isUser(u) && u.getEmpresa() != null) {
            httpres.sendRedirect(httpreq.getContextPath() + "/" +Pages.USER_HOME.toString());
        }
        fc.doFilter(request, response);
    }

    @Override
    public void destroy() {
        
    }
    
}
