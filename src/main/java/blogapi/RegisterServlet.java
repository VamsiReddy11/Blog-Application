package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/blogging_db";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vamsi";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        try {
            String plainPassword = PasswordUtil.getPlainPassword(password);

            boolean isRegistered = registerUser(username, plainPassword, firstName, lastName, email, role);

            if (isRegistered) {
                response.sendRedirect("login.html?success=true");
            } else {
                response.sendRedirect("register.html?error=true");
            }
        } catch (Exception e) {
            if (e instanceof SQLIntegrityConstraintViolationException) {
                
                response.sendRedirect("register.html?error=duplicate");
            } else {
                
                e.printStackTrace();
                response.sendRedirect("register.html?error=true");
            }
        }

    }

    private boolean registerUser(String username, String plainPassword, String firstName, String lastName, String email, String role) {
        String query = "INSERT INTO users (username, password, firstName, lastName, email, role, isActive) VALUES (?, ?, ?, ?, ?, ?, 1)";
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, plainPassword);
            stmt.setString(3, firstName);
            stmt.setString(4, lastName);
            stmt.setString(5, email);
            stmt.setString(6, role);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Connection getConnection() throws SQLException {
        try {
            System.out.println("Loading MySQL driver...");
            System.out.println("Classpath: " + System.getProperty("java.class.path"));

            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("MySQL Driver not found.", e);
        }
        System.out.println("Connecting to the database...");
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }


}
