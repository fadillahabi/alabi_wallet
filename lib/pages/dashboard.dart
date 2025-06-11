import 'package:daily_financial_recording/database/db_input.dart';
import 'package:daily_financial_recording/model/model_input.dart';
import 'package:daily_financial_recording/pages/form_input.dart';
import 'package:flutter/material.dart';

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
      final value = t.labaProject;

      if (isIncome) {
        total += value;
      } else {
        total -= value;
      }
    }

    setState(() {
      _transaction = list;
      _totalBalance = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Wallet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (tampilTeks)
                  Text("Hello, User!", style: TextStyle(color: Colors.white)),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tampilTeks = !tampilTeks;
                    });
                  },
                  child: CircleAvatar(
                    radius: 24,
                    child: CircleAvatar(
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff1E88E5), Color.fromARGB(255, 19, 86, 145)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Rp.${_formatCurrency(_totalBalance)}",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Total Balance",
                  style: TextStyle(color: Colors.grey[300], fontSize: 16),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconButton(Icons.arrow_back, () {}),
                    _iconButton(Icons.arrow_forward, () {}),
                    _iconButton(Icons.refresh, () {}),
                    _iconButton(Icons.add, () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormInput(input: ModelInput.empty()),
                        ),
                      );
                      if (result == true) {
                        await _loadTransactions();
                      }
                    }),
                  ],
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(
                      4,
                    ), // Tambahkan padding agar tombol tidak rapat
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
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
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _transaction.map((t) {
                        return incomeTile(
                          id: t.id!,
                          namaProject: t.namaProject,
                          dateProject: t.dateProject,
                          labaProject: t.labaProject,
                          type: t.type,
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card incomeTile({
    required int id,
    required String namaProject,
    required String dateProject,
    required int labaProject,
    required String type,
  }) {
    final isIncome = type == 'income';
    final color = isIncome ? Colors.green : Colors.red;
    final sign = isIncome ? '+' : '-';

    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            namaProject,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            dateProject,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign Rp.${_formatCurrency(labaProject)}',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, size: 20),
                onPressed: () async {
                  await DBInput.deleteInput(id);
                  await _loadTransactions();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@override
Widget _iconButton(IconData icon, VoidCallback onPressed) {
  return CircleAvatar(
    radius: 44,
    backgroundColor: Colors.white.withOpacity(0.15),
    child: IconButton(
      icon: Icon(icon, color: Colors.white),
      iconSize: 28,
      onPressed: onPressed,
      padding: EdgeInsets.all(14),
      // splashRadius: 24,
    ),
  );
}

String _formatCurrency(int amount) {
  final str = amount.abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    int idx = str.length - i;
    buffer.write(str[i]);
    if (idx > 1 && idx % 3 == 1 && i != str.length - 1) {
      buffer.write('.');
    }
  }
  final formatted = buffer.toString().split('').reversed.join();
  return '${amount < 0 ? '-' : ''}$formatted,00';
}
