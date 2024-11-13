
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>



<!doctype html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-200 p-2 h-full container mx-auto mt-12">









    <div class="md:w-4/5 lg:w-3/4  mx-auto flex-row flex">
        <a href="../index.jsp" class="bg-white p-2 hover:bg-blue-100 active:bg-blue-200 border-b   shadow  mb-4 rounded-lg "><svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="35" height="35" viewBox="0 0 24 24"><path d="M 12 2.0996094 L 1 12 L 4 12 L 4 21 L 11 21 L 11 15 L 13 15 L 13 21 L 20 21 L 20 12 L 23 12 L 12 2.0996094 z M 12 4.7910156 L 18 10.191406 L 18 11 L 18 19 L 15 19 L 15 13 L 9 13 L 9 19 L 6 19 L 6 10.191406 L 12 4.7910156 z"></path></svg>
        </a>
    </div>
    





    <div class="bg-white md:w-4/5 mt-6 lg:w-3/4 rounded-2xl border p-6 mx-auto  shadow flex flex-col">

        <div class="text-3xl font-semibold text-gray-700 mb-8">
            Inventory Products
        </div>


        <div class="w-full grid grid-cols-4 bg-gray-100 p-4 rounded-xl border gap-y-2">
            
            <div class="text-xl text-center">Bill id</div>
            <div class="text-xl text-center">customer name</div>
            <div class="text-xl text-center">total</div>
            <div class="text-xl text-center">view</div>

            <hr class="border-gray-400"><hr class="border-gray-400"><hr class="border-gray-400"><hr class="border-gray-400">

            <%
            // Establish connection to the database
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            // Database credentials
            String DB_URL = "jdbc:mysql://localhost:3306/billing_system";
            String DB_USER = "root";
            String DB_PASSWORD = "";

            try {
                // Load the JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                // Execute query to fetch product
                stmt = conn.createStatement();
                String query = "SELECT * FROM bill";
                rs = stmt.executeQuery(query);

                // Display results
                while (rs.next()) {
                    String id = rs.getString("id");
                    String c_name = rs.getString("c_name");
                    String total = rs.getString("total");
                    
                    


        %>



        <div class="text-md text-center bg-white "><%= id %></div>
        <div class="text-md text-center bg-white "><%= c_name %></div>
        <div class="text-md text-center bg-white "><%= total %></div>
        <a href="viewdetailedbill.jsp?id=<%= id %>" class="text-md text-center bg-white hover:text-blue-700">view</a>

                       
                       
                    
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("Error: " + e.getMessage());
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>





            



        </div>



    </div>








</body>
</html>