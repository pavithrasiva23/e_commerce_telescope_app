import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_a_to_z/models/telescope_model.dart';
import '../db/db_helper.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orderList = [];
  final random = Random.secure();
  //1) Get All Orders
  getAllOrders() {
    DbHelper.getAllOrders().listen((event) {
      orderList = List.generate(event.docs.length,
          (index) => OrderModel.fromJson(event.docs[index].data()));
      notifyListeners();
    });
  }

  //2) Get order by id
   OrderModel getOrderById(String id) =>
       orderList.firstWhere((element) => element.orderId == id);

  //3) Get brand and its total current qty + each section color information
   Future<List<Map<String, dynamic>>> preparePieChartDataForBrand(List<TelescopeModel> telescopeList) async {
     List<Map<String, dynamic>> brandQuantityPercentMapList = [];
     //Fetch single map entry of brand and its total qty
     Map<String, num> brandQuantityMap = await _getBrandQuantityMap(telescopeList);
     //Total qty of the telescopes sold in the order
     num totalQty = 0;
     for(final order in orderList){
       for(final cart in order.itemDetails){
         totalQty+= cart.quantity;
       }
     }

     //This loops run based on the number of brands and assign its respective values against the keys
      for(var key in brandQuantityMap.keys){
        final map = <String, dynamic> {};
        map['brand'] = key; // key is brandName
        map['qty'] = brandQuantityMap[key]; //its value is qty
        map['percent'] = (brandQuantityMap[key]! * 100) / totalQty;
        map['color'] = Color.fromARGB(255, getColorCode, getColorCode, getColorCode);
        //4) Add all single map 'map' to the list<map> 'brandQuantityPercentMapList'
        brandQuantityPercentMapList.add(map);
   }
     return brandQuantityPercentMapList;
   }
      //5) random value generated between 0 to 1 because of using "toDouble()"
      //Wrapped the whole final value under '()' to change from double to integer
      int get getColorCode => (255 * random.nextDouble()).toInt();

  //4) Single brand's - sold out qty - single map entry
  Future<Map<String, num>> _getBrandQuantityMap(List<TelescopeModel> telescopeList) async {
     Map<String, num> brandQuantityMap = {};
     //1) Access List of cartmodel from orderModel list in loop
     for(final order in orderList){
       for(final cart in order.itemDetails){
         //2) Access single cart model to fetch telescope id
         final telescope = telescopeList.firstWhere((element)=> element.id == cart.telescopeId);
         final brandName = telescope.brand.name;
         //If brandName appearing for first time in an iteration then by default value assign as "0" in as a previous qty
         num previousQuantity = brandQuantityMap[brandName] ?? 0;
         //Against the brandQtyMap's key [brandName] assign the "qty"
         brandQuantityMap[brandName] = previousQuantity + cart.quantity;
       }
     }
     return brandQuantityMap;
  }

  //6) Yearly Sales - month vs gross sale
  //num - for month in number, double - for gross sales of its month in a year
  Future<Map<num, double>> prepareLineChartForYearlySale(num year) async {
    Map<num, double> monthlySaleMap = {};
    //Matches with selected year with order placed year
    //converting timestamp to datetime object to compare with selected year
    //Get orders of the specific year
    final yearlyOrderList = orderList.where((order)=> order.orderDate.toDate().year == year).toList();
    for(final order in yearlyOrderList){
      double prevAmt = monthlySaleMap[order.orderDate.toDate().month] ?? 0.0;
      monthlySaleMap[order.orderDate.toDate().month] = prevAmt + order.totalAmount;
    }
    return monthlySaleMap;
  }

  //7) Return List<FLSpots>
  //key - month, its value = gross sale
  List<FlSpot> generateSpots(Map<num, double> map) {
    List<FlSpot> spots = [];
    //key = number of month
    for(final key in map.keys){
      final flSpot =  FlSpot(key.toDouble(), map[key]!);
      spots.add(flSpot);
    }
    return spots;
  }

  // 8) To get the max-Y value - returns the double value (highest gross sale in a year)
  double findMaxY(Map<num, double> map){
    double max = 0.0;
    List<double> values = map.values.toList();
    //values is empty , no sale - 0.0
    if(values.isEmpty){
      return 0.0;
    }
    //sort the values by comparing with the 2 values
    values.sort((a,b)=> a.compareTo(b));
    //Biggest value the last element
    // add random value like 500 with highest sale, because then only while spotting it won't touch the line
    return values.last + 600; //Eg: actual sales value = 10,000 + 500 (random value) => 10,500 will spotted in "10,000"
  }
}