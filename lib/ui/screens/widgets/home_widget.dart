import 'package:flutter/material.dart';
import 'package:cdewsv2/constants.dart';
import 'package:cdewsv2/models/homeData.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required this.index,
    required this.dataList,
  });

  final int index;
  final List<Data> dataList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //       context,
      //       PageTransition(
      //           child: DetailPage(
      //             plantId: plantList[index].plantId,
      //           ),
      //           type: PageTransitionType.bottomToTop));
      // },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 90.0,
        padding: const EdgeInsets.only(left: 10, top: 5),
        margin: const EdgeInsets.only(bottom: 10),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 50.0,
                    child: Image.asset('assets/images/iot.png'),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  left: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataList[index].barangay),
                      Text(
                        dataList[index].stationName,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Constants.blackColor,
                        ),
                      ),
                      Text(
                        dataList[index].datetime,
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      Text(
                        'Egg Counts: ${dataList[index].egg}',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
