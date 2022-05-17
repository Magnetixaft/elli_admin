import 'package:flutter/material.dart';
import 'package:elli_admin/handlers/firebase_handler.dart';


/* Under arbete, men längst ner finns de värdena jag ser som intresanta */
class ReportCard  {

  /// This creates a card item for space specifications
  Widget _buildSpacesCard(String name, int changeCovering_company, int _mostBookedSpace_company) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Change covering: [$changeCovering_company]'),
                  const SizedBox(height: 12),
                  Text('Available work spaces: [$_mostBookedSpace_company]'),
                  const SizedBox(height: 12)
                ],
              )
          ),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }



 /* Weekday occupancy rate (3w avg.) Mån-Fre. Alla värden som är intresannta för analytics */
  var _changeCovering_company = 'init';
  var _mostBookedSpace_company = 'init';


  var _freeSlots = 'init';
  var _occupiedSlots = 'init';
  var _mostBookedSpace_office = 'init';
  var _commonWorkdat_office = 'init';
  var _lastWeekBooking_office = 'init';
  var _2weeksAgo_office = 'init';
  var _changeCovering_office = 'init';


  var _lastWeekBooking_workspace = 'init';
  var _2weeksAgo_workspace = 'init';
  var _changeCovering_workspace = 'init';




}


