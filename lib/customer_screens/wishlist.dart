// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:cbs/main_screens/customer_home.dart';
import 'package:cbs/widgets/alert_dialog.dart';
import 'package:cbs/widgets/appbar_widgets.dart';
import 'package:cbs/widgets/yellow_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../providers/cart_provider.dart';
import '../providers/wish_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: const AppBarBackButton(),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Wishlist'),
            actions: [
              context.watch<Wish>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDilaog.showMyDialog(
                            context: context,
                            title: 'Clear Wishlist',
                            content: 'Are you sure to clear wishlist ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Wish>().clearWishList();
                              Navigator.pop(context);
                            });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ))
            ],
          ),
          body: context.watch<Wish>().getWishItems.isNotEmpty
              ? const WishItems()
              : const EmptyWishlist(),
        ),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Your Wishlist Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 120,
                          child: Image.network(
                              wish.getWishItems[index].imagesUrl),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  wish.getWishItems[index].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      wish.getWishItems[index].price
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              context.read<Wish>().removeItem(
                                                  wish.getWishItems[index]);
                                            },
                                            icon: const Icon(
                                                Icons.delete_forever)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        context
                                                        .watch<Cart>()
                                                        .getItems
                                                        .firstWhereOrNull((element) =>
                                                            element
                                                                .documentId ==
                                                            wish
                                                                .getWishItems[
                                                                    index]
                                                                .documentId) !=
                                                    null ||
                                                wish.getWishItems[index]
                                                        .qntty ==
                                                    0
                                            ? const SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  context.read<Wish>().addWishItem(
                                                      wish.getWishItems[index]
                                                          .name,
                                                      wish.getWishItems[index]
                                                          .price,
                                                      1,
                                                      wish.getWishItems[index]
                                                          .qntty,
                                                      wish.getWishItems[index]
                                                          .imagesUrl,
                                                      wish.getWishItems[index]
                                                          .documentId,
                                                      wish.getWishItems[index]
                                                          .suppId);
                                                },
                                                icon: const Icon(
                                                    Icons.add_shopping_cart)),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
