// ignore_for_file: unused_import, depend_on_referenced_packages, use_build_context_synchronously

import 'package:cbs/main_screens/customer_home.dart';
import 'package:cbs/providers/id_provider.dart';
import 'package:cbs/widgets/alert_dialog.dart';
import 'package:cbs/widgets/appbar_widgets.dart';
import 'package:cbs/widgets/yellow_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../minor_screens/place_order.dart';
import '../providers/cart_provider.dart';
import '../providers/wish_provider.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


   late String docId;


  @override
  void initState() {
  docId =context.read<IdProvider>().getData;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: widget.back,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Cart'),
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDilaog.showMyDialog(
                            context: context,
                            title: 'Clear Cart',
                            content: 'Are you sure to clear cart ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Cart>().clearCart();
                              Navigator.pop(context);
                            });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ))
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total: RS ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    onPressed: total == 0.0
                        ? null
                        :docId =='' ? (){
                      logInDialog(context);
                    } : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PlaceOrderScreen()));
                          },
                    child: const Text('CHECK OUT'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void logInDialog(context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('please log in'),
        content: const Text('you should be logged in to take an action'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/customer_login');
            },
            child: const Text('Log in'),
          )
        ],
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CustomerHomeScreen()));
              },
              child: const Text(
                'continue shopping',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

}


class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
            itemCount: cart.count,
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
                              cart.getItems[index].imagesUrl),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cart.getItems[index].name,
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
                                      cart.getItems[index].price
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 35,
                                      child: Row(
                                        children: [
                                          cart.getItems[index].qty == 1
                                              ? IconButton(
                                                  onPressed: () {
                                                    // cart.removeItem(
                                                    //     cart.getItems[index]);
                                                    showCupertinoModalPopup<
                                                        void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          CupertinoActionSheet(
                                                        title: const Text(
                                                            'RemoveItem'),
                                                        message: const Text(
                                                            'Are you sure to remove this item'),
                                                        actions: <
                                                            CupertinoActionSheetAction>[
                                                          // CupertinoActionSheetAction(
                                                          //
                                                          //   isDefaultAction: true,
                                                          //   onPressed: () {
                                                          //     Navigator.pop(context);
                                                          //   },
                                                          //   child: const Text('Default Action'),
                                                          // ),
                                                          CupertinoActionSheetAction(
                                                            onPressed:
                                                                () async {
                                                              context.read<Wish>().getWishItems.firstWhereOrNull((element) =>
                                                                          element
                                                                              .documentId ==
                                                                          cart
                                                                              .getItems[
                                                                                  index]
                                                                              .documentId) !=
                                                                      null
                                                                  ? context
                                                                      .read<
                                                                          Cart>()
                                                                      .removeItem(
                                                                          cart.getItems[
                                                                              index])
                                                                  : await context.read<Wish>().addWishItem(
                                                                      cart
                                                                          .getItems[
                                                                              index]
                                                                          .name,
                                                                      cart
                                                                          .getItems[
                                                                              index]
                                                                          .price,
                                                                      1,
                                                                      cart
                                                                          .getItems[
                                                                              index]
                                                                          .qntty,
                                                                      cart
                                                                          .getItems[
                                                                              index]
                                                                          .imagesUrl,
                                                                      cart
                                                                          .getItems[
                                                                              index]
                                                                          .documentId,
                                                                      cart
                                                                          .getItems[
                                                                              index]
                                                                          .suppId);
                                                              context
                                                                  .read<Cart>()
                                                                  .removeItem(
                                                                      cart.getItems[
                                                                          index]);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Move to Wishlist'),
                                                          ),
                                                          CupertinoActionSheetAction(
                                                            onPressed: () {
                                                              context
                                                                  .read<Cart>()
                                                                  .removeItem(
                                                                      cart.getItems[
                                                                          index]);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Delete Item'),
                                                          ),
                                                        ],
                                                        cancelButton:
                                                            TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    size: 18,
                                                  ))
                                              : IconButton(
                                                  onPressed: () {
                                                    cart.reducebyOne(
                                                        cart.getItems[index]);
                                                  },
                                                  icon: const Icon(
                                                    FontAwesomeIcons.minus,
                                                    size: 18,
                                                  )),
                                          Text(
                                            cart.getItems[index].qty.toString(),
                                            style: cart.getItems[index].qty ==
                                                    cart.getItems[index].qntty
                                                ? const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red)
                                                : const TextStyle(fontSize: 20),
                                          ),
                                          IconButton(
                                              onPressed: cart.getItems[index]
                                                          .qty ==
                                                      cart.getItems[index].qntty
                                                  ? null
                                                  : () {
                                                      cart.increment(
                                                          cart.getItems[index]);
                                                    },
                                              icon: const Icon(
                                                FontAwesomeIcons.plus,
                                                size: 18,
                                              ))
                                        ],
                                      ),
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
