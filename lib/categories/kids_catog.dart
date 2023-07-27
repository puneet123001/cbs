// ignore_for_file: unused_import

import 'package:cbs/utilities/categ_list.dart';
import 'package:cbs/widgets/categ_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cbs/minor_screens/subcatog_products.dart';

class KidsCategory extends StatelessWidget {
  const KidsCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CategHeaderLabel(
                  headerLabel: 'Kids',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: GridView.count(
                    mainAxisSpacing: 70,
                    crossAxisSpacing: 15,
                    crossAxisCount: 2,
                    children: List.generate(kids.length - 1, (index) {
                      return SubcatogWidget(
                        mainCatogName: 'kids',
                        subCatogName: kids[index + 1],
                        assenName: 'images/kids/kids$index.png',
                        subcategLabel: kids[index + 1],
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
        const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              maincategName: 'kids',
            ))
      ]),
    );
  }
}
