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

// Function to parse home data in a separate isolate
List<Data> parseHomeData(Map<String, dynamic> data) {
  // Assuming the API returns a list under a key like 'results' or similar
  // Adjust 'results' to the actual key in your API response
  final List<dynamic> dataList = data['results'] ?? [];
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text(
                'Activities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * 0.8,
              child: FutureBuilder<List<Data>>(
                future: futureHomeData,
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
                          child: HomeWidget(index: index, dataList: dataList),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Data>> getData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final scopeValue = prefs.getString('scopeValue');
    final permissionValue = prefs.getString('permissionValue');

    final response = await http.get(Uri.parse(
      'https://c-dews.synqbox.com/api/oltrapsdata/$scopeValue/$permissionValue/2023-01-27',
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Use compute to parse on a separate isolate
      return await compute(parseHomeData, data);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}
}
