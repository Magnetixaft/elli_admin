import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import '../models/space.dart';

/// A tab for viewing analytics for ELLI
class AnalyticsTab extends StatefulWidget {
  final staticModelFuture = FirebaseHandler.getInstance().buildStaticModel();
  AnalyticsTab({Key? key}) : super(key: key);

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

// Widget for selecting office, picking day, picking room and then booking a timeslot
class _AnalyticsTabState extends State<AnalyticsTab> {
  String selectedDivision = 'init';
  String selectedOffice = 'init';
  FirebaseHandler backend = FirebaseHandler.getInstance();

  late Future<DivisionReportCard> divisionCardFuture;
  late Future<OfficeReportCard> officeCardFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: widget.staticModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            /// Selects a random division and office to initiate the dropdowns.
            if (selectedDivision == 'init' || selectedOffice == 'init') {
              selectedDivision = backend.getDivisions().keys.first;
              backend.selectDivision(selectedDivision);
              selectedOffice = backend.getDivisionOffices().keys.first;

              divisionCardFuture = backend.generateDivisionReportCard(selectedDivision);
              officeCardFuture = backend.generateOfficeReportCard(selectedOffice);
            }

            return SingleChildScrollView(
              /// The "Analytics" header
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    const Text("    Analytics",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        )),
                    const SizedBox(height: 24),

                    /// The dropdown menus and small header for each
                    Row(
                      children: [
                        Container(width: 80),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Company',
                                style: TextStyle(fontSize: 16),
                              ),
                              _buildCompanyMenu(),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Office',
                                style: TextStyle(fontSize: 16),
                              ),
                              _buildOfficesMenu(),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(''),
                              // const Text(
                              //   'Space',
                              //   style: TextStyle(
                              //       fontSize: 16
                              //   ),
                              // ),
                              // _buildSpacesMenu(spaces),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    /// The card section with all the items under each dropdown menu
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 50),
                        Expanded(
                          flex: 1,
                          child: FutureBuilder<DivisionReportCard>(
                            future: divisionCardFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildRoomCard(snapshot.data!.roomUse),
                                    _buildWorkspaceCard(snapshot.data!.workspaceUse),
                                    _buildUseRateCard(snapshot.data!.usageRate),
                                  ],
                                );
                              }
                              else {
                                return Text(' ');
                              }
                            }
                          ),
                        ),
                        Container(width: 12),
                        Expanded(
                          flex: 1,
                          child: FutureBuilder<OfficeReportCard>(
                              future: officeCardFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildRoomCard(snapshot.data!.roomUse),
                                      _buildWorkspaceCard(snapshot.data!.workspaceUse),
                                      _buildUseRateCard(snapshot.data!.usageRate),
                                    ],
                                  );
                                }
                                else {
                                  return Text(' ');
                                }
                              }
                          ),
                        ),
                        Container(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCard('[Most common workday at space]', '[Monday]  '),
                              _buildCard('[Comparisson number of bookings last week]',
                                  '[Last week  102]                                                             [2 weeks ago 100]                                                        [Diffrence +  39]'),
                              _buildCard('[Name of space]', 'Total number of seats: [#]'),
                            ],
                          ),
                        ),
                        Container(width: 50)
                      ],
                    ),

                    ElevatedButton(onPressed: backend.generateReportCard, child: Text('Debug')),
                  ],
                ),
              ),
            );
          } else {
            return const Text('');
          }
        });
  }

  /// Returns a a card item
  Widget _buildCard(String header, String subtitle) {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                  const SizedBox(height: 4),
                  Container(
                    width: 120,
                    child: TextButton(
                      onPressed: () {},
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'avg. [value] kr',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// Returns a card with information about used Rooms
  Widget _buildRoomCard(List<MapEntry<Room, int>> roomUse) {

    if(roomUse.length > 5) {
      roomUse = roomUse.sublist(0, 5);
    }

    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Most Booked Rooms',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  ...roomUse.map((roomPair) {
                    return Row(children: [
                      Text('Number ${roomPair.key.roomNr}'),
                      const Spacer(flex: 1,),
                      Text(roomPair.key.name),
                      const Spacer(flex: 1,),
                      Text('${roomPair.value.toString()} bookings')
                    ],);
                  },)
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildWorkspaceCard(List<MapEntry<String, int>> workspaceUse) {

    if(workspaceUse.length > 10) {
      workspaceUse = workspaceUse.sublist(0, 10);
    }

    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Most Booked Workspaces',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  ...workspaceUse.map((workspaceEntry) {
                    var roomNr = workspaceEntry.key.split(' ')[0];
                    var workspaceNr = workspaceEntry.key.split(' ')[1];
                    return Row(children: [
                      Text('Number $workspaceNr in room $roomNr'),
                      const Spacer(flex: 1,),
                      Text('${workspaceEntry.value.toString()} bookings')
                    ],);
                  },)
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildUseRateCard(double useRate) {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usage rate',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                      '${(useRate * 100).toStringAsFixed(1)} %', style: const TextStyle(fontSize: 36))
                ],
              )),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  /// This creates the dropdown menu for companies
  Widget _buildCompanyMenu() {
    return DropdownButton(
      // Initial Value
      value: selectedDivision,

      style: const TextStyle(fontWeight: FontWeight.bold),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: backend.getDivisions().keys.map((String items) {
        // TODO change to get from database instead of static list
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          var divisionString = newValue ?? 'error';
          selectedDivision = divisionString;
          backend.selectDivision(divisionString);
          selectedOffice = backend.getDivisionOffices().keys.first;
          divisionCardFuture = backend.generateDivisionReportCard(selectedDivision);
          officeCardFuture = backend.generateOfficeReportCard(selectedOffice);
        });
      },
    );
  }

  /// This creates the dropdown menu for offices
  Widget _buildOfficesMenu() {
    var officeList = backend.getDivisionOffices().keys;
    if (officeList.isEmpty) {
      officeList = ['No offices in this division'];
      selectedOffice = 'No offices in this division';
    }

    return DropdownButton(
      // Initial Value
      value: selectedOffice,

      style: const TextStyle(fontWeight: FontWeight.bold),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: officeList.map((String items) {
        // TODO change to get from database instead of static list
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          var officeString = newValue ?? 'error';
          selectedOffice = officeString;
          backend.selectOffice(officeString);
          officeCardFuture = backend.generateOfficeReportCard(officeString);
        });
      },
    );
  }

  // /// This creates the dropdown menu for spaces
  // Widget _buildSpacesMenu(List<String> list) {
  //   return DropdownButton(
  //     // Initial Value
  //     value: firstSpace,
  //
  //     style: const TextStyle(fontWeight: FontWeight.bold),
  //
  //     // Down Arrow Icon
  //     icon: const Icon(Icons.keyboard_arrow_down),
  //
  //     // Array list of items
  //     items: list.map((String items) {
  //       // TODO change to get from database instead of static list
  //       return DropdownMenuItem(
  //         value: items,
  //         child: Text(items),
  //       );
  //     }).toList(),
  //     // After selecting the desired option,it will
  //     // change button value to selected value
  //     onChanged: (String? newValue) {
  //       setState(() {
  //         firstSpace = newValue!;
  //       });
  //     },
  //   );
  // }
}
