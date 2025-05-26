import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

// the  syncfusion_flutter_charts this package gives you access to a wide range of charts, such as:
// -line chart,Bar chart,Pie chart,Area chart,Candle and OHLC (for financial data) ,Radial bar, Pyramid, Funnel, etc.

class SalesAnalyticsScreen extends StatefulWidget {
  @override
  _SalesAnalyticsScreenState createState() => _SalesAnalyticsScreenState();
}

class _SalesAnalyticsScreenState extends State<SalesAnalyticsScreen> {
  String _timeRange = 'Last 30 Days';
  String _reportType = 'Revenue';
  String _categoryFilter = 'All Categories';

  final List<SalesData> _dailySales = [
    SalesData(DateTime(2023, 6, 1), 1452.30),
    SalesData(DateTime(2023, 6, 2), 1895.20),
    // Add more daily data...
  ];

  final List<SalesData> _monthlySales = [
    SalesData(DateTime(2023, 1, 1), 45230.50),
    SalesData(DateTime(2023, 2, 1), 48950.20),
    // Add more monthly data...
  ];

  final List<ProductPerformance> _productPerformance = [
    ProductPerformance('Premium Widget', 12450.99, 342, 12),
    ProductPerformance('Standard Widget', 8450.50, 587, 8),
    // Add more products...
  ];

  final List<SalesByCategory> _salesByCategory = [
    SalesByCategory('Electronics', 25450.99, Colors.blue),
    SalesByCategory('Groceries', 18450.50, Colors.green),
    // Add more categories...
  ];

  @override
  Widget build(BuildContext context) {
    final currentData =
        _timeRange == 'Last 30 Days' ? _dailySales : _monthlySales;
    final filteredProducts = _categoryFilter == 'All Categories'
        ? _productPerformance
        : _productPerformance
            .where((p) => p.category == _categoryFilter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Analytics'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Options',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Cards
            _buildQuickStats(),
            SizedBox(height: 20),

            // Time Range Selector
            _buildTimeRangeSelector(),
            SizedBox(height: 20),

            // Main Chart
            Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _reportType == 'Revenue' ? 'Revenue Trend' : 'Units Sold',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 300,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          title: AxisTitle(text: 'Date'),
                          intervalType: _timeRange == 'Last 30 Days'
                              ? DateTimeIntervalType.days
                              : DateTimeIntervalType.months,
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(
                              text: _reportType == 'Revenue'
                                  ? 'Amount (\$)'
                                  : 'Units'),
                        ),
                        series: <CartesianSeries>[
                          LineSeries<SalesData, DateTime>(
                            dataSource: currentData,
                            xValueMapper: (SalesData sales, _) => sales.date,
                            yValueMapper: (SalesData sales, _) =>
                                _reportType == 'Revenue'
                                    ? sales.amount
                                    : sales.units,
                            markerSettings: MarkerSettings(isVisible: true),
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Bottom Row - Product Performance and Categories
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Performance
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top Performing Products',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          DropdownButton<String>(
                            value: _categoryFilter,
                            items: [
                              'All Categories',
                              'Electronics',
                              'Groceries',
                              // Add more categories
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _categoryFilter = value!;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 300,
                            child: ListView.builder(
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return _buildProductPerformanceItem(product);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Sales by Category
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales by Category',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 300,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                PieSeries<SalesByCategory, String>(
                                  dataSource: _salesByCategory,
                                  xValueMapper: (SalesByCategory data, _) =>
                                      data.category,
                                  yValueMapper: (SalesByCategory data, _) =>
                                      data.amount,
                                  pointColorMapper: (SalesByCategory data, _) =>
                                      data.color,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  enableTooltip: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    // Calculate stats from your data
    final totalRevenue =
        _dailySales.fold(0.0, (sum, item) => sum + item.amount);
    final avgDailySales = totalRevenue / _dailySales.length;
    final topProduct =
        _productPerformance.reduce((a, b) => a.revenue > b.revenue ? a : b);
    final growthRate = 12.5; // Calculate from your data

    return Row(
      children: [
        _buildStatCard('Total Revenue', '\$${totalRevenue.toStringAsFixed(2)}',
            Icons.attach_money, Colors.green),
        SizedBox(width: 12),
        _buildStatCard(
            'Avg Daily Sales',
            '\$${avgDailySales.toStringAsFixed(2)}',
            Icons.trending_up,
            Colors.blue),
        SizedBox(width: 12),
        _buildStatCard(
            'Top Product', topProduct.name, Icons.star, Colors.orange),
        SizedBox(width: 12),
        _buildStatCard('Growth Rate', '${growthRate.toStringAsFixed(1)}%',
            Icons.show_chart, growthRate >= 0 ? Colors.green : Colors.red),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: color),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'Last 30 Days', label: Text('30 Days')),
            ButtonSegment(value: 'This Year', label: Text('Yearly')),
          ],
          selected: {_timeRange},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              _timeRange = newSelection.first;
            });
          },
        ),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'Revenue', label: Text('Revenue')),
            ButtonSegment(value: 'Units', label: Text('Units')),
          ],
          selected: {_reportType},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              _reportType = newSelection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildProductPerformanceItem(ProductPerformance product) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(product.name[0]),
        ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            LinearProgressIndicator(
              value: product.revenue / 20000, // Adjust based on your max value
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${product.revenue.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${product.unitsSold} units',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _exportReport() {
    // Implement export functionality (PDF, Excel, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exporting report...')),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report Filters'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterOption(
                    'Date Range',
                    [
                      'Today',
                      'Last 7 Days',
                      'Last 30 Days',
                      'This Month',
                      'This Year'
                    ],
                    _timeRange),
                Divider(),
                _buildFilterOption(
                    'Report Type',
                    ['Revenue', 'Units Sold', 'Profit', 'Transactions'],
                    _reportType),
                Divider(),
                _buildFilterOption(
                    'Category',
                    [
                      'All Categories',
                      'Electronics',
                      'Groceries',
                      'Clothing',
                      'Home Goods'
                    ],
                    _categoryFilter),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Apply filters
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterOption(
      String title, List<String> options, String currentValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: currentValue == option,
              onSelected: (selected) {
                setState(() {
                  if (title == 'Date Range') {
                    _timeRange = option;
                  } else if (title == 'Report Type') {
                    _reportType = option;
                  } else if (title == 'Category') {
                    _categoryFilter = option;
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SalesData {
  final DateTime date;
  final double amount;
  final int units;

  SalesData(this.date, this.amount, [this.units = 0]);
}

class ProductPerformance {
  final String name;
  final String category;
  final double revenue;
  final int unitsSold;
  final int returnRate; // Percentage

  ProductPerformance(this.name, this.revenue, this.unitsSold, this.returnRate,
      [this.category = 'Electronics']);
}

class SalesByCategory {
  final String category;
  final double amount;
  final Color color;

  SalesByCategory(this.category, this.amount, this.color);
}
