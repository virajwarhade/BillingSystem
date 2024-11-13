import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/process_addproduct")
public class process_addproduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/billing_system";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve product details from the request
        String productName = request.getParameter("productName");
        String productPrice = request.getParameter("productPrice");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL driver
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            if (conn != null) {
                System.out.println("Database connection established!");
            }


            // Prepare the SQL insert statement
            String sql = "INSERT INTO product (name, price) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productName);
            pstmt.setString(2, productPrice);

            // Execute the insert statement
            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("A new product was inserted successfully!");
            }

            // Redirect the user after insertion
            response.sendRedirect("jsp/success.jsp"); // Redirect to a success page

        }  catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); // This prints the stack trace to the console
            response.sendRedirect("error.jsp?message=" + e.getMessage()); // Pass the error message to the JSP
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
    }
}
