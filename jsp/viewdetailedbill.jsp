<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>


<!doctype html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>

<style>
    @media print
{    
    .no-print, .no-print *
    {
        display: none !important;
    }

    .pad-0{
        padding: 0px;
        margin: 0px;
    }


}
</style>

</head>
<body class="bg-gray-200  h-fit container mx-auto mt-12 pad-0 mb-12 p-4 px-6">





  <%
    String billId = request.getParameter("id");
    String c_name = "";
    String total = "";

    List<String> productNames = new ArrayList<>();
    List<String> productPrices = new ArrayList<>();
    List<String> productQuantities = new ArrayList<>();
    List<String> productTotals = new ArrayList<>();

    // Database connection
    String DB_URL = "jdbc:mysql://localhost:3306/billing_system";
    String DB_USER = "root";
    String DB_PASSWORD = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

      // Prepared statement to retrieve bill data
      String query = "SELECT c_name, total, product_name, product_price, product_quantity, product_total FROM bill WHERE id = ?";
      pstmt = conn.prepareStatement(query);
      pstmt.setString(1, billId);
      rs = pstmt.executeQuery();

      // Fetch the data
      while (rs.next()) {
        c_name = rs.getString("c_name");
        total = rs.getString("total");

        String[] names = rs.getString("product_name").split(",");
        String[] prices = rs.getString("product_price").split(",");
        String[] quantities = rs.getString("product_quantity").split(",");
        String[] totals = rs.getString("product_total").split(",");

        for (String name : names) {
            productNames.add(name.trim());
        }
        for (String price : prices) {
            productPrices.add(price.trim());
        }
        for (String quantity : quantities) {
            productQuantities.add(quantity.trim());
        }
        for (String totalVal : totals) {
            productTotals.add(totalVal.trim());
        }
      }

    } catch (Exception e) {
      e.printStackTrace();
      out.println("Error: " + e.getMessage());
    } finally {
      try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  %>




























    <div class="md:w-4/5 lg:w-3/4  mx-auto flex-row flex no-print" >
        <a href="../index.jsp" class="bg-white p-2 hover:bg-blue-100 active:bg-blue-200 border-b   shadow  mb-4 rounded-lg "><svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="35" height="35" viewBox="0 0 24 24"><path d="M 12 2.0996094 L 1 12 L 4 12 L 4 21 L 11 21 L 11 15 L 13 15 L 13 21 L 20 21 L 20 12 L 23 12 L 12 2.0996094 z M 12 4.7910156 L 18 10.191406 L 18 11 L 18 19 L 15 19 L 15 13 L 9 13 L 9 19 L 6 19 L 6 10.191406 L 12 4.7910156 z"></path></svg>
        </a>

        <a href="viewbill.jsp" class="bg-white flex items-center justify-center p-2 ml-4 hover:bg-blue-100 active:bg-blue-200 border-b   shadow  mb-4 rounded-lg "><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#000000"><path d="m313-440 224 224-57 56-320-320 320-320 57 56-224 224h487v80H313Z"/></svg>
        </a>

        <button onclick="window.print()" class="bg-white flex items-center justify-center p-2 px-6 font-semibold ml-4 hover:bg-blue-100 active:bg-blue-200 border-b   shadow  mb-4 rounded-lg ">print
        </button>
    </div>
    


    



    <div class="border border-gray-300 rounded-2xl border-2 bg-white w-full">
        <div class="py-4 p-2">
          <div class="px-14 py-6">
            <table class="w-full border-collapse border-spacing-0">
              <tbody>
                <tr>
                  <td class="w-full align-top">
                    <div>
                      <img src="https://raw.githubusercontent.com/templid/email-templates/main/templid-dynamic-templates/invoice-02/brand-sample.png" class="h-12" />
                    </div>
                  </td>
    
                  <td class="align-top">
                    <div class="text-sm">
                      <table class="border-collapse border-spacing-0">
                        <tbody>
                          <tr>
                            <td class="border-r pr-4">
                              <div>
                                <p class="whitespace-nowrap text-slate-400 text-right">Date</p>
                                <p class="whitespace-nowrap font-bold text-main text-right">April 26, 2023</p>
                              </div>
                            </td>
                            <td class="pl-4">
                              <div>
                                <p class="whitespace-nowrap text-slate-400 text-right">Invoice #</p>
                                <p class="whitespace-nowrap font-bold text-main text-right"><%= billId %></p>
                              </div>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
    
          <div class="bg-slate-100 px-14 py-6 text-sm">
            <table class="w-full border-collapse border-spacing-0">
              <tbody>
                <tr>
                  <td class="w-1/2 align-top">
                    <div class="text-sm text-neutral-600">
                      <p class="font-bold">Supplier Company INC</p>
                      <p>Number: 23456789</p>
                      <p>VAT: 23456789</p>
                      <p>6622 Abshire Mills</p>
                      <p>Port Orlofurt, 05820</p>
                      <p>United States</p>
                    </div>
                  </td>
                  <td class="w-1/2 align-top text-right">
                    <div class="text-sm text-neutral-600">
                      <p class="font-bold">Customer Company</p>
                      <p><%= c_name %></p>
                      <p>Number: 123456789</p>
                      <p>VAT: 23456789</p>
                      <p>9552 Vandervort Spurs</p>
                      <p>Paradise, 43325</p>
                      <p>United States</p>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
    
          <div class="px-14 py-10 text-sm text-neutral-700">
            <table class="w-full border-collapse border-spacing-0">
              <thead>
                <tr>
                  <td class="border-b-2 border-main pb-3 pl-3 font-bold text-main">#</td>
                  <td class="border-b-2 border-main pb-3 pl-2 font-bold text-main">Product details</td>
                  <td class="border-b-2 border-main pb-3 pl-2 text-right font-bold text-main">Price</td>
                  <td class="border-b-2 border-main pb-3 pl-2 text-center font-bold text-main">Qty.</td>

                  <td class="border-b-2 border-main pb-3 pl-2 pr-3 text-right font-bold text-main">Subtotal </td>
                </tr>
              </thead>
              <tbody>




                <%
                for (int i = 0; i < productNames.size(); i++) {
                %>
                  <tr>
                    <td class="border-b py-3 pl-3"><%= i + 1 %>.</td>
                    <td class="border-b py-3 pl-2"><%= productNames.get(i) %></td>
                    <td class="border-b py-3 pl-2 text-right">Rs <%= productPrices.get(i) %></td>
                    <td class="border-b py-3 pl-2 text-center"><%= productQuantities.get(i) %></td>
                    <td class="border-b py-3 pl-2 pr-3 text-right">Rs <%= productTotals.get(i) %></td>
                  </tr>
                <%
                  }
                %>


                
                <tr>
                  <td colspan="7">
                    <table class="w-full border-collapse border-spacing-0">
                      <tbody>
                        <tr>
                          <td class="w-full"></td>
                          <td>
                            <table class="w-full border-collapse border-spacing-0">
                              <tbody>

                                <tr>
                                  <td class="p-3">
                                    <div class="whitespace-nowrap text-slate-400">grand total:</div>
                                  </td>
                                  <td class="p-3 text-right">
                                    <div class="whitespace-nowrap font-bold text-main"><%= total %></div>
                                  </td>
                                </tr>
                                <tr>
                                  <td class="bg-main p-3">
                                    <div class="whitespace-nowrap font-bold text-white">Total:</div>
                                  </td>
                                  <td class="bg-main p-3 text-right">
                                    
                                  </td>
                                  
                                </tr>
                              </tbody>
                            </table>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
    
          <div class="px-14 text-sm text-neutral-700">
            <p class="text-main font-bold">PAYMENT DETAILS</p>
            <p>Banks of Banks</p>
            <p>Bank/Sort Code: 1234567</p>
            <p>Account Number: 123456678</p>
            <p>Payment Reference: BRA-00335</p>
          </div>
    
          <div class="px-14 py-10 text-sm text-neutral-700">
            <p class="text-main font-bold">Notes</p>
            <p class="italic">Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries
              for previewing layouts and visual mockups.</p>
            </dvi>
    
            
          </div>
        </div>






</body>
</html>

























































