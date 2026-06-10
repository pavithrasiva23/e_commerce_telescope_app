import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_to_z/providers/order_provider.dart';
import 'package:shop_a_to_z/providers/telescope_provider.dart';

class ReportPage extends StatefulWidget {
  static const String routeName = 'report';
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //Pie Chart
              Text("Brand Name vs sold out(%)"),
              SizedBox(
                height: 300,
                width: 300,
                child: Consumer<OrderProvider>(
                    builder: (context, provider, child)=>
                    FutureBuilder<List<Map<String, dynamic>>>(
                        future: provider.preparePieChartDataForBrand(Provider.of<TelescopeProvider>(context,listen: false).telescopeList),
                        builder:(context, snapshot) {
                          if (snapshot.hasData) {
                            final mapList = snapshot.data!;
                            return PieChart(
                                PieChartData(
                                    sections: mapList.map((e) =>
                                        PieChartSectionData(
                                            title: '${e['brand']}\n${(e['percent'] as double)
                                                .round()}%',
                                            //return rounded decimal value
                                            showTitle: true,
                                            value: e['percent'],
                                            color: e['color'],
                                            radius: 90,
                                            titleStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: Colors.white
                                            )
                                        )).toList()
                                )
                            );
                          }
                          if(snapshot.hasError){
                            return const Center(
                              child: Text('Error loading data'),
                            );
                          }
                          return Center(child: const CircularProgressIndicator());
                        }
                        )
                )
                //buildLineChart(),
              ),
              SizedBox(height: 10,),
              //Line Chart
              //Year Picker for line chart
              SizedBox(
                height: 200,
                width: 200,
                child: YearPicker(
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    selectedDate: selectedDate,
                    onChanged: (value){
                      setState(() {
                        selectedDate = value;
                      });
                    }),
              ),
          Text("Month vs Gross Sales (in Year)"),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.8,
            height: 300,
            child: Consumer<OrderProvider>(
                builder: (context, provider, child)=>
                    FutureBuilder<Map<num, double>>(
                        future: provider.prepareLineChartForYearlySale(selectedDate.year),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            final map = snapshot.data!;
                            return LineChart(
                              LineChartData(
                                minX: 1,
                                minY: 0,
                                maxX: 12,
                                maxY: provider.findMaxY(map),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: provider.generateSpots(map),
                                    isCurved: true,
                                    isStrokeCapRound: true,
                                    barWidth: 4,
                                    color: Colors.deepPurple
                                  ),
                                ],
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)
                                  ),
                                  rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)
                                  ),
                                  // leftTitles: const AxisTitles(
                                  //  // axisNameWidget: const Text('Gross Sales in month'),
                                  //   sideTitles: SideTitles(
                                  //     showTitles: true
                                  //   )
                                  // ),
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: const Text('Month of the year'),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30, //reserved specific space for each section
                                      getTitlesWidget: getBottomTitleWidgets
                                    )
                                  )
                                )
                              )
                            );
                          }
                          if(snapshot.hasError){
                            return const Center(
                              child: Text('Error loading data'),
                            );
                          }
                          return Center(child: const CircularProgressIndicator());
                        }
                        ))
          )
            ],
          ),
        ),
      ),
    );
  }

  Widget getBottomTitleWidgets(double value, TitleMeta meta) {
    //Based on the values, only decide what text needs to be shown
    Widget txt;
    const style = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold
    );
    switch(value.toInt()){
      case 2:
        txt = const Text('FEB', style: style);
        break;
      case 4:
        txt = const Text('APR', style: style);
        break;
      case 6:
        txt = const Text('JUN', style: style);
        break;
      case 8:
        txt = const Text('AUG', style: style);
        break;
      case 10:
        txt = const Text('OCT', style: style);
        break;
      case 12:
        txt = const Text('DEC', style: style);
        break;
      default:
        txt = const Text('', style: style,);
        break;
    }
    //SideTitleWidget - coming from the FLChart
    return SideTitleWidget(
        child: txt,
        meta: meta);
  }




//Basic Examples:
  PieChart buildPieChart() {
    return PieChart(
        PieChartData(
          //pietouchdata = if touch the data in the pie chart then that part of pie will be increased in size (zoom-out)
            sections: generateSections()
        )
    );
  }

  List<PieChartSectionData> generateSections() {
    return List.generate(4, (index)=> PieChartSectionData(
      value: 25.0,
      title: 'Title ${index + 1}',
      showTitle: true,
      radius: 70, //thickness of the pie chart
      color: Color.fromARGB(255, 150, 20 * index, 30 * index), //255, 150, 20*0= 0, 0
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      borderSide: BorderSide(width: 5, color: Colors.yellow, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignInside),
    ));
  }

  LineChart buildLineChart() {
   return LineChart(
     LineChartData(
       //min & max values for x & y axis
       minX: 0,
       minY: 0,
       maxX: 11, //0-11 months (12 months)
         maxY: 6,
       lineBarsData: [
         LineChartBarData(
           spots: [
             FlSpot(0, 0.5),
             FlSpot(1, 3),
             FlSpot(2, 6),
             FlSpot(3, 4),
             FlSpot(4, 3),
             FlSpot(5, 2),
             FlSpot(7, 6),
             FlSpot(9, 5),
           ],
           isCurved: true, //shows like curvy lines
           isStrokeCapRound: true,
           barWidth: 4, //line width
           color: Colors.amber,//line of the color
         )
       ]
     )
   );
  }
}
