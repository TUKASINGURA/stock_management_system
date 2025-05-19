import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Dashboard modules
  final List<DashboardModule> allModules = [
    DashboardModule('Inventory', Icons.inventory, '/inventory'),
    DashboardModule('Sales', Icons.point_of_sale, '/sales'),
    DashboardModule('Reports', Icons.bar_chart, '/reports'),
    DashboardModule('Suppliers', Icons.local_shipping, '/suppliers'),
    DashboardModule('Customers', Icons.people, '/customers'),
    DashboardModule('Settings', Icons.settings, '/settings'),
    DashboardModule('Help', Icons.help, '/help'),
    DashboardModule('Orders', Icons.list_alt, '/orders'),
  ];

  // Sample data
  final List<StockItem> lowStockItems = [
    StockItem('Milk', 5, 20, Icons.local_drink),
    StockItem('Bread', 3, 15, Icons.bakery_dining),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => Navigator.pushNamed(context, '/help'),
            tooltip: 'Help',
          ),
        ],
      ),
      drawer: _buildMainDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummaryCards(isLargeScreen),
            SizedBox(height: 20),

            // Quick Access Modules
            Text('Quick Access Modules',
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildModuleGrid(),
            SizedBox(height: 20),

            // Low Stock Items
            _buildStockSection('Low Stock Items', lowStockItems),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onBottomNavTap(index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add-item'),
        tooltip: 'Add New Item',
      ),
    );
  }

  Widget _buildMainDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 10),
                Text('Admin Richard',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('admin@stock.com', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          ExpansionTile(
            leading: Icon(Icons.point_of_sale),
            title: Text('Sales Management'),
            children: [
              _createDrawerItem(
                  'Sales Dashboard', Icons.dashboard, '/sales-dashboard'),
              _createDrawerItem('Order Management', Icons.list_alt, '/orders'),
              _createDrawerItem(
                  'Customer Management', Icons.people, '/customers'),
              _createDrawerItem('Invoicing', Icons.receipt, '/invoices'),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.inventory),
            title: Text('Inventory Management'),
            children: [
              _createDrawerItem(
                  'Stock Tracking', Icons.track_changes, '/stock-tracking'),
              _createDrawerItem(
                  'Replenishment', Icons.restart_alt, '/replenishment'),
              _createDrawerItem(
                  'Product Management', Icons.shopping_bag, '/products'),
              _createDrawerItem(
                  'Barcode Scanning', Icons.qr_code_scanner, '/barcode'),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.local_shipping),
            title: Text('Supplier Management'),
            children: [
              _createDrawerItem('Suppliers', Icons.account_box, '/suppliers'),
              _createDrawerItem(
                  'Purchase Orders', Icons.shopping_cart, '/purchase-orders'),
              _createDrawerItem('Returns', Icons.assignment_return, '/returns'),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.analytics),
            title: Text('Reporting'),
            children: [
              _createDrawerItem(
                  'Sales Reports', Icons.show_chart, '/sales-reports'),
              _createDrawerItem(
                  'Stock Reports', Icons.stacked_bar_chart, '/stock-reports'),
              _createDrawerItem('Financial Reports', Icons.attach_money,
                  '/financial-reports'),
            ],
          ),
          Divider(),
          _createDrawerItem('Settings', Icons.settings, '/settings'),
          _createDrawerItem('Help', Icons.help, '/help'),
          _createDrawerItem('Logout', Icons.exit_to_app, '/logout'),
        ],
      ),
    );
  }

  Widget _createDrawerItem(String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildSummaryCards(bool isLargeScreen) {
    return isLargeScreen
        ? Row(
            children: [
              _buildSummaryCard(
                  'Total Products', '1,245', Icons.shopping_bag, Colors.blue),
              SizedBox(width: 16),
              _buildSummaryCard(
                  'Low Stock', '23', Icons.warning, Colors.orange),
              SizedBox(width: 16),
              _buildSummaryCard(
                  'Sales Today', '\$5,432', Icons.attach_money, Colors.green),
              SizedBox(width: 16),
              _buildSummaryCard(
                  'Pending Orders', '15', Icons.pending, Colors.purple),
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: _buildSummaryCard('Total Products', '1,245',
                          Icons.shopping_bag, Colors.blue)),
                  SizedBox(width: 16),
                  Expanded(
                      child: _buildSummaryCard(
                          'Low Stock', '23', Icons.warning, Colors.orange)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _buildSummaryCard('Sales Today', '\$5,432',
                          Icons.attach_money, Colors.green)),
                  SizedBox(width: 16),
                  Expanded(
                      child: _buildSummaryCard('Pending Orders', '15',
                          Icons.pending, Colors.purple)),
                ],
              ),
            ],
          );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.grey)),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children:
          allModules.take(6).map((module) => _buildModuleCard(module)).toList(),
    );
  }

  Widget _buildModuleCard(DashboardModule module) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, module.route),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(module.icon, size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                module.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockSection(String title, List<StockItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              child: Text('View All'),
              onPressed: () => Navigator.pushNamed(context, '/inventory'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Card(
          elevation: 2,
          child: Column(
            children: items.map((item) => _buildStockListItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStockListItem(StockItem item) {
    final percentage = (item.currentQuantity / item.maxQuantity) * 100;
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(item.icon, color: Colors.blue),
      ),
      title: Text(item.name),
      subtitle: LinearProgressIndicator(
        value: item.currentQuantity / item.maxQuantity,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(
          percentage < 20
              ? Colors.red
              : percentage < 50
                  ? Colors.orange
                  : Colors.green,
        ),
      ),
      trailing: Text('${item.currentQuantity}/${item.maxQuantity}'),
      onTap: () => Navigator.pushNamed(context, '/product-detail'),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          // Already on dashboard
          break;
        case 1:
          Navigator.pushNamed(context, '/inventory');
          break;
        case 2:
          Navigator.pushNamed(context, '/sales');
          break;
        case 3:
          Navigator.pushNamed(context, '/reports');
          break;
      }
    });
  }
}

class DashboardModule {
  final String name;
  final IconData icon;
  final String route;

  DashboardModule(this.name, this.icon, this.route);
}

class StockItem {
  final String name;
  final int currentQuantity;
  final int maxQuantity;
  final IconData icon;

  StockItem(this.name, this.currentQuantity, this.maxQuantity, this.icon);
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
