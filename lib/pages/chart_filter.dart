// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class ChartFilter extends StatefulWidget {
//   const ChartFilter({super.key});
//   static const String id = "/chart_filter";

//   @override
//   State<ChartFilter> createState() => _ChartFilterState();
// }

// class _ChartFilterState extends State<ChartFilter> {
//   String selectedType = 'Income';
//   String selectedRange = 'All';

//   final List<String> monthRanges = [
//     'All',
//     'Jan - Mar',
//     'Apr - Jun',
//     'Jul - Sep',
//     'Oct - Dec',
//   ];

//   final List<String> monthLabels = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'Mei',
//     'Jun',
//     'Jul',
//     'Agu',
//     'Sep',
//     'Okt',
//     'Nov',
//     'Des',
//   ];

//   final Map<String, List<double>> dummyData = {
//     'Income': [8, 10, 12, 7, 9, 14, 13, 11, 10, 15, 16, 18],
//     'Outcome': [5, 6, 9, 5, 7, 10, 8, 9, 7, 12, 11, 14],
//   };

//   List<FlSpot> getFilteredSpots() {
//     final data = dummyData[selectedType]!;
//     final range = getRangeIndexes();

//     return List.generate(
//       range.length,
//       (i) => FlSpot(i.toDouble(), data[range[i]]),
//     );
//   }

//   List<String> getFilteredLabels() {
//     final range = getRangeIndexes();
//     return range.map((i) => monthLabels[i]).toList();
//   }

//   List<int> getRangeIndexes() {
//     switch (selectedRange) {
//       case 'Jan - Mar':
//         return [0, 1, 2];
//       case 'Apr - Jun':
//         return [3, 4, 5];
//       case 'Jul - Sep':
//         return [6, 7, 8];
//       case 'Oct - Dec':
//         return [9, 10, 11];
//       case 'All':
//       default:
//         return List.generate(12, (i) => i);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final spots = getFilteredSpots();
//     final labels = getFilteredLabels();

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           "Chart Report",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xff1E88E5), Color.fromARGB(255, 19, 86, 145)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(24, 120, 24, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Filter Data",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: selectedType,
//                       dropdownColor: Colors.blue[800],
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: "Tipe",
//                         labelStyle: TextStyle(color: Colors.white),
//                         filled: true,
//                         fillColor: Colors.white12,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       items:
//                           ['Income', 'Outcome']
//                               .map(
//                                 (e) =>
//                                     DropdownMenuItem(value: e, child: Text(e)),
//                               )
//                               .toList(),
//                       onChanged: (val) {
//                         setState(() => selectedType = val!);
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       value: selectedRange,
//                       dropdownColor: Colors.blue[800],
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: "Bulan",
//                         labelStyle: TextStyle(color: Colors.white),
//                         filled: true,
//                         fillColor: Colors.white12,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       items:
//                           monthRanges
//                               .map(
//                                 (e) =>
//                                     DropdownMenuItem(value: e, child: Text(e)),
//                               )
//                               .toList(),
//                       onChanged: (val) {
//                         setState(() => selectedRange = val!);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Expanded(
//                 child: LineChart(
//                   LineChartData(
//                     minY: 0,
//                     maxY: 20,
//                     titlesData: FlTitlesData(
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (value, meta) {
//                             int index = value.toInt();
//                             if (index >= labels.length) return Container();
//                             return SideTitleWidget(
//                               axisSide: meta.axisSide,
//                               child: Text(
//                                 labels[index],
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             );
//                           },
//                           interval: 1,
//                           reservedSize: 30,
//                         ),
//                       ),
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       rightTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       topTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                     ),
//                     gridData: FlGridData(show: false),
//                     borderData: FlBorderData(show: false),
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: spots,
//                         isCurved: true,
//                         color: Colors.white,
//                         barWidth: 4,
//                         dotData: FlDotData(show: true),
//                         belowBarData: BarAreaData(
//                           show: true,
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.white.withOpacity(0.3),
//                               Colors.transparent,
//                             ],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
