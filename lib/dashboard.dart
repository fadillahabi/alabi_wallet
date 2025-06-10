import 'package:daily_financial_recording/input_income.dart';
import 'package:flutter/material.dart';

class DashboardUang extends StatefulWidget {
  const DashboardUang({super.key});
  static const String id = "/dashboard";

  @override
  State<DashboardUang> createState() => _DashboardUangState();
}

class _DashboardUangState extends State<DashboardUang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  Color(0xff1E88E5),
        backgroundColor: Colors.transparent,
        title: Text(
          "Wallet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 120,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: IconButton(
                icon: Icon(Icons.notifications_none_outlined),
                onPressed: () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 27,
              child: CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/catmuscle.png'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
                  "Rp.98.000.000,00",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Wallet ID: 2765313645",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconButton(Icons.arrow_back, () {}),
                    _iconButton(Icons.arrow_forward, () {}),
                    _iconButton(Icons.refresh, () {}),
                    _iconButton(Icons.add, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InputIncome()),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Income",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Outcome",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    incomeTile(
                      iconPath: 'assets/images/freelance.png',
                      dateProject: "1 Juni 2025",
                      nameProject: "Freelance Project",
                      amount: '24.000.000',
                    ),
                    incomeTile(
                      iconPath: 'assets/images/freelance.png',
                      dateProject: "1 Juni 2025",
                      nameProject: "Freelance Project",
                      amount: '24.000.000',
                    ),
                    incomeTile(
                      iconPath: 'assets/images/freelance.png',
                      dateProject: "1 Juni 2025",
                      nameProject: "Freelance Project",
                      amount: '24.000.000',
                    ),
                    incomeTile(
                      iconPath: 'assets/images/freelance.png',
                      dateProject: "1 Juni 2025",
                      nameProject: "Freelance Project",
                      amount: '24.000.000',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card incomeTile({
    required String iconPath,
    required String nameProject,
    required String amount,
    required String dateProject,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(child: Image.asset(iconPath, width: 28, height: 28)),
          ),
          title: Text(
            nameProject,
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
                'RP.$amount',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black38,
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
