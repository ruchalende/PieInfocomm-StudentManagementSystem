<%-- 
    Document   : dashboard
    Created on : Dec 26, 2021, 2:57:31 PM
    Author     : rucha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
        String first_name=(String)session.getAttribute("first_name"); 
        String last_name=(String) session.getAttribute("last_name"); 
        String email=(String) session.getAttribute("email"); 
        
    Connection con = null;  
    Statement stmt = null;
    ResultSet rs = null;
    //int userid = Integer.parseInt(request.getParameter("userid"));
    String msg = (String) request.getAttribute("msg"); 
    int userid=(Integer) request.getAttribute("userid");
    if(msg!=null && msg!=""){ 
  
%> <script>
    var msg = " <%=msg %> ";
        if(msg!==""){
            alert(msg);
        }
    </script>
         
         <%
    }
        
    String usertype = (String) request.getAttribute("usertype"); 
    Class.forName("com.mysql.jdbc.Driver");
    con =DriverManager.getConnection      //opens the connection
    ("jdbc:mysql://127.0.0.1:3306/ruchalende_studentmanangement","root","");    //parameters
    stmt = con.createStatement();   //creates Statement object to send SQL statements to DB
    
            String admin="admin";
            String teacher="teacher";
            String student="student";  %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <% if(usertype.equals(admin)==true){ %>
        <title>Admin Dashboard</title>
        <% } else if(usertype.equals(student)==true){ %>
        <title>Student Dashboard</title>
        <% } else { %>
        <title>Teacher Dashboard</title>
        <% } %>
    </head>
    <body>
        <form method="post" action="LogoutUser" >
            <input type="hidden" name="usertype" value="<%=usertype%>">
            <input type="submit" value="Logout">
        </form>
<%
    if((usertype.equals(admin)==true)){
    String sql="SELECT * FROM admin where id="+userid;
    rs = stmt.executeQuery(sql);   
%>

        <% if(email!=""){
            
         %>
         <label><center><h2>Hello <%=first_name+" "+last_name %> </h2></center> </label><br>
        
        <% 
            }
            //get list of all classes- SELECT * from classes
            ResultSet class_rs=null;
            String sql2="SELECT * FROM classes;";
            class_rs = stmt.executeQuery(sql2);
            int year=0;
            int branch_id=0;
            %>
        <table style="border:3px solid midnightblue">
            <br><br><br><br><label><strong>TEACHER DETAILS</strong></label><br><br>
            <tr><th style="border:3px solid midnightblue">TEACHER FIRST NAME</th><th style="border:3px solid midnightblue">TEACHER LAST NAME</th><th style="border:3px solid midnightblue">TEACHER EMAIL</th>
                <!-- following the should be in while list of classes -->
                <% while(class_rs.next()){
                    year=class_rs.getInt("year");
                    branch_id=class_rs.getInt("branch_id");
                 %>
                <th style="border:3px solid midnightblue"><%=year+"_"+branch_id %></th>
                <% } %>
            </tr>
            <%
                
                String teacher_first_name=null;
                String teacher_last_name=null;
                String teacher_email=null;
                ResultSet teacher_rs=null;
                Statement st=null;
                st = con.createStatement();
                String sql3="SELECT * FROM teachers;";
                teacher_rs = st.executeQuery(sql3);
                while(teacher_rs.next()){
                teacher_first_name=teacher_rs.getString("first_name");
                teacher_last_name=teacher_rs.getString("last_name");
                teacher_email=teacher_rs.getString("email");   
            %>
                <tr>
                    <td style="border:3px solid midnightblue"> <%= teacher_first_name %> </td>
                    <td style="border:3px solid midnightblue"> <%= teacher_last_name %> </td>
                    <td style="border:3px solid midnightblue"> <%= teacher_email %> </td>
                    <!-- while -->
                    <% class_rs = stmt.executeQuery(sql2);
                        while(class_rs.next()){ %>
                    <td style="border:3px solid midnightblue"> <input type="checkbox" name="chkteacher"></td>
                <% } %>
                </tr>
            <%
                
                }   %>
                <form action="DeleteRecord" method="post">
                    Enter Email To Delete Records:&nbsp&nbsp&nbsp
                    <input type="text" name="fetch">
                    <input type="hidden" name="usertype" value="<%=usertype%>">
                    <input type="hidden" name="userid" value="<%=userid%>">
                    <input type="hidden" name="first_name" value="<%=first_name%>">
                    <input type="hidden" name="last_name" value="<%=last_name%>">
                    <input type="hidden" name="email" value="<%=email%>">
                    <input type="submit" name="submit" value="submit">
                    <br><br>
                </form>
                <%
            ResultSet student_rs=null;
            String sql4="SELECT * FROM student;";
            student_rs = stmt.executeQuery(sql4);
            %>
            </table>
            <br><br><br><br><label><strong>STUDENT DETAILS</strong></label><br><br>
        <table style="border:3px solid midnightblue" padding="5px">
        <tr><th style="border:3px solid midnightblue">STUDENT FIRST NAME</th><th style="border:3px solid midnightblue">STUDENT LAST NAME</th><th style="border:3px solid midnightblue">STUDENT EMAIL</th></tr>
        <%
                
                String student_first_name=null;
                String student_last_name=null;
                String student_email=null;
                int student_class=0;
                while(student_rs.next()){
                student_first_name=student_rs.getString("first_name");
                student_last_name=student_rs.getString("last_name");
                student_email=student_rs.getString("email"); 
                student_class=Integer.parseInt(student_rs.getString("class"));
            %>
                <tr>
                    <td style="border:3px solid midnightblue"> <%= student_first_name %> </td>
                    <td style="border:3px solid midnightblue"> <%= student_last_name %> </td>
                    <td style="border:3px solid midnightblue"> <%= student_email %> </td>
                    <td style="border:3px solid midnightblue"> <%= student_class %> </td>
                </tr>
        <% 
            }
}
            else if(usertype.equals(student)==true){
            int stu_class=(Integer) session.getAttribute("class");
            ResultSet stu=null;
            String sql5="SELECT * FROM student where id="+userid;
            stu = stmt.executeQuery(sql5);
                if(email!=""){
        %>
        
        <label>STUDENT DETAILS</label><br>
        <label>Hello <%=first_name+" "+last_name %> </label><br>
        <label>First Name:<%=first_name%></label><br>
        <label>Last Name:<%=last_name%></label><br>
        <label>Email:<%=email%></label><br>
        <label>Class:<%=stu_class%></label><br>
        <%
            }
}
        
        else if(usertype.equals(teacher)==true){
            ResultSet teach=null;
            String sql6="SELECT * FROM teachers where id="+userid;
            teach = stmt.executeQuery(sql6);
            String teacher_class="";
            //int student_class=0;
            while(teach.next()){
                teacher_class=teach.getString("classes");  
}
         if(email!=""){
            
         %>
        <label>Hello <%=first_name+" "+last_name %> </label><br>
            <label>TEACHER DETAILS</label><br>
        <label>First Name:<%=first_name%></label><br>
        <label>Last Name:<%=last_name%></label><br>
        <label>Email:<%=email%></label><br>
        <label>Class:<%=teacher_class%></label><br>
        <%
            }
            //show list of students from the class allocated to teacher
//get branch and class from teacher table and then get list of students from that branch and class
        }

        else{
         out.print("not a valid user");
        }
%>
        </body>
        
</html>
