<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, blogapi.Blog" %>
<%
    String username = (String) request.getAttribute("username");
    List<Blog> blogs = (List<Blog>) request.getAttribute("blogs");
    String role = (String) request.getSession().getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        header {
            background-color: #007BFF;
            color: white;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        header .welcome {
            font-size: 18px;
        }

        header .actions {
            display: flex;
            gap: 10px;
        }

        header .actions button,
        header .actions a {
            background-color: #FF4136;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 15px;
            text-decoration: none;
            cursor: pointer;
        }

        header .actions a {
            background-color: #28a745;
        }

        header .actions button:hover {
            background-color: #E12E2E;
        }

        header .actions a:hover {
            background-color: #218838;
        }

        .container {
            padding: 20px;
        }

        .blog-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            padding: 15px;
        }

        .blog-card h3 {
            margin: 0 0 10px;
        }

        .blog-card p {
            color: #555;
        }

        .action-buttons {
            margin-top: 10px;
        }

        .update-btn, .delete-btn {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .delete-btn {
            background-color: #DC3545;
        }

        .update-btn:hover {
            background-color: #0056b3;
        }

        .delete-btn:hover {
            background-color: #b02a37;
        }

        .read-more-btn {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 15px;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
        }

        .read-more-btn:hover {
            background-color: #0056b3;
        }

        .toast {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #28a745;
            color: white;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            display: none;
            z-index: 1000;
        }

        .toast.error {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <header>
        <div class="welcome">Welcome, <%= username != null ? username : "Guest" %></div>
        <div class="actions">
            <% if ("admin".equals(role)) { %>
                <a href="/blogapi/createblog.jsp">Create Blog</a>
            <% } %>
            <form action="/blogapi/logout" method="post" style="display: inline;">
                <button type="submit">Logout</button>
            </form>
        </div>
    </header>

    <div class="container">
        <% if (blogs != null && !blogs.isEmpty()) {
            boolean canEdit = "admin".equals(role) || "editor".equals(role);
            for (Blog blog : blogs) { %>
                <div class="blog-card">
                    <h3><%= blog.getTitle() %></h3>
                    <p><%= blog.getContent().length() > 100 ? blog.getContent().substring(0, 100) + "..." : blog.getContent() %></p>
                    <a href="/blogapi/details?id=<%= blog.getId() %>" class="read-more-btn">Click Here to Read</a>
                    <% if (canEdit) { %>
                        <div class="action-buttons">
                            <% if ("admin".equals(role)) { %>
                                <form action="/blogapi/blogs" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= blog.getId() %>">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            <% } %>
                        </div>
                    <% } %>
                </div>
        <%   }
           } else { %>
            <p>No blogs available or blogs not loaded properly.</p>
        <% } %>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const toast = document.getElementById('toast');
        const blogStatus = urlParams.get('blog');

        if (blogStatus === 'deleted') {
            toast.textContent = 'Blog deleted successfully!';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        } else if (blogStatus === 'updated') {
            toast.textContent = 'Blog updated successfully!';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        } else if (blogStatus === 'published') {
            toast.textContent = 'Blog published successfully!';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        }
    </script>
</body>
</html>
