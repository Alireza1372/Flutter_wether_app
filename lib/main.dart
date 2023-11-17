import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/showdataonscreen.dart';
import 'package:weather/getdatefromapi.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'hivedb.dart';

final getDataFromApi = GetDataFromApi();
int responseStatusCode = 0;

final TextEditingController searchBarController = TextEditingController();
String searchKeyword = searchBarController.text;

const Color primaryColor = Color(0xff12113b);
const Color primaryLightColor = Color(0xff323159);
const Color primaryMiddleColor = Color(0xff292850);
const Color secondaryColor = Color(0xfffca701);
const Color primaryTextColor = Color(0xff60617c);
const Color secondaryTextColor = Color(0xfffdfffc);

late Map<dynamic, dynamic> myLocationData;
late Map<dynamic, dynamic> myCurrentData;
late Map<dynamic, dynamic> myWeatherData;
late List<dynamic> forecastDay = ["1", "2", "3"];

String countryOfData = " ";
String cityOfData = " ";
String timeOfData = " ";
String weatherOfData = " ";
String imagePathOfData = " ";
double degreeOfData = 0.0;
double feelingLikeOfData = 0.0;
double minDegreeOfData = 0.0;
double maxDegreeOfData = 0.0;
List<dynamic> litsOfDegreePerHour = [];
const String boxName = "dataOfSearchKeyword";

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SearchKeywordAdapter());
  await Hive.openBox(boxName);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
              color: primaryTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
        ),
        useMaterial3: false,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final box = Hive.box(boxName);

  @override
  void initState() {
    initStatePage();
    print("+++++++++++++ init state++++++++++++");
    print("*--------" + box.get('name').toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("***************setstate**************");

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: FutureBuilder<Map<dynamic, dynamic>>(
              future: getDataFromApi.fetchWeatherData(searchKeyword),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    responseStatusCode == 200) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchBar(),
                      ShowCurrentWeather(
                        time: timeOfData,
                        city: cityOfData,
                        country: countryOfData,
                        degree: degreeOfData,
                        minDegree: minDegreeOfData,
                        maxDegree: maxDegreeOfData,
                        weather: weatherOfData,
                        feelLike: feelingLikeOfData,
                        imagePath: imagePathOfData,
                      ),
                      ShowTodayWeather(
                        data: litsOfDegreePerHour,
                      ),
                      ShowCurrentWeekWeather(
                        data: forecastDay,
                      )
                    ],
                  );
                }
                if (responseStatusCode != 200) {
                  return Column(
                    children: [
                      searchBar(),
                      Center(
                          child: Image.asset(
                              'assets/emptystate/404-not-found.png')),
                    ],
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(100.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            )),
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 20, 24),
          child: Container(
            height: 60,
            width: 280,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: primaryLightColor,
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      primaryMiddleColor,
                      primaryLightColor,
                      primaryTextColor
                    ])),
            child: TextField(
              controller: searchBarController,
              style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 45, top: 30),
                isDense: false,
                hintText: "Search Here !",
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 16, 24),
          child: InkWell(
            onTap: () async {
              final String baseImagePathDay = 'assets/images/day/';
              final String baseImagePathNight = 'assets/images/night/';
              searchKeyword = searchBarController.text;
              await box.put('name', searchKeyword);
              await getDataFromApi.fetchWeatherData(searchKeyword);
              setState(() {
                myLocationData = getDataFromApi.getLocationData();
                myCurrentData = getDataFromApi.getCurrentData();
                myWeatherData = getDataFromApi.getWeatherData();

                cityOfData = myLocationData["name"].toString();
                countryOfData = myLocationData["country"].toString();
                feelingLikeOfData = myCurrentData["feelslike_c"];

                minDegreeOfData = myWeatherData["forecast"]["forecastday"][0]
                    ["day"]["mintemp_c"];
                maxDegreeOfData = myWeatherData["forecast"]["forecastday"][0]
                    ["day"]["maxtemp_c"];

                var parsedDate = DateTime.parse(
                    myLocationData["localtime"].substring(0, 10));
                timeOfData = DateFormat('EEE,d MMMM ').format(parsedDate);

                degreeOfData = myCurrentData["temp_c"];
                weatherOfData = myCurrentData["condition"]["text"];
                var imagePath = myCurrentData["condition"]["icon"].toString();
                var isDay = myCurrentData["is_day"];
                var imageName = imagePath.substring(imagePath.length - 7);
                imagePathOfData = isDay == 1
                    ? baseImagePathDay + imageName
                    : baseImagePathNight + imageName;
                litsOfDegreePerHour =
                    myWeatherData["forecast"]["forecastday"][0]["hour"];

                forecastDay = myWeatherData["forecast"]["forecastday"];
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        primaryMiddleColor,
                        primaryLightColor,
                        primaryTextColor
                      ])),
              width: 60,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(
                  'assets/svg/search.svg',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void initStatePage() async {
    final String baseImagePathDay = 'assets/images/day/';
    final String baseImagePathNight = 'assets/images/night/';
    final String searchedKeyword = await box.get('name');
    print("****" + searchedKeyword);
    await getDataFromApi.fetchWeatherData(searchedKeyword);

    setState(() {
      myLocationData = getDataFromApi.getLocationData();
      myCurrentData = getDataFromApi.getCurrentData();
      myWeatherData = getDataFromApi.getWeatherData();

      cityOfData = myLocationData["name"].toString();
      countryOfData = myLocationData["country"].toString();
      feelingLikeOfData = myCurrentData["feelslike_c"];

      minDegreeOfData =
          myWeatherData["forecast"]["forecastday"][0]["day"]["mintemp_c"];
      maxDegreeOfData =
          myWeatherData["forecast"]["forecastday"][0]["day"]["maxtemp_c"];

      var parsedDate =
          DateTime.parse(myLocationData["localtime"].substring(0, 10));
      timeOfData = DateFormat('EEE,d MMMM ').format(parsedDate);

      degreeOfData = myCurrentData["temp_c"];
      weatherOfData = myCurrentData["condition"]["text"];
      var imagePath = myCurrentData["condition"]["icon"].toString();
      var isDay = myCurrentData["is_day"];
      var imageName = imagePath.substring(imagePath.length - 7);
      imagePathOfData = isDay == 1
          ? baseImagePathDay + imageName
          : baseImagePathNight + imageName;
      litsOfDegreePerHour = myWeatherData["forecast"]["forecastday"][0]["hour"];

      forecastDay = myWeatherData["forecast"]["forecastday"];

      //print(forecastDay.toString() + "++++++++++++");
    });
  }
}
