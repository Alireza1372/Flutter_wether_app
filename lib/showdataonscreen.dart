import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'main.dart';

final hours = [
  "00:00 AM",
  "01:00 AM",
  "02:00 AM",
  "03:00 AM",
  "04:00 AM",
  "05:00 AM",
  "06:00 AM",
  "07:00 AM",
  "08:00 PM",
  "09:00 PM",
  "10:00 PM",
  "11:00 PM",
  "12:00 PM",
  "13:00 PM",
  "14:00 PM",
  "15:00 PM",
  "16:00 PM",
  "17:00 AM",
  "18:00 AM",
  "19:00 AM",
  "20:00 AM",
  "21:00 AM",
  "22:00 AM",
  "23:00 AM",
];

class ShowCurrentWeather extends StatefulWidget {
  final String time;

  final String city;
  final String country;
  final double degree;
  final double maxDegree;
  final double minDegree;
  final String weather;
  final double feelLike;
  final String imagePath;

  const ShowCurrentWeather(
      {super.key,
      required this.time,
      required this.degree,
      required this.maxDegree,
      required this.minDegree,
      required this.weather,
      required this.feelLike,
      required this.city,
      required this.country,
      required this.imagePath});

  @override
  State<ShowCurrentWeather> createState() => _ShowCurrentWeatherState();
}

class _ShowCurrentWeatherState extends State<ShowCurrentWeather> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 320,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
            primaryMiddleColor,
            primaryLightColor,
            primaryTextColor
          ])),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.time,
                  style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.city + ",",
                  style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.country,
                  style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      widget.degree.toString(),
                      style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      " \u2103",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Transform.rotate(
                      angle: 90 / 4 * pi,
                      child: SvgPicture.asset(
                        'assets/svg/arrow.svg',
                        width: 20,
                        color: primaryTextColor,
                      ),
                    ),
                    Text(widget.minDegree.toString(),
                        style: const TextStyle(
                            color: primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const Text(
                      " \u2103",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Transform.rotate(
                      angle: 3 * pi / 2,
                      child: SvgPicture.asset('assets/svg/arrow.svg',
                          width: 20, color: primaryTextColor),
                    ),
                    Text(widget.maxDegree.toString(),
                        style: const TextStyle(
                            color: primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const Text(
                      " \u2103",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.weather,
                  style: const TextStyle(
                      color: secondaryTextColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "Feelings Like ${widget.feelLike}",
                      style: const TextStyle(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(" \u2103",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            widget.imagePath,
            width: 132,
          )
        ],
      ),
    );
  }
}

class ShowTodayWeather extends StatefulWidget {
  const ShowTodayWeather({super.key, required this.data});
  final List<dynamic> data;

  @override
  State<ShowTodayWeather> createState() => _ShowTodayWeatherState();
}

class _ShowTodayWeatherState extends State<ShowTodayWeather> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              "Today",
              style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 24,
              itemBuilder: (context, index) {
                String basePath = 'assets/images/';
                int isDay = widget.data[index]["is_day"];
                String imageName =
                    widget.data[index]["condition"]["icon"].toString();
                var imageTempName = imageName.substring(imageName.length - 7);

                String imagePathOfHour = isDay == 1
                    ? basePath + "day/" + imageTempName
                    : basePath + "night/" + imageTempName;

                return _ShowTodayWeatherItem(
                  hour: hours[index],
                  imagePath: imagePathOfHour,
                  degree: widget.data[index]["temp_c"],
                  rainPercentage: widget.data[index]["chance_of_rain"],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ShowTodayWeatherItem extends StatelessWidget {
  final String hour;
  final String imagePath;
  final double degree;
  final int rainPercentage;

  const _ShowTodayWeatherItem(
      {super.key,
      required this.hour,
      required this.imagePath,
      required this.degree,
      required this.rainPercentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            hour,
            style: const TextStyle(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Image.asset(
            imagePath,
            width: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(degree.toString(),
                  style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const Text(" \u2103",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/rain-drop.svg',
                color: Colors.lightBlueAccent,
                width: 10,
              ),
              const SizedBox(
                width: 8,
              ),
              Text("$rainPercentage %",
                  style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );
  }
}

class ShowCurrentWeekWeather extends StatefulWidget {
  const ShowCurrentWeekWeather({super.key, required this.data});
  final List<dynamic> data;

  @override
  State<ShowCurrentWeekWeather> createState() => _ShowCurrentWeekWeatherState();
}

class _ShowCurrentWeekWeatherState extends State<ShowCurrentWeekWeather> {
  String getImagePath(String imagePath) {
    String baseImagePath = 'assets/images/day/';
    var imageName = imagePath.substring(imagePath.length - 7);
    final String imageAddress = baseImagePath + imageName;

    return imageAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 260,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: primaryLightColor,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  primaryMiddleColor,
                  primaryLightColor,
                  primaryTextColor
                ])),
        child: Column(
          children: [
            _ShowCurrentWeekWeatherItem(
                day: DateFormat('EEEE ')
                    .format(DateTime.parse(widget.data[0]['date'].toString())),
                rainPercentageOfDay: widget.data[0]['day']
                    ["daily_chance_of_rain"],
                imagePath:
                    getImagePath(widget.data[1]['day']['condition']["icon"]),
                degree: widget.data[0]['day']["avgtemp_c"]),
            _ShowCurrentWeekWeatherItem(
                day: DateFormat('EEEE ')
                    .format(DateTime.parse(widget.data[1]['date'].toString())),
                rainPercentageOfDay: widget.data[1]['day']
                    ["daily_chance_of_rain"],
                imagePath:
                    getImagePath(widget.data[1]['day']['condition']["icon"]),
                degree: widget.data[1]['day']["avgtemp_c"]),
            _ShowCurrentWeekWeatherItem(
                day: DateFormat('EEEE ')
                    .format(DateTime.parse(widget.data[2]['date'].toString())),
                rainPercentageOfDay: widget.data[2]['day']
                    ["daily_chance_of_rain"],
                imagePath:
                    getImagePath(widget.data[2]['day']['condition']["icon"]),
                degree: widget.data[2]['day']["avgtemp_c"]),
          ],
        ),
      ),
    );
  }
}

class _ShowCurrentWeekWeatherItem extends StatelessWidget {
  final String day;
  final int rainPercentageOfDay;
  final String imagePath;
  final double degree;

  const _ShowCurrentWeekWeatherItem(
      {super.key,
      required this.day,
      required this.rainPercentageOfDay,
      required this.imagePath,
      required this.degree});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            width: 100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/rain-drop.svg',
                    color: Colors.lightBlueAccent,
                    width: 15,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    "$rainPercentageOfDay %",
                    style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Image.asset(
                    imagePath,
                    width: 15,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    "$degree ",
                    style: const TextStyle(
                        color: Colors.white24,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(" \u2103",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
