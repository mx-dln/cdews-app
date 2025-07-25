import 'package:flutter/material.dart';
import 'package:cdewsv2/constants.dart';
import 'package:cdewsv2/models/instruments.dart';

class InstrumentWidget extends StatelessWidget {
  const InstrumentWidget({
    super.key,
    required this.index,
    required this.dataList,
  });

  final int index;
  final List<Instrument> dataList;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12), // Adds inner spacing
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Constants.primaryColor.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset('assets/images/iot.png', height: 35),
            ),
          ),
          const SizedBox(width: 16), // Gap between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataList[index].barangay,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dataList[index].stationName,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Constants.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dataList[index].deviceId,
                  style: TextStyle(
                    color: Constants.blackColor.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${dataList[index].status}',
                  style: TextStyle(
                    color: dataList[index].status == 1 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
