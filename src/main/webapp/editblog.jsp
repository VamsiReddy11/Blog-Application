<%@ page import="blogapi.Blog" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Blog</title>
</head>
<body>
    <h1>Edit Blog</h1>
    
    <!-- Fetch the blog based on ID -->
    <c:if test="${not empty blog}">
        <form action="blogs?action=update" method="post">
            <input type="hidden" name="id" value="${blog.id}">
            
            <label for="title">Title</label>
            <input type="text" name="title" id="title" value="${blog.title}" required><br>
            
            <label for="content">Content</label>
            <textarea name="content" id="content" required>${blog.content}</textarea><br>
            
            <input type="submit" value="Update Blog">
        </form>
    </c:if>
    
    <c:if test="${empty blog}">
        <p>Blog not found.</p>
    </c:if>

</body>
</html>
