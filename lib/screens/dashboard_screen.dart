import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:grocery_admin_panel/models/orderSales.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:grocery_admin_panel/widgets/header.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../consts/constants.dart';
import '../providers/userStatistic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../widgets/commentList.dart';
import '../widgets/mini_information_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/mini_information_widget.dart';
class DashboardScreen extends StatefulWidget {
   const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {

  DateRangePickerController _datePickerController = DateRangePickerController();
  static List<OrderSales> _orders = [];
  static List<UserStats> _users = [];
  static List<double> ratings = [];
  List<UserStats> usersStats = [];
  List<OrderSales> processedData = [];
  late String orderDateStr;
  int? cancelled = 2;
  int? delivered = 2;
  int? orders = 2;
  int? pending = 2;
  double? rating = 0.0;
  int ratingLength = 0;
  double five = 0;
  double four = 0;
  double three = 0;
  double two = 0;
  double one = 0;
  int? cart;
  String? _selectedDate;
  num allSales = 0;
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  @override
  void initState() {
    ratings.clear();
    processedData.clear();
    _orders.clear();
    usersStats.clear();
    _users.clear();
    getRating();
    getOrdersData();
    getUsersData();
    getStatistics();
    super.initState();
  }
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    if(args.value.endDate == null){
    return;
    }else{
setState((){
  processedData.clear();
  _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
  // ignore: lines_longer_than_80_chars
      ' ${DateFormat('dd/MM/yyyy').format(args.value.startDate ?? args.value.endDate)}';


  for (int i = 0; i <= args.value.endDate.difference(args.value.startDate).inDays; i++) {
    for (var dailySales in _orders) {
      num sales = 0;

      final dailyFormat = DateFormat("d-MM-yyyy").format(args.value.startDate.add(Duration(days: i)));

      for (int i = 0; i < _orders.length; i++) {

        final dateFromData = DateFormat("d-MM-yyyy").format(_orders[i].orderDate);
       /* print(dateFromData);*/
        if (dateFromData == dailyFormat) {
          sales += _orders[i].price;
        }
      }
      processedData.insert(0,OrderSales(orderDate: DateFormat("dd-MM-yyyy").parse(dailyFormat), price: sales));
    }
  }
  final Map<DateTime, OrderSales> map = {
    for (var dailySales in processedData) dailySales.orderDate : dailySales,
  };
  processedData = map.values.toList();
 processedData.sort((a,b) {
    var adate = a.orderDate; //before -> var adate = a.expiry;
    var bdate = b.orderDate;//var bdate = b.expiry;
    return -bdate.compareTo(adate);
  });




  usersStats.clear();
  for (int i = 0; i <= args.value.endDate.difference(args.value.startDate).inDays; i++) {
    for (var dailySales in _users) {
      int sales = 0;
      final dailyFormat = DateFormat("d-MM-yyyy").format(args.value.startDate.add(Duration(days: i)));
      for (int i = 0; i < _users.length; i++) {
        final dateFromData = DateFormat("d-MM-yyyy").format(
            _users[i].createdAt);

        if (dateFromData == dailyFormat) {
          sales += _users[i].users;
        }
      }
      usersStats.insert(0, UserStats(
          createdAt: DateFormat("dd-MM-yyyy").parse(dailyFormat),
          users: sales));
    }
  }
    final Map<DateTime, UserStats> maps = {
      for (var dailySales in usersStats) dailySales.createdAt: dailySales,
    };
    usersStats = maps.values.toList();
  usersStats.sort((a,b) {
    var adate = a.createdAt; //before -> var adate = a.expiry;
    var bdate = b.createdAt;//var bdate = b.expiry;
    return -bdate.compareTo(adate);
  });

});
    }


  }
  Future getUsersData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((snapshot) => {
      setState(() {
        snapshot.docs.forEach((element) {
          _users.insert(
              0,
              UserStats(users: 1, createdAt: element.get('createdAt').toDate())
          );
        });
      })
    });
    _users.sort((a,b) {
      var adate = a.createdAt; //before -> var adate = a.expiry;
      var bdate = b.createdAt;//var bdate = b.expiry;
      return -adate.compareTo(bdate);
    });
    for (var dailySales in _users) {
      int sales = 0;

      final dailyFormat = DateFormat("dd-MM-yyyy").format(dailySales.createdAt);

      for (int i = 0; i < _users.length; i++) {

        final dateFromData = DateFormat("dd-MM-yyyy").format(_users[i].createdAt);

        if (dateFromData == dailyFormat) {
          sales += _users[i].users;
        }
      }
      usersStats.insert(0,UserStats(createdAt: DateFormat("dd-MM-yyyy").parse(dailyFormat), users: sales));
    }
    final Map<DateTime, UserStats> maps = {
      for (var dailySales in usersStats) dailySales.createdAt : dailySales,
    };
    usersStats = maps.values.toList();
  }
  Future getOrdersData() async {
    await FirebaseFirestore.instance
        .collection("orders")
        .where('delivered',whereIn:[true])
        .get()
        .then((snapshot) => {

      setState((){
        snapshot.docs.forEach((element) {

          _orders.insert(
              0,
              OrderSales(price: element.get('totalPrice'), orderDate: element.get('orderDate').toDate())
          );
        });
      })
    });

    _orders.sort((a,b) {
      var adate = a.orderDate; //before -> var adate = a.expiry;
      var bdate = b.orderDate;//var bdate = b.expiry;
      return -adate.compareTo(bdate);
    });
    for (var dailySales in _orders) {
      num sales = 0;

      final dailyFormat = DateFormat("dd-MM-yyyy").format(dailySales.orderDate);

      for (int i = 0; i < _orders.length; i++) {

        final dateFromData = DateFormat("dd-MM-yyyy").format(_orders[i].orderDate);

        if (dateFromData == dailyFormat) {
          sales += _orders[i].price;
        }
      }
      processedData.insert(0,OrderSales(orderDate: DateFormat("dd-MM-yyyy").parse(dailyFormat), price: sales));
    }
    final Map<DateTime, OrderSales> map = {
      for (var dailySales in processedData) dailySales.orderDate : dailySales,
    };
    processedData = map.values.toList();

  }

  Future getRating() async {
    await FirebaseFirestore.instance
        .collection("feedback")
        .get()
        .then((snapshot) => {
      setState(() {
        snapshot.docs.forEach((element) {
          ratings.insert(0, element.get('rating'));
        });
      })
    });
    for (var dailySales in ratings) {
      double saless = 0.0;
      int fives = 0;
      int fours = 0;
      int threes = 0;
      int twos = 0;
      int ones = 0;
      for (int i = 0; i < ratings.length; i++) {
        final ratingList = ratings[i].toInt();
        if (ratingList == 5) {
          fives++;

        }
        if (ratingList == 4) {
          fours++;
        }
        if (ratingList == 3) {
          threes++;
        }
        if (ratingList == 2) {
          twos++;
        }
        if (ratingList == 1) {
          ones++;
        }
      }
      five = fives / ratings.length;
      four = fours / ratings.length;
      three = threes / ratings.length;
      two = twos / ratings.length;
      one = ones / ratings.length;
    }

    for (var dailySales in ratings) {
      double saless = 0.0;
      for (int i = 0; i < ratings.length; i++) {
        saless += ratings[i];

      }

      rating = saless / ratings.length;
      ratingLength = ratings.length;
    }



  }

   Future getStatistics() async {
     await FirebaseFirestore.instance
         .collection("orders")
         .where('cancelled',whereIn:[true])
         .get()
         .then((snapshot) => {
       setState((){
         cancelled = snapshot.docs.length;
       })
     });
     await FirebaseFirestore.instance
         .collection("orders")
         .where('delivered',whereIn:[true])
         .get()
         .then((snapshot) => {
       setState((){
         delivered = snapshot.docs.length;
       })

     });

     await FirebaseFirestore.instance
        .collection("orders")
        .get()
        .then((snapshot) => {
          setState((){
            orders = snapshot.docs.length;
          })
     });
     pending = orders! - delivered! - cancelled!;



       for (var dailySales in _orders) {
         num saless = 0;
         for (int i = 0; i < _orders.length; i++) {
             saless += _orders[i].price;
         }
           allSales = saless;
       }
       String result = allSales.toString().replaceAllMapped(reg, mathFunc);

   }




  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(

            children: [
              Padding(
              padding: const EdgeInsets.all(16),
              child:   Header(),
              ),
              Column(
                children: [

              /*    Padding(
                    padding: EdgeInsets.all(16),
                    child: MiniInformation(),
                  ),*/
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: queryData.size.width/ 8,
                              width: queryData.size.width/ 9,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) { // if snapshot has no data this is going to run
                                      return Container(
                                          alignment: FractionalOffset.center,
                                          child: CircularProgressIndicator());
                                    }
                                    else{ // if snapshot has data this is going to run
                                      int orders = snapshot.data!.docs.length;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Theme.of(context).cardColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(FlutterIcons.money_bill_alt_faw5,color: Color(0xFF00F260), size: queryData.size.width /40,),
                                                Spacer(),
                                                Center(child: TextWidget(text: '₱$allSales', color: color, textSize: queryData.size.width /40, isTitle:true)),
                                                Spacer(),
                                                Center(child: TextWidget(text: 'Total Sales', color: color, textSize: queryData.size.width / 80, )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                              ),
                            )
                        ),
                      ),

                      Expanded(child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: queryData.size.width/ 8,
                          width: queryData.size.width/ 9,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('users').snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) { // if snapshot has no data this is going to run
                                  return Container(
                                      alignment: FractionalOffset.center,
                                      child: CircularProgressIndicator());
                                }
                                else{ // if snapshot has data this is going to run
                                  int customers = snapshot.data!.docs.length;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Theme.of(context).cardColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(FlutterIcons.user_alt_faw5s,color: Color(0xFF00F260), size: queryData.size.width /40,),
                                            Spacer(),
                                            Center(child: TextWidget(text: '$customers', color: color, textSize: queryData.size.width /40, isTitle:true)),
                                            Spacer(),
                                            Center(child: TextWidget(text: 'Total Customers', color: color, textSize: queryData.size.width / 80, )),



                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                          ),
                        ),
                      ),
                      ),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: queryData.size.width/ 8,
                            width: queryData.size.width/ 9,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('products').snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) { // if snapshot has no data this is going to run
                                    return Container(
                                        alignment: FractionalOffset.center,
                                        child: CircularProgressIndicator());
                                  }
                                  else{ // if snapshot has data this is going to run
                                    int products = snapshot.data!.docs.length;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Theme.of(context).cardColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Icon(FlutterIcons.shop_ent,color: Color(0xFF00F260), size: queryData.size.width /40,),
                                              Spacer(),
                                              Center(child: TextWidget(text: '$products', color: color, textSize: queryData.size.width /40, isTitle:true)),
                                              Spacer(),
                                              Center(child: TextWidget(text: 'Total Products', color: color, textSize: queryData.size.width / 80, )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                            ),
                          ),
                        ),
                      ),

                      Expanded(child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: queryData.size.width/ 8,
                          width: queryData.size.width/ 9,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) { // if snapshot has no data this is going to run
                                  return Container(
                                      alignment: FractionalOffset.center,
                                      child: CircularProgressIndicator());
                                }
                                else{ // if snapshot has data this is going to run
                                  int orders = snapshot.data!.docs.length;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Theme.of(context).cardColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(FlutterIcons.receipt_faw5s,color: Color(0xFF00F260), size: queryData.size.width /40,),
                                            Spacer(),
                                            Center(child: TextWidget(text: '$orders', color: color, textSize: queryData.size.width /40, isTitle:true)),
                                            Spacer(),
                                            Center(child: TextWidget(text: 'Total Orders', color: color, textSize: queryData.size.width / 80, )),


                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                              }
                          ),
                        ),
                      ),
                      ),

                    ],
                  ),
                ],
              ),
            /*  const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Header(
                ),
              ),
              const SizedBox(
                height: 20,
              ),*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex:1,
                      // flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 700,
                          child: Material(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).cardColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      // Chart title
                                      title: ChartTitle(text: 'Sales Chart', textStyle: TextStyle(
                                        fontSize: 20
                                      )),
                                      // Enable legend
                                      legend: Legend(isVisible: true),
                                      // Enable tooltip
                                      tooltipBehavior: TooltipBehavior(enable: true),
                                      series: <ChartSeries<OrderSales, String>>[
                                        LineSeries<OrderSales, String>(
                                            dataSource: processedData,
                                            xValueMapper: (OrderSales sales, _) => '${DateFormat("MMM dd").format(sales.orderDate)} ',
                                            yValueMapper: (OrderSales sales, _) => sales.price,
                                            name: 'Line',
                                            color: Colors.orangeAccent,
                                            // Enable data label
                                            dataLabelSettings: DataLabelSettings(isVisible: true)),
                                        ColumnSeries(dataSource: processedData,
                                          xValueMapper: (OrderSales sales, _) => '${DateFormat("MMM dd").format(sales.orderDate)} ',
                                          yValueMapper: (OrderSales sales, _) => sales.price,
                                          name: 'Column',
                                            color: Colors.blueAccent,
                                            selectionBehavior: SelectionBehavior(
                                                enable: true,
                                                selectedColor: Colors.blueAccent,
                                                unselectedColor: Colors.grey),
                                            dataLabelSettings: DataLabelSettings(isVisible: true))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ,
                                      ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    // Chart title
                                    title: ChartTitle(text: 'Users Chart',textStyle: TextStyle(
                                        fontSize: 20
                                    )),
                                    // Enable legend
                                    legend: Legend(isVisible: true),
                                    // Enable tooltip
                                    tooltipBehavior: TooltipBehavior(enable: true),
                                    series: <ChartSeries<UserStats, String>>[
                                      LineSeries<UserStats, String>(
                                          dataSource: usersStats,
                                          xValueMapper: (UserStats stats, _) => '${DateFormat("MMM dd").format(stats.createdAt)} ',
                                          yValueMapper: (UserStats stats, _) => stats.users,
                                          name: 'Line',

                                          color: Colors.yellow,
                                          dataLabelSettings: DataLabelSettings(isVisible: true)
                                      ),
                                      SplineAreaSeries(
                                          dataSource: usersStats,
                                          xValueMapper: (UserStats stats, _) => '${DateFormat("MMM dd").format(stats.createdAt)} ',
                                          yValueMapper: (UserStats stats, _) => stats.users,
                                          name: 'Spline',

                                          color: Colors.blueAccent,
                                          dataLabelSettings: DataLabelSettings(isVisible: true)
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                 /*     Expanded(
                      // flex: 5,
                      child: Card(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          children: [



                          ],
                        ),
                      ),
                    ),*/


                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 700,
                          child: Material(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).cardColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget(text: 'All Orders', color: color,textSize: 20,),

                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: AspectRatio(
                                          aspectRatio: 27/9,
                                          /*aspectRatio: 16 / 9,*/
                                          child: DChartPie(
                                            data: [
                                              {'domain': 'Cancelled', 'measure': cancelled},
                                              {'domain': 'Delivered', 'measure': delivered},
                                              {'domain': 'Pending', 'measure': pending},
                                            ],
                                            fillColor: (pieData, index) {
                                              switch (pieData['domain']) {
                                                case 'Cancelled':
                                                  return Colors.red;
                                                case 'Delivered':
                                                  return Colors.blueAccent;
                                                default:
                                                  return Colors.orangeAccent;
                                              }
                                            },
                                            pieLabel: (pieData, index) {
                                              return "${pieData['measure']}";
                                            },
                                            labelPosition: PieLabelPosition.inside,
                                            labelFontSize: (queryData.size.width / 60).round(),
                                            labelColor: color,
                                            donutWidth: 40,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextWidget(text: 'Delivered', color: color,textSize: queryData.size.width / 100,),
                                          Icon(Icons.circle,color: Colors.blueAccent,size: queryData.size.width / 100,),
                                          SizedBox(width: 10,),
                                          TextWidget(text: 'Cancelled', color: color,textSize: queryData.size.width / 100,),
                                          Icon(Icons.circle,color: Colors.red,size:queryData.size.width / 100,),
                                          SizedBox(width: 10,),
                                          TextWidget(text: 'Pending', color: color,textSize: queryData.size.width / 100,),
                                          Icon(Icons.circle,color: Colors.orange,size:queryData.size.width / 100,),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SfDateRangePicker(
                                  controller: _datePickerController,
                                  onSelectionChanged: selectionChanged,
                                  selectionMode: DateRangePickerSelectionMode.range,
                                  selectionColor: Colors.white,
                                  cancelText: 'Reset',
                                  todayHighlightColor: Colors.white,
                                  showActionButtons: false,
                                  view: DateRangePickerView.month,
                                  selectionTextStyle: const TextStyle(color: Colors.white),
                                  startRangeSelectionColor: Colors.blue,
                                  endRangeSelectionColor: Colors.blue,
                                  rangeSelectionColor: Colors.blueAccent,
                                  rangeTextStyle: TextStyle(
                                  color: color, fontSize: 15),


                                ),
                              ),
                                AnimatedButton(
                                  height: 40,
                                  width: 200,
                                  text: 'Reset',
                                  isReverse: true,
                                  textAlignment: Alignment.center,
                                  animatedOn: AnimatedOn.onHover,
                                  animationDuration: Duration(milliseconds: 500),
                                  selectedBackgroundColor: Colors.blue.shade400,
                                  selectedTextColor: Colors.black,
                                  transitionType: TransitionType.BOTTOM_CENTER_ROUNDER,
                                  backgroundColor: Colors.blue.shade900,
                                  borderRadius: 16,
                                  borderWidth: 2,
                                  onPress: () {

                                      setState(() {

                                        ratings.clear();
                                        processedData.clear();
                                        _orders.clear();
                                        usersStats.clear();
                                        _users.clear();
                                        getRating();
                                        getOrdersData();
                                        getUsersData();
                                        getStatistics();
                                        _datePickerController.selectedRanges = null;
                                      });

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 100),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          /*// flex: 5,*/
                          child: Container(
                            height: queryData.size.width /1.6,
                            child: Card(
                              color: Theme.of(context).cardColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(text: 'Reviews & Ratings', color: color, textSize: queryData.size.width /80,),
                                    Divider(thickness: 2,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                            child: Column(
                                            children: [
                                            TextWidget(text: '${rating!.toStringAsFixed(1)}', color: color, textSize: queryData.size.width /20,),
                                            RatingBar.builder(
                                              initialRating: rating!,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: queryData.size.width /60,
                                              ignoreGestures: true,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.blue,
                                              ),
                                              onRatingUpdate: (rating) {
                                              },
                                            ),
                                             TextWidget(text: '${ratingLength} reviews', color: color, textSize: queryData.size.width /150,),

                                          ],
                                        ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text('5'),
                                                Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: LinearPercentIndicator(
                                                    barRadius: Radius.circular(20),
                                                    width: queryData.size.width /3,
                                                    lineHeight: 15,
                                                    percent: five,
                                                    progressColor: Colors.blue,
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 5,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: queryData.size.width /80,
                                                  ignoreGestures: true,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                  ), onRatingUpdate: (double value) {  },
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('4'),
                                                Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: LinearPercentIndicator(
                                                    barRadius: Radius.circular(20),
                                                    width: queryData.size.width /3,
                                                    lineHeight: 15,
                                                    percent: four,
                                                    progressColor: Colors.blue,
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 4,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: queryData.size.width /80,
                                                  ignoreGestures: true,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                  ), onRatingUpdate: (double value) {  },
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('3'),
                                                Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: LinearPercentIndicator(
                                                    barRadius: Radius.circular(20),
                                                    width: queryData.size.width /3,
                                                    lineHeight: 15,
                                                    percent: three,
                                                    progressColor: Colors.blue,
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 3,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: queryData.size.width /80,
                                                  ignoreGestures: true,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                  ), onRatingUpdate: (double value) {  },
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('2'),
                                                Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: LinearPercentIndicator(
                                                    barRadius: Radius.circular(20),
                                                    width: queryData.size.width /3,
                                                    lineHeight: 15,
                                                    percent: two,
                                                    progressColor: Colors.blue,
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 2,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: queryData.size.width /80,
                                                  ignoreGestures: true,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                  ), onRatingUpdate: (double value) {  },
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('1'),
                                                Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: LinearPercentIndicator(
                                                    barRadius: Radius.circular(20),
                                                    width: queryData.size.width /3,
                                                    lineHeight: 15,
                                                    percent: one,
                                                    progressColor: Colors.blue,
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 1,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: queryData.size.width /80,
                                                  ignoreGestures: true,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                  ), onRatingUpdate: (double value) {  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    TextWidget(text: 'Reviews', color: color, textSize: queryData.size.width /60),
                                    Flexible(
                                      child: SingleChildScrollView(
                                        controller: ScrollController(),
                                        child: commentList(isInDashboard: false,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

      ),

    );
  }
}