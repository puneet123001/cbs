// ignore_for_file: unused_import, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:ui';

import 'package:cbs/minor_screens/subcatog_products.dart';
import 'package:cbs/widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';

class SubCatogProducts extends StatefulWidget {
  final String subcatogName;
  final String maincatogName;
  final bool fromOnBoarding;
  const SubCatogProducts(
      {Key? key,
      required this.subcatogName,
      required this.maincatogName,
      this.fromOnBoarding = false})
      : super(key: key);

  @override
  State<SubCatogProducts> createState() => _SubCatogProductsState();
}

class _SubCatogProductsState extends State<SubCatogProducts> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.maincatogName)
        .where('subcateg', isEqualTo: widget.subcatogName)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading:widget.fromOnBoarding==true? IconButton(onPressed: (){
          Navigator.pushReplacementNamed(context, '/customer_home');
        }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,)): const AppBarBackButton(),
        title: AppBarTitle(title: widget.subcatogName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'This category \n\n has no items yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            );
          }

          return SingleChildScrollView(
            child: StaggeredGridView.countBuilder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  return ProductModel(
                    products: snapshot.data!.docs[index],
                  );
                },
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
          );
          //   ListView(
          //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //     Map<String, dynamic> data =
          //         document.data()! as Map<String, dynamic>;
          //     return ListTile(
          //       leading: Image(
          //         image: NetworkImage(data['proimages'][0]),
          //       ),
          //       title: Text(data['proname']),
          //       subtitle: Text(data['price'].toString()),
          //     );
          //   }).toList(),
          // );
        },
      ),
    );
  }
}
