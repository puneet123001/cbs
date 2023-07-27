// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:cbs/minor_screens/visit_store.dart';
import 'package:cbs/providers/product_class.dart';
import 'package:cbs/widgets/appbar_widgets.dart';
import 'package:cbs/widgets/snackbar.dart';
import 'package:cbs/widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../main_screens/cart.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wish_provider.dart';
import 'full_screen_view.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;
import 'package:expandable/expandable.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];
  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.proList['maincateg'])
        .where('subcateg', isEqualTo: widget.proList['subcateg'])
        .snapshots();
    final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.proList['proid'])
        .collection('reviews')
        .snapshots();

    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                    imagesList: imagesList,
                                  )));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Swiper(
                              pagination: const SwiperPagination(
                                  builder: SwiperPagination.fraction),
                              itemBuilder: (context, index) {
                                return Image(
                                  image: NetworkImage(
                                    imagesList[index],
                                  ),
                                );
                              },
                              itemCount: imagesList.length),
                        ),
                        Positioned(
                            left: 5,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                        Positioned(
                            right: 5,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ))
                      ],
                    ),
                  ),
                  Text(
                    widget.proList['proname'],
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('Rs ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(
                            widget.proList['price'].toStringAsFixed(2),
                            style: onSale != 0
                                ? const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600)
                                : const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          onSale != 0
                              ? Text(
                                  ((1 - (onSale / 100)) *
                                          widget.proList['price'])
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              : const Text(''),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            context.read<Wish>().getWishItems.firstWhereOrNull(
                                        (product) =>
                                            product.documentId ==
                                            widget.proList['proid']) !=
                                    null
                                ? context
                                    .read<Wish>()
                                    .removeThis(widget.proList['proid'])
                                : context.read<Wish>().addWishItem(
                                    widget.proList['proname'],
                                    onSale != 0
                                        ? ((1 - (onSale / 100)) *
                                            widget.proList['price'])
                                        : widget.proList['price'],
                                    1,
                                    widget.proList['instock'],
                                    widget.proList['proimages'],
                                    widget.proList['proid'],
                                    widget.proList['sid']);
                          },
                          icon: context
                                      .watch<Wish>()
                                      .getWishItems
                                      .firstWhereOrNull((product) =>
                                          product.documentId ==
                                          widget.proList['proid']) !=
                                  null
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.red,
                                  size: 30,
                                )),
                    ],
                  ),
                  widget.proList['instock'] == 0
                      ? const Text('This item is out of stock',
                          style:
                              TextStyle(fontSize: 16, color: Colors.blueGrey))
                      : Text(
                          (widget.proList.get('instock').toString()) +
                              (' pieces available in stock'),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                        ),
                  const ProDetailsHeader(
                    label: '   Item Description   ',
                  ),
                  Text(
                    widget.proList.get('prodesc'),
                    textScaleFactor: 1.1,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade600),
                  ),
                  Stack(children: [
                    const Positioned(right: 50, top: 15, child: Text('')),
                    ExpandableTheme(
                        data: const ExpandableThemeData(
                          iconSize: 24,
                          iconColor: Colors.blue,
                        ),
                        child: reviews(reviewsStream)),
                  ]),
                  const ProDetailsHeader(
                    label: '  Similar Items  ',
                  ),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                              staggeredTileBuilder: (context) =>
                                  const StaggeredTile.fit(1)),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisitStore(
                                        suppId: widget.proList['sid'])));
                          },
                          icon: const Icon(Icons.store)),
                      const SizedBox(
                        height: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen(
                                          back: AppBarBackButton(),
                                        )));
                          },
                          icon: badges.Badge(
                              showBadge: context.read<Cart>().getItems.isEmpty
                                  ? false
                                  : true,
                              badgeStyle: const badges.BadgeStyle(
                                  badgeColor: Colors.yellow,
                                  padding: EdgeInsets.all(2)),
                              badgeContent: Text(
                                context
                                    .watch<Cart>()
                                    .getItems
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              child: const Icon(Icons.shopping_cart))),
                    ],
                  ),
                  YellowButton(
                      label: context.read<Cart>().getItems.firstWhereOrNull(
                                  (product) =>
                                      product.documentId ==
                                      widget.proList['proid']) !=
                              null
                          ? 'Added to cart '
                          : 'ADD TO CART',
                      onPressed: () {
                        if (widget.proList['instock'] == 0) {
                          MyMessageHandler.showSnackBar(
                              _scaffoldKey, 'This item is out of stock');
                        } else if (context
                                .read<Cart>()
                                .getItems
                                .firstWhereOrNull((product) =>
                                    product.documentId ==
                                    widget.proList['proid']) !=
                            null) {
                          MyMessageHandler.showSnackBar(
                              _scaffoldKey, 'This item already in cart');
                        } else {
                          context.read<Cart>().addItem(Product(
                              documentId: widget.proList['proid'],
                              name: widget.proList['proname'],
                              price: onSale != 0
                                  ? ((1 - (onSale / 100)) *
                                      widget.proList['price'])
                                  : widget.proList['price'],
                              qty: 1,
                              qntty: widget.proList['instock'],
                              imagesUrl: imagesList.first,
                              suppId: widget.proList['sid']));
                        }
                      },
                      width: 0.55),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(label,
              style: TextStyle(
                  color: Colors.yellow.shade900,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
      header: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Reviews',
            style: TextStyle(
                color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
          )),
      collapsed: SizedBox(
        height: 230,
        child: reviewsAll(reviewsStream),
      ),
      expanded: reviewsAll(reviewsStream));
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
          child: Text(
            'This Item \n\n has no Reviews yet',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
        );
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (
            context,
            index,
          ) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot2.data!.docs[index]['profileimage']),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot2.data!.docs[index]['name']),
                  Row(
                    children: [
                      Text(snapshot2.data!.docs[index]['rate'].toString()),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  )
                ],
              ),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
            );
          });
    },
  );
}
//
