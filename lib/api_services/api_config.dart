class ApiConfig {
  static const String baseUrl = 'http://192.168.0.127';
  static const String auth = '/Inventory/auth.php';
  static const String stockCount = '/Inventory/total_productcount.php';
  static const String vendorCount = '/Inventory/vendor_count.php';
  static const String employeeCount = '/Inventory/employee_count.php';
  static const String chartData = '/Inventory/chart_data.php';
  static const String stockOutRevenue = '/Inventory/stockout_revenue.php';
  static const String addInventory = '/Inventory/add_inventory.php';
  static const String fetchVendor = '/Inventory/fetch_vendor.php';
  static const String addVendor = '/Inventory/add_vendor.php';
  static const String fetchProducts = '/Inventory/fetch_products.php';
  static const String updateProduct = '/Inventory/update_product.php';
  static const String deleteProduct = '/Inventory/delete_product.php';
  static const String addEmployee = '/Inventory/add_employee.php';
  static const String employeeList = '/Inventory/fetch_employees.php';
  static const String dispatchItems = '/Inventory/dispatch.php';
  static const String fetchDispatch = '/Inventory/get_dispatched_products.php';
  static const String saveBox = '/api/save_box.php';
  static const String getBox = '/api/get_box.php';
  static const String boxUpdate = '/api/update_box.php';
}
