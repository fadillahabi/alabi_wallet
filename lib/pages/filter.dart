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
        backgroundColor: const Color(0xff1E88E5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1E88E5), Color.fromARGB(255, 19, 86, 145)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedFilter,
              isExpanded: true,
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
            const SizedBox(height: 16),
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
