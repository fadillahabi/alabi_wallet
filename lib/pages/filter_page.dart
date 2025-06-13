import 'package:daily_financial_recording/constant/app_color.dart';
import 'package:daily_financial_recording/database/db_input.dart';
import 'package:daily_financial_recording/model/model_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});
  static const String id = "/filter";

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<ModelInput> _allTransactions = [];
  List<ModelInput> _filteredTransactions = [];
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final list = await DBInput().getAllInput();
    setState(() {
      _allTransactions = list;
      _applyFilter();
    });
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == "All") {
        _filteredTransactions = _allTransactions;
      } else {
        _filteredTransactions =
            _allTransactions.where((tx) {
              final txType = tx.type.trim().toLowerCase();
              final selectedType = _selectedFilter.trim().toLowerCase();

              // Debug log sementara untuk cek isi type
              debugPrint('Data type: "$txType" | Filter: "$selectedType"');

              return txType == selectedType;
            }).toList();
      }
    });
  }

  int _getTotalByType(String type) {
    return _filteredTransactions
        .where((tx) => tx.type.trim().toLowerCase() == type)
        .fold(0, (sum, tx) => sum + (tx.labaProject ?? 0));
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return '${formatter.format(amount)},00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Filter Transactions",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.blue_main,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.blue_main, AppColor.blue_gradient],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Income",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          Text(
                            "Rp. ${_formatCurrency(_getTotalByType('income'))}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: Colors.red[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Outcome",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          Text(
                            "Rp. ${_formatCurrency(_getTotalByType('outcome'))}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All")),
                    DropdownMenuItem(value: "income", child: Text("Income")),
                    DropdownMenuItem(value: "outcome", child: Text("Outcome")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                      _applyFilter();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  _filteredTransactions.isEmpty
                      ? const Center(
                        child: Text(
                          "No transactions found.",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final tx = _filteredTransactions[index];
                          final isIncome =
                              tx.type.trim().toLowerCase() == 'income';
                          return Card(
                            color: isIncome ? Colors.green[50] : Colors.red[50],
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(tx.namaProject),
                              subtitle: Text(tx.dateProject),
                              trailing: Text(
                                '${isIncome ? "+" : "-"} Rp.${_formatCurrency(tx.labaProject ?? 0)}',
                                style: TextStyle(
                                  color: isIncome ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
