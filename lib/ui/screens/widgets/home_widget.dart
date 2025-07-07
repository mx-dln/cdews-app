import 'package:flutter/material.dart';
import 'package:cdewsv2/constants.dart';
import 'package:cdewsv2/models/homeData.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, required this.index, required this.dataList});

  final int index;
  final List<Data> dataList;

  @override
  Widget build(BuildContext context) {
    final data = dataList[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.barangay ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Station: ${data.stationName ?? ''}"),
            Text("Datetime: ${data.datetime ?? ''}"),
            Text("Egg count: ${data.egg ?? ''}"),
          ],
        ),
      ),
    );
  }
}
