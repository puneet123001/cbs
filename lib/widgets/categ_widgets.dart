// ignore_for_file: prefer_const_constructors

import 'package:cbs/minor_screens/subcatog_products.dart';
import 'package:flutter/material.dart';

class SliderBar extends StatelessWidget {
  final String maincategName;

  const SliderBar({
    Key? key,
    required this.maincategName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                maincategName == 'beauty'
                    ? const Text('')
                    : const Text(
                        '<<',
                        style: TextStyle(
                            color: Colors.brown,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 10),
                      ),
                Text(
                  maincategName.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 10),
                ),
                maincategName == 'men'
                    ? const Text('')
                    : const Text(
                        '>>',
                        style: TextStyle(
                            color: Colors.brown,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 10),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubcatogWidget extends StatelessWidget {
  final String mainCatogName;
  final String subCatogName;
  final String assenName;
  final String subcategLabel;

  const SubcatogWidget({
    Key? key,
    required this.assenName,
    required this.mainCatogName,
    required this.subCatogName,
    required this.subcategLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            (context),
            MaterialPageRoute(
                builder: (context) => SubCatogProducts(
                      subcatogName: subCatogName,
                      maincatogName: mainCatogName,
                    )));
      },
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Image(
              image: AssetImage(assenName),
            ),
          ),
          Text(
            subcategLabel,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const CategHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Text(
        headerLabel,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
