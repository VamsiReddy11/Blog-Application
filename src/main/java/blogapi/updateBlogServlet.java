package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class updateBlogServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/blogging_db";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vamsi";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.html?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createBlog(request, response);
        } else if ("update".equals(action)) {
            updateBlog(request, response);
        } else {
            response.sendRedirect("/blogapi/blogs?error=invalidAction");
        }
    }

    private void createBlog(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int authorId = Integer.parseInt(request.getParameter("author_id"));

        String query = "INSERT INTO blogs (title, content, author_id) VALUES (?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, authorId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("/blogapi/blogs?blog=created");
            } else {
                response.sendRedirect("/blogapi/blogs?error=creationFailed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/blogapi/blogs?error=creationFailed");
        }
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int blogId = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        String query = "UPDATE blogs SET title = ?, content = ? WHERE id = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, blogId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("/blogapi/blogs?blog=updated");
            } else {
                response.sendRedirect("/blogapi/blogs?error=updateFailed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/blogapi/blogs?error=updateFailed");
        }
    }

    private Blog getBlogById(int blogId) {
        String query = "SELECT b.id, b.title, b.content, b.author_id, u.username AS author_name " +
                       "FROM blogs b " +
                       "JOIN users u ON b.author_id = u.id " +
                       "WHERE b.id = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, blogId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setTitle(rs.getString("title"));
                    blog.setContent(rs.getString("content"));
                    blog.setAuthorId(rs.getInt("author_id"));
                    blog.setAuthorName(rs.getString("author_name"));
                    return blog;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
