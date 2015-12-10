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
import javax.servlet.http.HttpSession;
import org.sindicato.business.UsuarioController;
import org.sindicato.entities.Usuario;
import org.sindicato.enums.Pages;

/**
 *
 * @author Gonza
 */
public class IndexFilter implements Filter{

    private FilterConfig config;
    
    @Override
    public void init(FilterConfig fc) throws ServletException {
        config = fc;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain fc) throws IOException, ServletException {
//        FacesContext ctx = FacesContext.getCurrentInstance();
//        HttpServletRequest context = (HttpServletRequest)request;
//        Usuario u = (Usuario) context.getSession().getAttribute("user");
//        if (u != null) {
//            UsuarioController uc = new UsuarioController();
//            if (uc.isUser(u)) {
//                ((HttpServletResponse)response).sendRedirect(((HttpServletRequest)request).getContextPath() + Pages.USER_HOME.toString());
//            }
//            else{
//                ((HttpServletResponse)response).sendRedirect(((HttpServletRequest)request).getContextPath() + Pages.ADMIN_HOME.toString());
//            }
//        }
//        fc.doFilter(request, response);
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession();
        Usuario u = (Usuario)session.getAttribute("user");
        if (u != null) {
            config.getServletContext().getRequestDispatcher("/" + Pages.USER_HOME.toString()).forward(request, response);
            return;
//            ((HttpServletResponse)response).sendRedirect(((HttpServletRequest)request).getContextPath() + "/" + Pages.USER_HOME.toString());
        }
        else{
            fc.doFilter(request, response);
            return;
        }
    }

    @Override
    public void destroy() {
        config = null;
    }
    
}
