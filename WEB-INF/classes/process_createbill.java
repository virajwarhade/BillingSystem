import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/process_createbill")
public class process_createbill extends HttpServlet {
    private static final long serialVersionUID = 1L;

        // Database credentials
        private static final String DB_URL = "jdbc:mysql://localhost:3306/billing_system";
        private static final String DB_USER = "root";
        private static final String DB_PASSWORD = "";



    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        PreparedStatement pstmt = null;


        // Fetch parameters from the request (now as comma-separated values)
        String[] productNames = request.getParameter("productNames").split(",");
        String[] productPrices = request.getParameter("productPrices").split(",");
        String[] productQuantities = request.getParameter("productQuantities").split(",");
        String[] productTotals = request.getParameter("productTotals").split(",");
        String subtotal = request.getParameter("subtotal");



        String c_name = request.getParameter("c_name");
        String c_address = request.getParameter("c_address");
        String c_mob = request.getParameter("c_mob");




        out.println("<html><body>");
        out.println("<h1>Bill Summary</h1>");

        if (productNames != null && productNames.length > 0) {
            out.println("<table border='1'>");
            out.println("<tr><th>Product Name</th><th>Price</th><th>Quantity</th><th>Total</th></tr>");
            
            // Loop through the products and display them in a table
            for (int i = 0; i < productNames.length; i++) {
                out.println("<tr>");
                out.println("<td>" + productNames[i] + "</td>");
                out.println("<td>Rs " + productPrices[i] + "</td>");
                out.println("<td>" + productQuantities[i] + "</td>");
                out.println("<td>Rs " + productTotals[i] + "</td>");
                out.println("</tr>");
            }
            out.println("subtotal: "+subtotal);








            try {
            // Establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL driver
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            if (conn != null) {
                System.out.println("Database connection established!");
            }


            // Prepare the SQL insert statement
            String sql = "INSERT INTO bill (product_name,product_price,product_quantity,product_total, total,c_name,c_address,c_mob) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, request.getParameter("productNames"));
            pstmt.setString(2, request.getParameter("productPrices"));
            pstmt.setString(3, request.getParameter("productQuantities"));
            pstmt.setString(4, request.getParameter("productTotals"));
            pstmt.setString(5, request.getParameter("subtotal"));

            pstmt.setString(6, request.getParameter("c_name"));
            pstmt.setString(7, request.getParameter("c_address"));
            pstmt.setString(8, request.getParameter("c_mob"));


            


            // Execute the insert statement
            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                out.println("A new product was inserted successfully!");

            }

            // Redirect the user after insertion
            response.sendRedirect("jsp/success.jsp"); // Redirect to a success page

        }  catch (SQLException e) {
           
             // This prints the stack trace to the console
            
            out.println("sql error");
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();

            // Print the stack trace to the response output
            out.println("<pre>" + stackTrace + "</pre>");

        }catch(ClassNotFoundException e){
           
            
            out.println("ClassNotFoundException error");
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();

            // Print the stack trace to the response output
            out.println("<pre>" + stackTrace + "</pre>");
        }
         finally {
            // Clean up resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }











            
            out.println("</table>");
        } else {
            out.println("<p>No products were selected.</p>");
        }

        out.println("</body></html>");
    }
}
