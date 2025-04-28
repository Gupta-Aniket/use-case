// ! part of the code generated either from gpt, calude or supermaven

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/rendering.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String networkStatus = ' '; 
  double height = 0;
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();

    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      setState(() {
        _shownNetworkStatus();
        _connectivityResult =
            results.isNotEmpty ? results.first : ConnectivityResult.none;
        networkStatus = _connectivityResult == ConnectivityResult.none ? "Offline" : "Online"; // * offline 
      });
      print("Connectivity changed: $results"); 
    });
  }

  @override
  void dispose() {

    _subscription.cancel();
    super.dispose();
  }


  Future<void> checkConnectivity() async {
    
    final List<ConnectivityResult> results =
        await Connectivity().checkConnectivity();
    ConnectivityResult result = results.first;
    setState(() {
        _shownNetworkStatus();

      _connectivityResult = result; 
    });
    print("Current connectivity status: $result"); 
  }
  void _shownNetworkStatus(){
    height= 30;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        networkStatus = " "; 
        height = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connectivity Test"), 
      bottom: PreferredSize(preferredSize: Size(double.infinity, 30), 
                            child: Container(
                              child: Text(networkStatus),
                              height: height,
                              color : networkStatus == "Offline" ? Colors.red : Colors.green,
                            )),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Current Connectivity Status:"),
              Text(
                _connectivityResult.toString(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: checkConnectivity,
                child: Text("Check Connectivity"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
