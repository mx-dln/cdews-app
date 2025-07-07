import 'package:flutter/material.dart';
import 'package:cdewsv2/models/homeData.dart';
import 'package:cdewsv2/ui/screens/widgets/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Data> parseHomeData(Map<String, dynamic> data) {
  final List<dynamic> dataList = data['data'] ?? [];
  return dataList.map<Data>((json) => Data.fromJson(json)).toList();
}

class _HomePageState extends State<HomePage> {
  Future<List<Data>>? futureHomeData;

  @override
  void initState() {
    super.initState();
    futureHomeData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Data>>(
        future: futureHomeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dataList = snapshot.data ?? [];

            if (dataList.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            return ListView.builder(
              itemCount: dataList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return HomeWidget(index: index, dataList: dataList);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Data>> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final scopeValue = prefs.getString('scopeValue');
      final permissionValue = prefs.getString('permissionValue');

      final response = await http.get(
        Uri.parse(
          'https://c-dews.synqbox.com/api/oltrapsdata/$scopeValue/$permissionValue/2025-07-07',
        ),
      );

      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return await compute(parseHomeData, data);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
