// ignore_for_file: prefer_const_constructors

import 'package:cbs/minor_screens/search.dart';
import 'package:flutter/material.dart';

class FakeScreen extends StatefulWidget {
  const FakeScreen({Key? key}) : super(key: key);

  @override
  State<FakeScreen> createState() => _FakeScreenState();
}

class _FakeScreenState extends State<FakeScreen> {
  @override
  Widget build(BuildContext context) {
    var platformSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SearchScreen()));
      },
      child: Container(
        height: platformSize.height * 0.05,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow, width: 1.4),
            borderRadius: BorderRadius.circular(25)),
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'What are you looking for?',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                height: platformSize.height * 0.05,
                width: platformSize.width > 1200
                    ? platformSize.width * 0.15
                    : platformSize.width*0.20,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
