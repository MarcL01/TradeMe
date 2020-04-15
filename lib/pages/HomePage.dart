import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trademe/models/TradeItemListing.dart';
import 'package:trademe/utils/LocationUtils.dart';
import 'package:trademe/utils/SettingsUtils.dart';

Firestore _firestore = Firestore.instance;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SearchSettings filterSettings;
  List<TradeItemListing> tradeItems;
  GeoPoint currentLocation = GeoPoint(1, 1);
  GlobalKey scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    filterSettings = SearchSettings();
//    loadCurrentLocation();
    tradeItems = new List();
    super.initState();
    loadSearchResults();
  }

  loadCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    if (position == null) {
      position = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    }
    if (position == null) {
      setState(() {
        currentLocation = GeoPoint(1, 1);
      });
    } else {
      setState(() {
        currentLocation = GeoPoint(position.latitude, position.longitude);
      });
    }
  }

  Future<Void> loadSearchResults() async {
    Map<String, String> hashRange = LocationUtils.getGeohashRange(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        distance: (filterSettings.getSetting("withinMiles") as int).toDouble());
    QuerySnapshot results = await Firestore.instance
        .collection('tradeItems')
        .where("locationHash", isGreaterThanOrEqualTo: hashRange["lower"])
        .where("locationHash", isLessThanOrEqualTo: hashRange["upper"])
        .getDocuments();

    tradeItems.clear();
    results.documents.forEach((doc) {
      print(doc.data.toString());
      tradeItems.add(TradeItemListing(
          name: doc.data["name"],
          ownerUUID: doc.data["owner"],
          images: doc.data["images"].cast<String>(),
          description: doc.data["description"],
          category: doc.data["category"]));
    });
    setState(() {
      tradeItems.length;
    });
//    print(results.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[new Container()],
        title: Text("TradeMe"),
        backgroundColor: Colors.green,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44.0),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: Container(
              padding: EdgeInsets.only(
                left: 10.0,
                bottom: 10.0,
                right: 10.0,
              ),
              height: 44.0,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print(
                        "show filter",
                      );
                      (scaffoldKey.currentState as ScaffoldState)
                          .openEndDrawer();
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.slidersH,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "Filter:",
              ),
              margin: EdgeInsets.zero,
            ),
            Text(
                "Search Radius: ${filterSettings.getDirtyOrClean("withinMiles")}"),
            Slider(
              value: (filterSettings.getDirtyOrClean("withinMiles") as int)
                  .toDouble(),
              onChanged: (newVal) {
                setState(() {
                  filterSettings.changeSetting("withinMiles", newVal.toInt());
                });
              },
              min: 5,
              max: 250,
              label: "${filterSettings.getDirtyOrClean("withinMiles")} Miles",
              semanticFormatterCallback: (double newValue) {
                return '${newValue.toInt()} miles';
              },
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                setState(
                  () {
                    filterSettings.saveSettings();
                    loadSearchResults();
                    (scaffoldKey.currentState as ScaffoldState).openDrawer();
                  },
                );
              },
              child: Text("Apply"),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadSearchResults,
        child: ListView.builder(
          itemBuilder: (context, index) {
            TradeItemListing item = tradeItems[index];
            return Card(
              margin: EdgeInsets.all(20.0),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(item.images.join(",")),
                    Text(item.name),
                    Text(item.description),
                    Text(item.category),
                    Text(item.ownerUUID),
                  ],
                ),
              ),
            );
          },
          itemCount: tradeItems.length,
        ),
      ),
    );
  }
}
