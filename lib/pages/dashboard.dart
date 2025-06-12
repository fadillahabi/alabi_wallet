import 'package:daily_financial_recording/database/db_input.dart';
import 'package:daily_financial_recording/model/model_input.dart';
import 'package:daily_financial_recording/pages/filter.dart';
import 'package:daily_financial_recording/pages/form_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardUang extends StatefulWidget {
  const DashboardUang({super.key});
  static const String id = "/dashboard";

  @override
  State<DashboardUang> createState() => _DashboardUangState();
}

class _DashboardUangState extends State<DashboardUang> {
  bool isIncomeSelected = true;
  bool tampilTeks = false;
  List<ModelInput> _transaction = [];
  int _totalBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final list = await DBInput().getAllInput();
    int total = 0;

    for (var t in list) {
      final isIncome = t.type == 'income';
      final value = t.labaProject ?? 0;
      total += isIncome ? value : -value;
    }

    if (!mounted) return;
    setState(() {
      _transaction = list;
      _totalBalance = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1E88E5),
        elevation: 0,
        toolbarHeight: 100,
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (tampilTeks)
                  const Text(
                    "Hello, User!",
                    style: TextStyle(color: Colors.white),
                  ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tampilTeks = !tampilTeks;
                    });
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 23,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Icon(Icons.person_4, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1E88E5), Color.fromARGB(255, 19, 86, 145)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Rp.${_formatCurrency(_totalBalance)}",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total Balance",
                  style: TextStyle(color: Colors.grey[300], fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Tombol Navigasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconButton(Icons.filter_list, "Filter", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FilterPage()),
                      );
                    }),
                    _iconButton(Icons.add, "Add", () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormInput(input: ModelInput.empty()),
                        ),
                      );
                      if (result == true) await _loadTransactions();
                    }),
                  ],
                ),

                const SizedBox(height: 32),

                // Header Transaksi
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  child: const Row(
                    children: [
                      Text(
                        "Latest Transaction",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // List Transaksi
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _transaction.length,
                  itemBuilder: (context, index) {
                    final t = _transaction[index];
                    return incomeTile(
                      id: t.id!,
                      namaProject: t.namaProject,
                      dateProject: t.dateProject,
                      labaProject: t.labaProject,
                      type: t.type,
                      onUpdate: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => FormInput(input: ModelInput.empty()),
                          ),
                        );
                        if (result == true && mounted)
                          await _loadTransactions();
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("Delete Confirmation"),
                                content: const Text(
                                  "Are you sure you want to delete this transaction?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          await DBInput.deleteInput(t.id!);
                          if (mounted) {
                            await _loadTransactions();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Transaction deleted successfully',
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ), // Tambahan padding bawah agar tidak terpotong
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Transaksi
  Card incomeTile({
    required int id,
    required String namaProject,
    required String dateProject,
    required int? labaProject,
    required String type,
    required VoidCallback onUpdate,
    required VoidCallback onDelete,
  }) {
    final isIncome = type == 'income';
    final color = isIncome ? Colors.green : Colors.red;
    final sign = isIncome ? '+' : '-';

    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              title: Text(
                namaProject,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                dateProject,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$sign Rp.${_formatCurrency(labaProject ?? 0)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onUpdate,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tombol Icon
  Widget _iconButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            iconSize: 28,
            onPressed: onPressed,
          ),
        ),
        // const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  // Format Uang
  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return '${formatter.format(amount)},00';
  }
}
