<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-200 p-2 h-full container mx-auto mt-12">
    <form method="get" action="../process_createbill" class="w-full">
    <div class="md:w-4/5 lg:w-2/4 mx-auto flex-row flex">
        <a href="../index.jsp" class="bg-white p-2 hover:bg-blue-100 active:bg-blue-200 border-b shadow mb-4 rounded-lg">
            <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 24 24">
                <path d="M 12 2.1 L 1 12 L 4 12 L 4 21 L 11 21 L 11 15 L 13 15 L 13 21 L 20 21 L 20 12 L 23 12 L 12 2.1 z M 12 4.8 L 18 10.2 L 18 11 L 18 19 L 15 19 L 15 13 L 9 13 L 9 19 L 6 19 L 6 10.2 L 12 4.8 z"></path>
            </svg>
        </a>
    </div>

    <div class="bg-white md:w-4/5 lg:w-2/4 mb-12 rounded-2xl border p-6 mx-auto my-auto shadow flex flex-col">

        <div class="text-3xl font-semibold text-gray-700 mb-8">Create Bill</div>

        <!-- Customer Details -->
        <div class="text-lg font-semibold text-gray-600 mb-1">Customer Details</div>
        <div class="w-full grid grid-cols-2 bg-gray-100 p-4 rounded-xl border gap-3 mb-6">
            <input type="text" name="c_name" required class="rounded-md border border-gray-300 hover:ring outline-0 focus:ring focus:ring-blue-700 bg-white px-2 py-1" placeholder="Customer Name" required>
            <input type="text" name="c_address" class="rounded-md border border-gray-300 hover:ring outline-0 focus:ring focus:ring-blue-700 bg-white px-2 py-1" placeholder="Customer Address" required>
            <input type="text" name="c_mob" class="rounded-md border border-gray-300 hover:ring outline-0 focus:ring focus:ring-blue-700 bg-white px-2 py-1" placeholder="Customer Mobile" required>
        </div>

        <hr class="my-4 border-gray-200 border-2">

        <!-- Add Product Section -->
        <div class="text-lg font-semibold text-gray-600 mb-1">Add Product</div>
        <div class="w-full grid grid-cols-1 bg-gray-100 p-4 rounded-xl border gap-3 mb-6">
            <select id="productSelect" class="rounded-md border border-gray-300 hover:ring outline-0 focus:ring focus:ring-blue-700 bg-white px-2 py-1">
                <% 
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                String DB_URL = "jdbc:mysql://localhost:3306/billing_system";
                String DB_USER = "root";
                String DB_PASSWORD = "";
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM product");
                    while (rs.next()) {
                        String productName = rs.getString("name");
                        String productPrice = rs.getString("price");
                %>
                <option value="<%= productName %>-<%= productPrice %>"><%= productName %> - Rs<%= productPrice %></option> 
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
            </select>
            <input type="number" id="quantityInput" class="rounded-md border border-gray-300 hover:ring outline-0 focus:ring focus:ring-blue-700 bg-white px-2 py-1" placeholder="Quantity" min="1">
            <button type="button" onclick="addProduct()" class="rounded-md w-fit mt-4 px-8 ml-auto text-white bg-blue-700 active:bg-blue-800 hover:bg-blue-500 border border-black hover:ring outline-0 focus:ring focus:ring-blue-700 px-2 py-1">Add Product</button>
        </div>

        <hr class="my-4 border-gray-200 border-2">

        <!-- Selected Products -->
        <div class="text-lg font-semibold text-gray-600 mb-1">Selected Products</div>

        

                <div id="productList" class="w-full grid grid-cols-1 bg-gray-100 p-4 rounded-xl border gap-3 mb-6">
                    <p id="emptyMessage" class="text-gray-500">No products added yet.</p>
                </div>
            
                <input type="hidden" name="productNames" id="productNames">
                <input type="hidden" name="productPrices" id="productPrices">
                <input type="hidden" name="productQuantities" id="productQuantities">
                <input type="hidden" name="productTotals" id="productTotals">
            
                <button onclick="generateBill()" class="rounded-md w-fit mt-4 px-8 ml-auto text-white bg-green-700 active:bg-green-800 hover:bg-green-500 border border-black hover:ring outline-0 focus:ring focus:ring-green-700 px-2 py-1">Generate Bill</button>
            
            

        <hr class="my-4 border-gray-200 border-2">
        
        <div class="text-lg font-semibold text-gray-600 mb-1">Total: Rs<span id="totalAmount">0</span>
        <input type="hidden" id="hiddenTotalAmount" name="subtotal" />
        </div>
 
    </div>   
</form>
    <script>
        let products = [];
        let totalAmount = 0;

        function generateBill() {
    if (products.length === 0) {
        alert('Please add products to generate a bill.');
        return;
    }

    // Prepare arrays for the form data
    let productNames = [];
    let productPrices = [];
    let productQuantities = [];
    let productTotals = [];

    // Loop through products and collect data
    products.forEach(product => {
        productNames.push(product.name);
        productPrices.push(product.price);
        productQuantities.push(product.quantity);
        productTotals.push(product.total);
    });

    // Update the hidden inputs with the values
    document.getElementById('productNames').value = productNames.join(',');
    document.getElementById('productPrices').value = productPrices.join(',');
    document.getElementById('productQuantities').value = productQuantities.join(',');
    document.getElementById('productTotals').value = productTotals.join(',');

    // Submit the form
    document.querySelector('form').submit();
}


        function addProduct() {
            const productSelect = document.getElementById('productSelect');
            const quantityInput = document.getElementById('quantityInput');
            const productInfo = productSelect.value.split('-');
            const productName = productInfo[0];
            const productPrice = parseInt(productInfo[1]);
            const quantity = parseInt(quantityInput.value);

            if (!quantity || quantity < 1) {
                alert('Please enter a valid quantity.');
                return;
            }

            const productTotal = productPrice * quantity;
            products.push({ name: productName, price: productPrice, quantity: quantity, total: productTotal });

            updateProductList();
            updateTotalAmount();

            // Reset inputs
            quantityInput.value = '';
            productSelect.selectedIndex = 0;
        }

        function updateProductList() {
            const productList = document.getElementById('productList');

            // Clear previous entries and remove empty message
            productList.innerHTML = '';

            if (products.length === 0) {
                productList.innerHTML = '<p id="emptyMessage" class="text-gray-500">No products added yet.</p>';
                return;
            }

            // Populate the list with products and create hidden fields
            products.forEach((product, index) => {
                const productItem = document.createElement('div');
                productItem.classList.add('flex', 'justify-between', 'items-center', 'bg-white', 'p-2', 'rounded', 'shadow-sm');
                productItem.innerHTML = "<div class='flex flex-row gap-2 items-center'><div class='bg-gray-100 text-lg p-1 px-4 mr-2 border rounded-lg'>"+product.name+"</div><div class='text-gray-500'>Rs</div>"+product.price+" x "+product.quantity+"</div><div class='flex flex-row gap-2'><div class='text-gray-500'>Rs</div><b>"+product.total+"</b></div>";

                productList.appendChild(productItem);

                
            });
        }

        function updateTotalAmount() {
            totalAmount = products.reduce((acc, product) => acc + product.total, 0);
            document.getElementById('totalAmount').textContent = totalAmount;
            document.getElementById('hiddenTotalAmount').value = totalAmount;
        }
    </script>

</body>
</html>
