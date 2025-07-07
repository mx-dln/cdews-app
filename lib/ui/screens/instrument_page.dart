import 'package:flutter/material.dart';
import 'package:cdewsv2/models/instruments.dart';
import 'package:cdewsv2/ui/screens/detail_page.dart';
import 'package:cdewsv2/ui/screens/widgets/instrument_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InstrumentPage extends StatefulWidget {
  const InstrumentPage({super.key});

  @override
  State<InstrumentPage> createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  Future<List<Instrument>>? futureInstruments;

  @override
  void initState() {
    super.initState();
    futureInstruments = instrumentData();
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
                'IoT OL Traps',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * 0.8,
              child: FutureBuilder<List<Instrument>>(
                future: futureInstruments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data found'));
                  } else {
                    final instruments = snapshot.data!;
                    return ListView.builder(
                      itemCount: instruments.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: DetailPage(
                                  instrumentId: instruments[index].id,
                                  stationName: instruments[index].stationName,
                                  barangayName: instruments[index].barangay,
                                  deviceId: instruments[index].deviceId,
                                ),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                          child: InstrumentWidget(index: index, dataList: instruments),
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

  Future<List<Instrument>> instrumentData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final scopeValue = prefs.getString('scopeValue');
      final permissionValue = prefs.getString('permissionValue');

      final response = await http.get(Uri.parse(
        'https://c-dews.synqbox.com/api/oltraps/$scopeValue/$permissionValue',
      ));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Instrument> tempList = [];
        for (Map<String, dynamic> item in jsonResponse["data"]) {
          tempList.add(Instrument.fromJson(item));
        }
        return tempList;
      } else {
        throw Exception('Failed to load instruments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching instruments: $e');
    }
  }
}
