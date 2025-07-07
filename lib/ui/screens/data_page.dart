import 'package:flutter/material.dart';
import 'package:cdewsv2/models/datas.dart';
import 'package:cdewsv2/ui/screens/data_detail.dart';
import 'package:cdewsv2/ui/screens/widgets/data_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Future<List<Data>> iotData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final scopeValue = prefs.getString('scopeValue');
    final permissionValue = prefs.getString('permissionValue');

    final response = await http.get(Uri.parse(
        'https://c-dews.synqbox.com/api/oltraps/$scopeValue/$permissionValue'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Data> dataList = [];
      for (Map<String, dynamic> item in data["data"]) {
        dataList.add(Data.fromJson(item));
      }
      return dataList;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FutureBuilder<List<Data>>(
          future: iotData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found'));
            } else {
              final dataList = snapshot.data!;
              return ListView.builder(
                itemCount: dataList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: DataDetail(plantId: dataList[index].id),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    child: DataWidget(index: index, dataList: dataList),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
