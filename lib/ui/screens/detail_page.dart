import 'package:flutter/material.dart';
import 'package:cdewsv2/constants.dart';
import 'package:cdewsv2/models/plants.dart';

// FOR INSTRUMENTS
//
class DetailPage extends StatefulWidget {
  final int instrumentId;
  final String stationName;
  final String barangayName;
  final String deviceId;
  const DetailPage(
      {super.key,
      required this.instrumentId,
      required this.stationName,
      required this.barangayName,
      required this.deviceId});

  @override
  State<DetailPage> createState() =>
      _DetailPageState(instrumentId, stationName, barangayName, deviceId);
}

class _DetailPageState extends State<DetailPage> {
  final int instrumentId;
  final String stationName;
  final String barangayName;
  final String deviceId;

  _DetailPageState(
      this.instrumentId, this.stationName, this.barangayName, this.deviceId);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Plant> plantList = Plant.plantList;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
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
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .8,
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    child: SizedBox(
                      height: 300,
                      child: Image.asset('assets/images/antenna.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
              height: size.height * .5,
              width: size.width,
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(.4),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barangayName,
                            style: TextStyle(
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 3.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InstrumentFeature(
                            title: 'Station Name',
                            instrumentFeature: stationName,
                          ),
                          const SizedBox(height: 16),
                          InstrumentFeature(
                            title: 'Device ID',
                            instrumentFeature: deviceId,
                          ),
                          const SizedBox(height: 16),
                          InstrumentFeature(
                            title: 'Status',
                            instrumentFeature:
                                plantList[widget.instrumentId].temperature,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 5,
                  //   right: 0,
                  //   child: SizedBox(
                  //     height: 5.0,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         InstrumentFeature(
                  //           title: 'Station Name',
                  //           instrumentFeature: stationName,
                  //         ),
                  //         InstrumentFeature(
                  //           title: 'Device ID',
                  //           instrumentFeature: deviceId,
                  //         ),
                  //         InstrumentFeature(
                  //           title: 'Status',
                  //           instrumentFeature:
                  //               _plantList[widget.instrumentId].temperature,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstrumentFeature extends StatelessWidget {
  final String instrumentFeature;
  final String title;
  const InstrumentFeature({
    super.key,
    required this.instrumentFeature,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Constants.blackColor,
          ),
        ),
        Text(
          instrumentFeature,
          style: TextStyle(
            color: Constants.primaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
