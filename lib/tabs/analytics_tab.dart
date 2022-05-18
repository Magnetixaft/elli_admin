import 'package:elli_admin/theme.dart';
import 'package:flutter/material.dart';
import 'package:elli_admin/firebase_handler.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

              divisionCardFuture =
                  backend.generateDivisionReportCard(selectedDivision);
              officeCardFuture =
                  backend.generateOfficeReportCard(selectedOffice);
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
                            fontFamily: 'Poppins',
                            color: ElliColors.pink)),

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
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildOfficePieCard(
                                          snapshot.data!.officeUse),
                                      _buildRoomCard(snapshot.data!.roomUse),
                                      _buildWorkspaceCard(
                                          snapshot.data!.workspaceUse),
                                      _buildUseRateCard(
                                          snapshot.data!.usageRate,
                                          snapshot.data!.bookedMinutes),
                                      _buildFutureBookingsCard(snapshot
                                          .data!.numberOfFutureBookings),
                                      _buildEquipmentChartCard(
                                          snapshot.data!.equipmentUsage),
                                    ],
                                  );
                                } else {
                                  return const Text(' ');
                                }
                              }),
                        ),
                        Container(width: 12),
                        Expanded(
                          flex: 1,
                          child: FutureBuilder<OfficeReportCard>(
                              future: officeCardFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildRoomCard(snapshot.data!.roomUse),
                                      _buildWorkspaceCard(
                                          snapshot.data!.workspaceUse),
                                      _buildUseRateCard(
                                          snapshot.data!.usageRate,
                                          snapshot.data!.bookedMinutes),
                                      _buildFutureBookingsCard(snapshot
                                          .data!.numberOfFutureBookings),
                                      _buildEquipmentChartCard(
                                          snapshot.data!.equipmentUsage),
                                    ],
                                  );
                                } else {
                                  return const Text(' ');
                                }
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Text('');
          }
        });
  }

  /// Returns a card with a pie chart with information about offices
  Widget _buildOfficePieCard(List<MapEntry<String, int>> officeUse) {
    if (officeUse.length > 5) {
      officeUse = officeUse.sublist(0, 5);
    }

    var data = [
      charts.Series<MapEntry<String, int>, String>(
        id: 'Office use',
        domainFn: (entry, number) => '${entry.key}: ${entry.value}',
        measureFn: (entry, number) => entry.value,
        data: officeUse,
      )
    ];
    return _buildPieChartCard<MapEntry<String, int>>(data, 'Booked offices');
  }

  /// Returns a card with a bar chart with information about used rooms
  Widget _buildRoomCard(List<MapEntry<Room, int>> roomUse) {
    if (roomUse.length > 5) {
      roomUse = roomUse.sublist(0, 5);
    }

    var data = [
      charts.Series<MapEntry<Room, int>, String>(
        id: 'Room use',
        domainFn: (entry, number) =>
            '${entry.key.name}\nNumber:${entry.key.roomNr.toString()}',
        measureFn: (entry, number) => entry.value,
        data: roomUse,
      )
    ];
    return _buildBarChartCard<MapEntry<Room, int>>(
        data, 'Booked rooms [bookings]');
  }

  /// Returns a card with a bar chart with information about booked workspaces.
  Widget _buildWorkspaceCard(List<MapEntry<String, int>> workspaceUse) {
    if (workspaceUse.length > 10) {
      workspaceUse = workspaceUse.sublist(0, 10);
    }

    var data = [
      charts.Series<MapEntry<String, int>, String>(
        id: 'Workspace use',
        domainFn: (entry, number) =>
            'Room: ${entry.key.split(' ')[0]}\nWorkspace: ${entry.key.split(' ')[1]}',
        measureFn: (entry, number) => entry.value,
        data: workspaceUse,
      )
    ];
    return _buildBarChartCard<MapEntry<String, int>>(
        data, 'Booked workspaces [bookings]');
  }

  /// Returns a card with information about how much time has been booked compared to the total amount.
  Widget _buildUseRateCard(double useRate, int bookedMinutes) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
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
                        'Usage rate in the past three weeks',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                          '${(bookedMinutes / 60).toStringAsFixed(1)} Hours booked',
                          style: const TextStyle(fontSize: 36)),
                      Text(
                          '${(useRate * 100).toStringAsFixed(1)} % of bookable hours',
                          style: const TextStyle(fontSize: 36)),
                    ],
                  )),
              color: Colors.grey.shade100,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a card with information about offices
  Widget _buildFutureBookingsCard(int numberOfFutureBookings) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
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
                        'Number of future bookings',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text('$numberOfFutureBookings Future bookings',
                          style: const TextStyle(fontSize: 36))
                    ],
                  )),
              color: Colors.grey.shade100,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a card with bar charts showing equipment use.
  Widget _buildEquipmentChartCard(List<MapEntry<String, int>> equipmentUse) {
    if (equipmentUse.length > 4) {
      equipmentUse = equipmentUse.sublist(0, 4);
    }
    var data = [
      charts.Series<MapEntry<String, int>, String>(
        id: 'Equipment use',
        domainFn: (entry, number) => entry.key,
        measureFn: (entry, number) => entry.value,
        data: equipmentUse,
      )
    ];
    return _buildBarChartCard<MapEntry<String, int>>(
        data, 'Most booked equipment');
  }

  /// Renders a card with a bar chart based on the information contained in [data].
  Widget _buildBarChartCard<T>(
      List<charts.Series<T, String>> data, String header) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          header,
          style: const TextStyle(fontSize: 24),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          color: Colors.grey.shade100,
          child: SizedBox(
            width: 400,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: charts.BarChart(data)),
            ),
          ),
        ),
      ],
    );
  }

  /// Renders a card with a pie chart based on the information contained in [data].
  Widget _buildPieChartCard<T>(
      List<charts.Series<T, String>> data, String header) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          header,
          style: const TextStyle(fontSize: 24),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          color: Colors.grey.shade100,
          child: SizedBox(
            width: 400,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: charts.PieChart(
                  data,
                  animate: false,
                  behaviors: [charts.DatumLegend<Object>()],
                ),
              ),
            ),
          ),
        ),
      ],
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
          divisionCardFuture =
              backend.generateDivisionReportCard(selectedDivision);
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
}
