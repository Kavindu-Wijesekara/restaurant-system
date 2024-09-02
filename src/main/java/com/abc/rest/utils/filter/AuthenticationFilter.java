package com.abc.rest.utils.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthenticationFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String loginURI = req.getContextPath() + "/auth?action-type=login";
        String registerURI = req.getContextPath() + "/auth?action-type=register";
        String adminURI = req.getContextPath() + "/admin";
        String staffURI = req.getContextPath() + "/staff";
        String orderConfirmURI = req.getContextPath() + "/order/confirm";

        boolean loggedIn = session != null && session.getAttribute("id") != null;
        boolean isAdmin = loggedIn && session.getAttribute("role").equals("ADMIN");
        boolean isStaff = loggedIn && session.getAttribute("role").equals("STAFF");

        String requestURI = req.getRequestURI();
        String queryString = req.getQueryString();

        String fullRequestURI;
        if (queryString != null) {
            fullRequestURI = requestURI + "?" + queryString;
        } else {
            fullRequestURI = requestURI;
        }

        if (fullRequestURI.equals(loginURI) || fullRequestURI.equals(registerURI)) {
            if (loggedIn) {
                redirectBasedOnRole(req, res);
            } else {
                chain.doFilter(request, response);
            }
        } else if (req.getRequestURI().equals(adminURI)) {
            if (isAdmin) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(loginURI);
            }
        } else if (req.getRequestURI().equals(staffURI)) {
            if (isStaff) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(loginURI);
            }
        } else if (req.getRequestURI().equals(orderConfirmURI)) {
            if (loggedIn) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(loginURI);
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    private void redirectBasedOnRole(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String role = (String) req.getSession().getAttribute("role");
        String contextPath = req.getContextPath();

        switch (role) {
            case "ADMIN":
                res.sendRedirect(contextPath + "/admin");
                break;
            case "STAFF":
                res.sendRedirect(contextPath + "/staff");
                break;
            default:
                res.sendRedirect(contextPath + "/");
                break;
        }
    }

    @Override
    public void destroy() {}
}
