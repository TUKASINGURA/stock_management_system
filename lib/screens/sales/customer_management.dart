import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerManagementScreen extends StatefulWidget {
  @override
  _CustomerManagementScreenState createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'All';
  final List<Customer> _customers = [
    Customer(
      id: 'C1001',
      name: 'John Doe',
      email: 'john@example.com',
      phone: '+1 555-123-4567',
      type: 'Retail',
      joinDate: DateTime.now().subtract(Duration(days: 120)),
      lastOrder: DateTime.now().subtract(Duration(days: 5)),
      totalOrders: 12,
      totalSpent: 1245.99,
      status: 'Active',
    ),
    Customer(
      id: 'C1002',
      name: 'Jane Smith',
      email: 'jane@example.com',
      phone: '+1 555-987-6543',
      type: 'Wholesale',
      joinDate: DateTime.now().subtract(Duration(days: 90)),
      lastOrder: DateTime.now().subtract(Duration(days: 15)),
      totalOrders: 8,
      totalSpent: 3560.50,
      status: 'Active',
    ),
    Customer(
      id: 'C1003',
      name: 'Acme Corporation',
      email: 'contact@acme.com',
      phone: '+1 555-555-5555',
      type: 'Corporate',
      joinDate: DateTime.now().subtract(Duration(days: 365)),
      lastOrder: DateTime.now().subtract(Duration(days: 30)),
      totalOrders: 25,
      totalSpent: 12560.75,
      status: 'Active',
    ),
    Customer(
      id: 'C1004',
      name: 'Local Store',
      email: 'info@localstore.com',
      phone: '+1 555-111-2222',
      type: 'Retail',
      joinDate: DateTime.now().subtract(Duration(days: 60)),
      lastOrder: DateTime.now().subtract(Duration(days: 45)),
      totalOrders: 3,
      totalSpent: 320.00,
      status: 'Inactive',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = _filterType == 'All'
        ? _customers
        : _customers.where((customer) => customer.type == _filterType).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Customers',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToNewCustomer(),
            tooltip: 'Add New Customer',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search customers...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 10),
                FilterChip(
                  label: Text(_filterType),
                  onSelected: (_) => _showFilterDialog(),
                  avatar: Icon(Icons.filter_list, size: 18),
                ),
              ],
            ),
          ),

          // Customer statistics
          _buildCustomerStats(),

          // Customer list
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return _buildCustomerCard(customer);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToNewCustomer(),
        tooltip: 'Add New Customer',
      ),
    );
  }

  Widget _buildCustomerStats() {
    final activeCustomers =
        _customers.where((c) => c.status == 'Active').length;
    final totalSpent = _customers.fold(0.0, (sum, c) => sum + c.totalSpent);
    final avgOrders =
        _customers.fold(0, (sum, c) => sum + c.totalOrders) / _customers.length;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total', _customers.length.toString(), Icons.people),
            _buildStatItem(
                'Active', activeCustomers.toString(), Icons.check_circle),
            _buildStatItem('Avg Orders', avgOrders.toStringAsFixed(1),
                Icons.shopping_cart),
            _buildStatItem('Total Value', '\$${totalSpent.toStringAsFixed(0)}',
                Icons.attach_money),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToCustomerDetail(customer),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    customer.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(customer.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      customer.type,
                      style: TextStyle(
                        color: _getTypeColor(customer.type),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(customer.email),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(customer.phone),
                ],
              ),
              SizedBox(height: 8),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Joined: ${DateFormat('MMM yyyy').format(customer.joinDate)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        'Last Order: ${DateFormat('MMM d').format(customer.lastOrder)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${customer.totalOrders} orders',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${customer.totalSpent.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _contactCustomer(customer),
                      child: Text('Contact'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _createOrderForCustomer(customer),
                      child: Text('New Order'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Retail':
        return Colors.blue;
      case 'Wholesale':
        return Colors.purple;
      case 'Corporate':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    return status == 'Active' ? Colors.green : Colors.red;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Customers'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('All'),
              _buildFilterOption('Retail'),
              _buildFilterOption('Wholesale'),
              _buildFilterOption('Corporate'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String type) {
    return ListTile(
      title: Text(type),
      leading: Radio(
        value: type,
        groupValue: _filterType,
        onChanged: (value) {
          setState(() {
            _filterType = value.toString();
            Navigator.pop(context);
          });
        },
      ),
    );
  }

  void _contactCustomer(Customer customer) {
    // Implement contact functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${customer.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              onTap: () {
                Navigator.pop(context);
                // Implement email
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Call'),
              onTap: () {
                Navigator.pop(context);
                // Implement call
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Message'),
              onTap: () {
                Navigator.pop(context);
                // Implement messaging
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createOrderForCustomer(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewOrderScreen(customer: customer),
      ),
    );
  }

  void _navigateToCustomerDetail(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailScreen(customer: customer),
      ),
    );
  }

  void _navigateToNewCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewCustomerScreen(),
      ),
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String type;
  final DateTime joinDate;
  final DateTime lastOrder;
  final int totalOrders;
  final double totalSpent;
  final String status;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.joinDate,
    required this.lastOrder,
    required this.totalOrders,
    required this.totalSpent,
    required this.status,
  });
}

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  CustomerDetailScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editCustomer(),
            tooltip: 'Edit Customer',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          customer.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                _getTypeColor(customer.type).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            customer.type,
                            style: TextStyle(
                              color: _getTypeColor(customer.type),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow('Customer ID', customer.id),
                    _buildDetailRow('Email', customer.email),
                    _buildDetailRow('Phone', customer.phone),
                    _buildDetailRow('Status', customer.status),
                    _buildDetailRow('Join Date',
                        DateFormat('MMM dd, yyyy').format(customer.joinDate)),
                    _buildDetailRow('Last Order',
                        DateFormat('MMM dd, yyyy').format(customer.lastOrder)),
                    _buildDetailRow(
                        'Total Orders', customer.totalOrders.toString()),
                    _buildDetailRow('Total Value',
                        '\$${customer.totalSpent.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildActionButton(
                  'New Order',
                  Icons.add_shopping_cart,
                  Colors.green,
                  () => _createOrder(context),
                ),
                _buildActionButton(
                  'Contact',
                  Icons.message,
                  Colors.blue,
                  () => _contactCustomer(context),
                ),
                _buildActionButton(
                  'View Orders',
                  Icons.list_alt,
                  Colors.orange,
                  () => _viewOrders(context),
                ),
                _buildActionButton(
                  'Send Promotion',
                  Icons.local_offer,
                  Colors.purple,
                  () => _sendPromotion(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Order History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              child: ListTile(
                title: Text('Recent Orders (${customer.totalOrders})'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _viewOrders(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Retail':
        return Colors.blue;
      case 'Wholesale':
        return Colors.purple;
      case 'Corporate':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _createOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewOrderScreen(customer: customer),
      ),
    );
  }

  void _contactCustomer(BuildContext context) {
    // Implement contact functionality
  }

  void _viewOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerOrdersScreen(customer: customer),
      ),
    );
  }

  void _sendPromotion(BuildContext context) {
    // Implement send promotion functionality
  }

  void _editCustomer() {
    // Implement edit functionality
  }
}

class NewCustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Customer')),
      body: Center(child: Text('New Customer Form')),
    );
  }
}

class CustomerOrdersScreen extends StatelessWidget {
  final Customer customer;

  CustomerOrdersScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${customer.name}\'s Orders')),
      body: Center(child: Text('Order List for ${customer.name}')),
    );
  }
}

class NewOrderScreen extends StatelessWidget {
  final Customer? customer;

  NewOrderScreen({this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer != null
            ? 'New Order for ${customer!.name}'
            : 'Create New Order'),
      ),
      body: Center(child: Text('Order Form')),
    );
  }
}
