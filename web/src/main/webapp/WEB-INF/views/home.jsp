<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
        }
        h1 {
            color: #333;
            margin-bottom: 1rem;
            font-size: 2.5rem;
        }
        .message {
            color: #666;
            font-size: 1.2rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        .time {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            color: #495057;
            font-family: 'Courier New', monospace;
            margin-bottom: 2rem;
        }
        .nav {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .nav a {
            background: #007bff;
            color: white;
            padding: 0.75rem 1.5rem;
            text-decoration: none;
            border-radius: 25px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .nav a:hover {
            background: #0056b3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,123,255,0.3);
        }
        .tech-info {
            margin-top: 2rem;
            padding: 1rem;
            background: #e9ecef;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #495057;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${title}</h1>
        <div class="message">${message}</div>
        
        <div class="time">
            <strong>현재 시간:</strong> ${currentTime}
        </div>
        
        <div class="nav">
            <a href="/">홈</a>
        </div>
        
        <div class="tech-info">
            <strong>기술 스택:</strong> Spring Boot 3.3.4 | Java 21 | JSP | Maven
        </div>
    </div>
</body>
</html>
