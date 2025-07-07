import 'package:flutter/material.dart';
import 'package:cdewsv2/models/datas.dart';
import 'package:cdewsv2/constants.dart';
import 'package:cdewsv2/ui/screens/widgets/data_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataDetail extends StatefulWidget {
  final int plantId;
  const DataDetail({super.key, required this.plantId});

  @override
  State<DataDetail> createState() => _DataDetailState();
}

class _DataDetailState extends State<DataDetail> {
  late Future<Data?> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 15, top: 15, bottom: 23),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Constants.primaryColor.withOpacity(.15),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * 0.9,
              child: FutureBuilder<Data?>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final data = snapshot.data!;
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        DataWidget(index: 0, dataList: [data]),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Data?> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final scopeValue = prefs.getString('scopeValue');
    final permissionValue = prefs.getString('permissionValue');
    final id = widget.plantId;

    final response = await http.get(Uri.parse(
        'https://c-dews.synqbox.com/api/oltraps/$scopeValue/$permissionValue'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      for (Map<String, dynamic> item in jsonResponse["data"]) {
        if (item["id"] == id) {
          return Data.fromJson(item);
        }
      }
      return null; // If not found
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
