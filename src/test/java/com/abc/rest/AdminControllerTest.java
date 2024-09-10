package com.abc.rest;


import com.abc.rest.controllers.AdminController;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.io.StringWriter;


import static org.mockito.Mockito.*;

public class AdminControllerTest {

    private AdminController adminController;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher requestDispatcher;
    private HttpSession session;

    @Before
    public void setUp() {
        adminController = new AdminController();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        requestDispatcher = mock(RequestDispatcher.class);
        session = mock(HttpSession.class);

        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
    }

    @Test
    public void testAdminHomePage() throws Exception {
        when(request.getRequestURI()).thenReturn("/admin");

        adminController.doGet(request, response);

        verify(request).getRequestDispatcher("WEB-INF/view/admin.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testListAllStaffUsers() throws Exception {
        when(request.getRequestURI()).thenReturn("/admin/staff");

        adminController.doGet(request, response);

        verify(request).getRequestDispatcher("WEB-INF/view/admin/staff.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDisplayCreateStaffUserForm() throws Exception {
        when(request.getRequestURI()).thenReturn("/admin/staff");
        when(request.getParameter("action")).thenReturn("create-staff-user");

        adminController.doGet(request, response);

        verify(request).getRequestDispatcher("WEB-INF/view/admin/new-staff-form.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testCreateStaffUser() throws Exception {
        when(request.getRequestURI()).thenReturn("/admin/staff");
        when(request.getParameter("action")).thenReturn("create-staff-user");
        when(request.getParameter("name")).thenReturn("New User");
        when(request.getParameter("email")).thenReturn("newuser@example.com");
        when(request.getParameter("password")).thenReturn("password123");

        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        adminController.doPost(request, response);

        verify(response).sendRedirect("/admin/staff");
    }

    @Test
    public void testGenerateReports() throws Exception {

        when(request.getRequestURI()).thenReturn("/admin/reports");

        adminController.doGet(request, response);

        verify(request).getRequestDispatcher("WEB-INF/view/admin/reports.jsp");
        verify(requestDispatcher).forward(request, response);
    }
}