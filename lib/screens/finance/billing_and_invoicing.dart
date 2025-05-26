import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoicingScreen extends StatefulWidget {
  @override
  _InvoicingScreenState createState() => _InvoicingScreenState();
}

class _InvoicingScreenState extends State<InvoicingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All';
  String _filterPeriod = 'This Month';

  final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-2023-1001',
      customer: 'John Doe',
      date: DateTime.now().subtract(Duration(days: 2)),
      dueDate: DateTime.now().add(Duration(days: 7)),
      amount: 1245.99,
      tax: 149.52,
      discount: 50.00,
      total: 1345.51,
      status: 'Paid',
      items: [
        InvoiceItem('Premium Widget', 2, 499.99),
        InvoiceItem('Standard Widget', 5, 299.99),
      ],
    ),
    Invoice(
      id: 'INV-2023-1002',
      customer: 'Acme Corporation',
      date: DateTime.now().subtract(Duration(days: 5)),
      dueDate: DateTime.now().add(Duration(days: 5)),
      amount: 3560.50,
      tax: 427.26,
      discount: 200.00,
      total: 3787.76,
      status: 'Pending',
      items: [
        InvoiceItem('Deluxe Widget', 10, 299.99),
        InvoiceItem('Accessory Kit', 5, 112.11),
      ],
    ),
    Invoice(
      id: 'INV-2023-1003',
      customer: 'Jane Smith',
      date: DateTime.now().subtract(Duration(days: 10)),
      dueDate: DateTime.now().subtract(Duration(days: 3)),
      amount: 560.75,
      tax: 67.29,
      discount: 0.00,
      total: 628.04,
      status: 'Overdue',
      items: [
        InvoiceItem('Standard Widget', 2, 299.99),
        InvoiceItem('Widget Maintenance', 1, 60.77),
      ],
    ),
    Invoice(
      id: 'INV-2023-1004',
      customer: 'Retail Store Inc.',
      date: DateTime.now().subtract(Duration(days: 15)),
      dueDate: DateTime.now().add(Duration(days: 15)),
      amount: 1120.00,
      tax: 134.40,
      discount: 100.00,
      total: 1154.40,
      status: 'Draft',
      items: [
        InvoiceItem('Premium Widget', 1, 499.99),
        InvoiceItem('Standard Widget', 2, 299.99),
        InvoiceItem('Widget Tool', 1, 20.03),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredInvoices = _applyFilters();
    final stats = _calculateStats();

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoicing & Billing'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Invoices',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _createNewInvoice(),
            tooltip: 'Create New Invoice',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and quick stats
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search invoices...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 12),
                _buildStatsRow(stats),
              ],
            ),
          ),

          // Invoice list
          Expanded(
            child: ListView.builder(
              itemCount: filteredInvoices.length,
              itemBuilder: (context, index) {
                final invoice = filteredInvoices[index];
                return _buildInvoiceCard(invoice);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createNewInvoice(),
        tooltip: 'Create New Invoice',
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> stats) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total', '\$${stats['total']}', Icons.receipt),
            _buildStatItem(
                'Paid', '\$${stats['paid']}', Icons.check_circle, Colors.green),
            _buildStatItem('Pending', '\$${stats['pending']}', Icons.pending,
                Colors.orange),
            _buildStatItem(
                'Overdue', '\$${stats['overdue']}', Icons.warning, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      [Color? color]) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.blue),
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

  Widget _buildInvoiceCard(Invoice invoice) {
    final isOverdue =
        invoice.status == 'Overdue' && invoice.dueDate.isBefore(DateTime.now());

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: InkWell(
        onTap: () => _viewInvoiceDetails(invoice),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoice.id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(invoice.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      invoice.status,
                      style: TextStyle(
                        color: _getStatusColor(invoice.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Customer: ${invoice.customer}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                'Date: ${DateFormat('MMM dd, yyyy').format(invoice.date)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                'Due: ${DateFormat('MMM dd, yyyy').format(invoice.dueDate)}',
                style: TextStyle(
                  color: isOverdue ? Colors.red : Colors.grey[600],
                  fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                ),
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
                        '${invoice.items.length} items',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        invoice.items
                            .take(2)
                            .map((item) => item.name)
                            .join(', '),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '\$${invoice.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (invoice.status != 'Paid')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _processPayment(invoice),
                        child: Text('Record Payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                    if (invoice.status == 'Draft') SizedBox(width: 8),
                    if (invoice.status == 'Draft')
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _sendInvoice(invoice),
                          child: Text('Send Invoice'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Overdue':
        return Colors.red;
      case 'Draft':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  List<Invoice> _applyFilters() {
    var filtered = _invoices.where((invoice) {
      // Apply status filter
      if (_filterStatus != 'All' && invoice.status != _filterStatus) {
        return false;
      }

      // Apply period filter
      final now = DateTime.now();
      switch (_filterPeriod) {
        case 'Today':
          return invoice.date.year == now.year &&
              invoice.date.month == now.month &&
              invoice.date.day == now.day;
        case 'This Week':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          return invoice.date.isAfter(startOfWeek);
        case 'This Month':
          return invoice.date.year == now.year &&
              invoice.date.month == now.month;
        case 'This Year':
          return invoice.date.year == now.year;
        default:
          return true;
      }
    }).toList();

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((invoice) {
        return invoice.id.toLowerCase().contains(searchTerm) ||
            invoice.customer.toLowerCase().contains(searchTerm);
      }).toList();
    }

    return filtered;
  }

  Map<String, dynamic> _calculateStats() {
    double total = 0;
    double paid = 0;
    double pending = 0;
    double overdue = 0;

    for (var invoice in _invoices) {
      total += invoice.total;
      switch (invoice.status) {
        case 'Paid':
          paid += invoice.total;
          break;
        case 'Pending':
          pending += invoice.total;
          break;
        case 'Overdue':
          overdue += invoice.total;
          break;
      }
    }

    return {
      'total': total.toStringAsFixed(2),
      'paid': paid.toStringAsFixed(2),
      'pending': pending.toStringAsFixed(2),
      'overdue': overdue.toStringAsFixed(2),
    };
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Invoices'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildFilterOption('All', 'status'),
                _buildFilterOption('Paid', 'status'),
                _buildFilterOption('Pending', 'status'),
                _buildFilterOption('Overdue', 'status'),
                _buildFilterOption('Draft', 'status'),
                SizedBox(height: 16),
                Text('Period', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildFilterOption('All Time', 'period'),
                _buildFilterOption('Today', 'period'),
                _buildFilterOption('This Week', 'period'),
                _buildFilterOption('This Month', 'period'),
                _buildFilterOption('This Year', 'period'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String type) {
    final currentValue = type == 'status' ? _filterStatus : _filterPeriod;
    return ListTile(
      title: Text(label),
      leading: Radio(
        value: label,
        groupValue: currentValue,
        onChanged: (value) {
          setState(() {
            if (type == 'status') {
              _filterStatus = value.toString();
            } else {
              _filterPeriod = value.toString();
            }
            Navigator.pop(context);
          });
        },
      ),
    );
  }

  void _processPayment(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Record Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Invoice ${invoice.id}'),
            Text('Amount: \$${invoice.total.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Payment Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Payment Method',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Payment Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  // Update payment date
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                invoice.status = 'Paid';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment recorded successfully')),
              );
            },
            child: Text('Record Payment'),
          ),
        ],
      ),
    );
  }

  void _sendInvoice(Invoice invoice) {
    setState(() {
      invoice.status = 'Pending';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invoice sent to ${invoice.customer}')),
    );
  }

  void _viewInvoiceDetails(Invoice invoice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceDetailScreen(invoice: invoice),
      ),
    );
  }

  void _createNewInvoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewInvoiceScreen(),
      ),
    );
  }
}

class Invoice {
  final String id;
  final String customer;
  final DateTime date;
  final DateTime dueDate;
  final double amount;
  final double tax;
  final double discount;
  final double total;
  String status;
  final List<InvoiceItem> items;

  Invoice({
    required this.id,
    required this.customer,
    required this.date,
    required this.dueDate,
    required this.amount,
    required this.tax,
    required this.discount,
    required this.total,
    required this.status,
    required this.items,
  });
}

class InvoiceItem {
  final String name;
  final int quantity;
  final double unitPrice;

  InvoiceItem(this.name, this.quantity, this.unitPrice);
}

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  InvoiceDetailScreen({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        invoice.status == 'Overdue' && invoice.dueDate.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printInvoice(),
            tooltip: 'Print Invoice',
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareInvoice(),
            tooltip: 'Share Invoice',
          ),
          if (invoice.status == 'Draft')
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editInvoice(),
              tooltip: 'Edit Invoice',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice header
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
                          invoice.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(invoice.status)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            invoice.status,
                            style: TextStyle(
                              color: _getStatusColor(invoice.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Your Company Name'),
                              Text('123 Business Street'),
                              Text('City, State 10001'),
                              Text('Tax ID: 123456789'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(invoice.customer),
                              Text('Customer Address Line 1'),
                              Text('Customer City, State'),
                              Text('Customer Tax ID if available'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invoice Date:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(DateFormat('MMM dd, yyyy')
                                .format(invoice.date)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isOverdue ? Colors.red : null,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy')
                                  .format(invoice.dueDate),
                              style: TextStyle(
                                color: isOverdue ? Colors.red : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Invoice items
            Text(
              'Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(color: Colors.grey[300]!),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Qty',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Unit Price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Amount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    ...invoice.items.map((item) => TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(item.name),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                item.quantity.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '\$${item.unitPrice.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '\$${(item.quantity * item.unitPrice).toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Invoice summary
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 300,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', invoice.amount),
                        _buildSummaryRow('Tax (10%)', invoice.tax),
                        _buildSummaryRow('Discount', -invoice.discount),
                        Divider(),
                        _buildSummaryRow(
                          'Total',
                          invoice.total,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Invoice actions
            if (invoice.status != 'Paid')
              Column(
                children: [
                  if (invoice.status == 'Draft')
                    ElevatedButton(
                      onPressed: () => _sendInvoice(context),
                      child: Text('Send Invoice to Customer'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                  if (invoice.status == 'Draft') SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _recordPayment(context),
                    child: Text('Record Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                  if (invoice.status == 'Overdue') SizedBox(height: 8),
                  if (invoice.status == 'Overdue')
                    OutlinedButton(
                      onPressed: () => _sendReminder(context),
                      child: Text('Send Payment Reminder'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
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

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Overdue':
        return Colors.red;
      case 'Draft':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _printInvoice() {
    // Implement print functionality
  }

  void _shareInvoice() {
    // Implement share functionality
  }

  void _editInvoice() {
    // Implement edit functionality
  }

  void _sendInvoice(BuildContext context) {
    // Implement send invoice functionality
  }

  void _recordPayment(BuildContext context) {
    // Implement record payment functionality
  }

  void _sendReminder(BuildContext context) {
    // Implement send reminder functionality
  }
}

class NewInvoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Invoice')),
      body: Center(child: Text('New Invoice Form')),
    );
  }
}
