package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class BlogDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int blogId = Integer.parseInt(request.getParameter("id"));
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String title = "Blog Not Found";
        String content = "The requested blog could not be found.";

        try {
        	
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/blogging_db", "root", "vamsi");
            String query = "SELECT title, content FROM blogs WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, blogId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                title = rs.getString("title");
                content = rs.getString("content");
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>" + title + "</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 0; padding: 0; }");
        out.println(".container { max-width: 800px; margin: 20px auto; padding: 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); border-radius: 8px; background-color: #f9f9f9; }");
        out.println("h1 { font-size: 2em; margin-bottom: 20px; }");
        out.println("p { line-height: 1.6; }");
        out.println(".back-btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background-color: #007BFF; color: white; text-decoration: none; border-radius: 5px; }");
        out.println(".back-btn:hover { background-color: #0056b3; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>" + title + "</h1>");
        out.println("<p>" + content + "</p>");
        out.println("<a href='/blogapi/blogs' class='back-btn'>Back to Home</a>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
