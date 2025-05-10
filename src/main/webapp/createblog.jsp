<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="blogapi.Blog" %>
<%
    String role = (String) request.getSession().getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("unauthorized.html");
        return;
    }

    Blog blogToEdit = (Blog) request.getAttribute("blog");
    String successMessage = (String) request.getAttribute("successMessage");  // Fetch success message
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= blogToEdit == null ? "Create Blog" : "Edit Blog" %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 5px;
            color: #555;
        }

        input[type="text"], textarea {
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
            height: 150px;
        }

        button {
            background-color: #007BFF;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #0056b3;
        }

        .back-link {
            display: block;
            margin-top: 15px;
            text-align: center;
            text-decoration: none;
            color: #007BFF;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        /* Toast Styles */
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

        .toast.show {
            visibility: visible;
            animation: fadein 0.5s, fadeout 0.5s 3s;
        }

        @keyframes fadein {
            from {bottom: 0; opacity: 0;}
            to {bottom: 30px; opacity: 1;}
        }

        @keyframes fadeout {
            from {opacity: 1;}
            to {opacity: 0;}
        }
    </style>
</head>
<body>
    <div class="container">
        <h1><%= blogToEdit == null ? "Create a New Blog" : "Edit Blog" %></h1>
        <form action="/blogapi/blogs" method="post">
            <% if (blogToEdit != null) { %>
                
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= blogToEdit.getId() %>">
            <% } else { %>
                
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="author_id" value="<%= request.getSession().getAttribute("user_id") %>">
            <% } %>

            <label for="title">Blog Title:</label>
            <input 
                type="text" 
                id="title" 
                name="title" 
                placeholder="Enter blog title" 
                value="<%= blogToEdit != null ? blogToEdit.getTitle() : "" %>" 
                required
            >

            <label for="content">Content:</label>
            <textarea 
                id="content" 
                name="content" 
                placeholder="Write your blog content here..." 
                required
            ><%= blogToEdit != null ? blogToEdit.getContent() : "" %></textarea>

            <button type="submit"><%= blogToEdit == null ? "Publish Blog" : "Update Blog" %></button>
        </form>
        <a href="/blogapi/blogs" class="back-link">Back to Home</a>
    </div>

    
    <div id="toast" class="toast">
        Blog posted successfully
    </div>
	<div class="toast" id="toast"></div>

    <script>
        
        const urlParams = new URLSearchParams(window.location.search);
        const toast = document.getElementById('toast');

        const blogStatus = urlParams.get('blog');
            if (blogStatus === 'updated') {
            toast.textContent = 'Blog updated successfully!';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        }
    </script>
    <script>
    // Show toast notification based on URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const toast = document.getElementById('toast');

    const blogStatus = urlParams.get('blog');
    if (blogStatus === 'created') {
        toast.textContent = 'Blog created successfully!';
        toast.style.display = 'block';
        setTimeout(() => toast.style.display = 'none', 3000);
    } else if (blogStatus === 'updated') {
        toast.textContent = 'Blog updated successfully!';
        toast.style.display = 'block';
        setTimeout(() => toast.style.display = 'none', 3000);
    }
</script>
    
    
</body>
</html>
