import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lara_g_admin/util/app_constants.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Demopage extends StatefulWidget {
  const Demopage({super.key});

  @override
  State<Demopage> createState() => _DemopageState();
}

class _DemopageState extends State<Demopage> {
  // Declare variables to store the fetched data
  List<dynamic> purchaseDetails = [];

  Future<Map<String, String?>> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.TOKEN);
    String? shopId = prefs.getString(AppConstants.SHOPID);

    print('--------------------- $token --------------------');
    print('--------------------- $shopId --------------------');

    return {
      'token': token,
      'shopId': shopId,
    };
  }

  Future<void> fetchPurchaseDetails(
      String token, String shopId, String type) async {
    // Try a different endpoint
    final url =
        'https://tabsquareinfotech.com/App/Clients/lara_g/public/api/inventory';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'shop_id': shopId,
          'type': type,
        }),
      );

      print('Request URL: $url');
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          purchaseDetails = data['result'] ?? [];
        });
        print('Purchase details fetched: ${purchaseDetails.length} items');
      } else {
        print('Failed to load purchase details: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    getdata().then((data) {
      String? token = data['token'];
      String? shopId = data['shopId'];

      if (token != null && shopId != null) {
        fetchPurchaseDetails(token, shopId, 'Inventory');
      } else {
        print('Token or shopId is null');
        // Show some UI feedback that authentication is required
        setState(() {
          // Maybe set a flag to show a "Please login" message
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Details'),
      ),
      body: purchaseDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: purchaseDetails.length,
              itemBuilder: (context, index) {
                final purchase = purchaseDetails[index];
                return ListTile(
                  title: Text(purchase['product_name']),
                  subtitle: Text('Category: ${purchase['category']}'),
                  trailing: Text('Cost: ${purchase['purchase_cost']}'),
                  leading: purchase['image'] != ''
                      ? Image.network(purchase['image'])
                      : const Icon(Icons.image),
                );
              },
            ),
    );
  }
}
