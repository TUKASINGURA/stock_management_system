import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  int _selectedTab = 0; // 0: Pending, 1: Processing, 2: Completed, 3: Cancelled
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All';
  final List<Order> _orders = [
    Order(
      id: '#ORD-1001',
      customer: 'John Doe',
      date: DateTime.now().subtract(Duration(days: 1)),
      items: 5,
      amount: 245.99,
      status: 'Pending',
      itemsList: ['Milk (x2)', 'Bread (x3)'],
    ),
    Order(
      id: '#ORD-1002',
      customer: 'Jane Smith',
      date: DateTime.now().subtract(Duration(days: 2)),
      items: 3,
      amount: 120.50,
      status: 'Processing',
      itemsList: ['Eggs (x1)', 'Butter (x2)'],
    ),
    Order(
      id: '#ORD-1003',
      customer: 'Acme Corp',
      date: DateTime.now().subtract(Duration(days: 3)),
      items: 12,
      amount: 560.75,
      status: 'Completed',
      itemsList: ['Flour (x5)', 'Sugar (x3)', 'Oil (x4)'],
    ),
    Order(
      id: '#ORD-1004',
      customer: 'Retail Shop',
      date: DateTime.now().subtract(Duration(days: 4)),
      items: 8,
      amount: 320.00,
      status: 'Cancelled',
      itemsList: ['Chips (x4)', 'Soda (x4)'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filterStatus == 'All'
        ? _orders
        : _orders.where((order) => order.status == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Orders',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToNewOrder(),
            tooltip: 'Create New Order',
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
                      hintText: 'Search orders...',
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
                  label: Text(_filterStatus),
                  onSelected: (_) => _showFilterDialog(),
                  avatar: Icon(Icons.filter_list, size: 18),
                ),
              ],
            ),
          ),

          // Status tabs
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatusTab('Pending', 0),
                _buildStatusTab('Processing', 1),
                _buildStatusTab('Completed', 2),
                _buildStatusTab('Cancelled', 3),
              ],
            ),
          ),

          // Order list
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToNewOrder(),
        tooltip: 'Create New Order',
      ),
    );
  }

  Widget _buildStatusTab(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
          _filterStatus = title;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 3,
              color: _selectedTab == index ? Colors.blue : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _selectedTab == index ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToOrderDetail(order),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Customer: ${order.customer}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                'Date: ${DateFormat('MMM dd, yyyy - hh:mm a').format(order.date)}',
                style: TextStyle(color: Colors.grey[600]),
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
                        '${order.items} items',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        order.itemsList.join(', '),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    '\$${order.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (order.status == 'Pending' || order.status == 'Processing')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            _updateOrderStatus(order, 'Processing'),
                        child: Text('Process Order'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _updateOrderStatus(order, 'Cancelled'),
                        child: Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              if (order.status == 'Processing')
                ElevatedButton(
                  onPressed: () => _updateOrderStatus(order, 'Completed'),
                  child: Text('Mark as Completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 36),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Orders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('All'),
              _buildFilterOption('Pending'),
              _buildFilterOption('Processing'),
              _buildFilterOption('Completed'),
              _buildFilterOption('Cancelled'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String status) {
    return ListTile(
      title: Text(status),
      leading: Radio(
        value: status,
        groupValue: _filterStatus,
        onChanged: (value) {
          setState(() {
            _filterStatus = value.toString();
            Navigator.pop(context);
          });
        },
      ),
    );
  }

  void _updateOrderStatus(Order order, String newStatus) {
    setState(() {
      order.status = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${order.id} status updated to $newStatus'),
      ),
    );
  }

  void _navigateToOrderDetail(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(order: order),
      ),
    );
  }

  void _navigateToNewOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewOrderScreen(),
      ),
    );
  }
}

class Order {
  final String id;
  final String customer;
  final DateTime date;
  final int items;
  final double amount;
  String status;
  final List<String> itemsList;

  Order({
    required this.id,
    required this.customer,
    required this.date,
    required this.items,
    required this.amount,
    required this.status,
    required this.itemsList,
  });
}

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  OrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printOrder(),
            tooltip: 'Print Order',
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editOrder(),
            tooltip: 'Edit Order',
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
                          order.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(order.status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: _getStatusColor(order.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow('Customer', order.customer),
                    _buildDetailRow(
                        'Date',
                        DateFormat('MMM dd, yyyy - hh:mm a')
                            .format(order.date)),
                    _buildDetailRow('Items', order.items.toString()),
                    _buildDetailRow(
                        'Amount', '\$${order.amount.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Order Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Column(
                children: order.itemsList
                    .map((item) => ListTile(
                          title: Text(item),
                          trailing: Text('\$${_getItemPrice(item)}'),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            if (order.status == 'Pending' || order.status == 'Processing')
              Column(
                children: [
                  if (order.status == 'Pending')
                    ElevatedButton(
                      onPressed: () => _updateStatus(context, 'Processing'),
                      child: Text('Process Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                  if (order.status == 'Processing')
                    ElevatedButton(
                      onPressed: () => _updateStatus(context, 'Completed'),
                      child: Text('Mark as Completed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                  SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _updateStatus(context, 'Cancelled'),
                    child: Text('Cancel Order'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ],
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
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getItemPrice(String item) {
    // In a real app, this would come from your data
    return (10.0 + item.length % 5).toStringAsFixed(2);
  }

  void _updateStatus(BuildContext context, String newStatus) {
    Navigator.pop(context, newStatus);
  }

  void _printOrder() {
    // Implement print functionality
  }

  void _editOrder() {
    // Implement edit functionality
  }
}

class NewOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Order')),
      body: Center(child: Text('New Order Form')),
    );
  }
}
