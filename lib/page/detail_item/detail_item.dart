import 'dart:convert';

import 'package:circle_coffee/helpers/currency_format.dart';
import 'package:circle_coffee/library/my_shared_pref.dart';
import 'package:circle_coffee/models/keranjang_model.dart';
import 'package:circle_coffee/models/menu_model.dart';
import 'package:circle_coffee/models/user_model.dart';
import 'package:circle_coffee/page/cart_item/cart_item.dart';
import 'package:circle_coffee/page/home/home.dart';
import 'package:circle_coffee/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'detail_item_c.dart';

class DetailItem extends StatefulWidget {
  const DetailItem({
    Key? key,
    required this.idMenu,
  }) : super(key: key);

  final String? idMenu;

  @override
  _DetailItemState createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  late ApiService apiService;
  final controller = DetailItemC();
  final _qtyController = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();

    user = User();
    apiService = ApiService();
    _qtyController.text = "1";
    _login();
  }

  _login() async {
    final getUser = await MySharedPref().getModel();
    if (getUser != null) {
      setState(() {
        user = getUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: apiService.getDetailMenuByIdMenu(widget.idMenu.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              Menu menu = snapshot.data as Menu;
              return Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          icon: const Icon(
                            CupertinoIcons.chevron_left_circle,
                            color: Color(0xFFFFC107),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        expandedHeight: 350.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: const Text(''),
                          background: Image.network(
                            ApiService.imageMenuUrl + menu.photo,
                            fit: BoxFit.fill,
                          ),
                        ),
                        actions: [
                          IconButton(
                            color: Colors.black,
                            icon: const Icon(
                              CupertinoIcons.cart,
                              color: Color(0xFFFFC107),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CartItem()));
                            },
                          )
                        ],
                      )
                    ];
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menu.menu,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                      CurrencyFormat.convertToIdr(
                                          menu.harga, 0),
                                      style: const TextStyle(
                                          fontFamily: 'satisfy',
                                          fontSize: 24,
                                          color: Color(0x99FFC107))),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    menu.deskripsi,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xffDD6060)),
                          onPressed: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return Wrap(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(24),
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          int currentValue =
                                                              int.parse(
                                                                  _qtyController
                                                                      .text);
                                                          setState(() {
                                                            currentValue--;
                                                            _qtyController
                                                                .text = (currentValue >
                                                                        1
                                                                    ? currentValue
                                                                    : 1)
                                                                .toString(); // decrementing value
                                                          });
                                                        },
                                                        child: const Icon(
                                                            CupertinoIcons
                                                                .minus)),
                                                    Expanded(
                                                      child: TextFormField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        controller:
                                                            _qtyController,
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          int currentValue =
                                                              int.parse(
                                                                  _qtyController
                                                                      .text);
                                                          setState(() {
                                                            currentValue++;
                                                            _qtyController
                                                                .text = (currentValue <
                                                                        menu.stok
                                                                    ? currentValue
                                                                    : menu.stok)
                                                                .toString(); // incrementing value
                                                          });
                                                        },
                                                        child: const Icon(
                                                            CupertinoIcons
                                                                .plus))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              OutlinedButton.icon(
                                                icon: const Icon(
                                                    CupertinoIcons.cart),
                                                onPressed: () {
                                                  controller.addKeranjang(
                                                      idUser: user!.id_user,
                                                      idMenu: int.parse(widget
                                                          .idMenu
                                                          .toString()),
                                                      qty: int.parse(
                                                          _qtyController.text));
                                                },
                                                label: const Text(
                                                    'TAMBAHKAN KE KERANJANG'),
                                                style: OutlinedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            24)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                                });
                          },
                          child: const Icon(
                            CupertinoIcons.cart,
                            color: Colors.black,
                          )),
                      Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xff404040),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20))),
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      
                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                        return Wrap(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(24),
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 24),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              int currentValue =
                                                                  int.parse(
                                                                      _qtyController
                                                                          .text);
                                                              setState(() {
                                                                currentValue--;
                                                                _qtyController
                                                                    .text = (currentValue >
                                                                            1
                                                                        ? currentValue
                                                                        : 1)
                                                                    .toString(); // decrementing value
                                                              });
                                                            },
                                                            child: const Icon(
                                                                CupertinoIcons
                                                                    .minus)),
                                                        Expanded(
                                                          child: TextFormField(
                                                            textAlign:
                                                                TextAlign.center,
                                                            controller:
                                                                _qtyController,
                                                          ),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              int currentValue =
                                                                  int.parse(
                                                                      _qtyController
                                                                          .text);
                                                              setState(() {
                                                                currentValue++;
                                                                _qtyController
                                                                    .text = (currentValue <
                                                                            menu.stok
                                                                        ? currentValue
                                                                        : menu.stok)
                                                                    .toString(); // incrementing value
                                                              });
                                                            },
                                                            child: const Icon(
                                                                CupertinoIcons
                                                                    .plus))
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 40,
                                                  ),
                                                  OutlinedButton.icon(
                                                    icon: const Icon(
                                                        CupertinoIcons.cart),
                                                    onPressed: () {
                                                      modalPesan(context, menu: menu);
                                                    },
                                                    label: const Text(
                                                        'PESAN SEKARANG'),
                                                    style: OutlinedButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                24)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  });
                            },
                            child: const Text(
                              'PESAN SEKARANG',
                              style: TextStyle(color: Color(0xffFFC107)),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<dynamic> modalPesan(BuildContext context6,{ Menu? menu }) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              height: 300,
              width: 300,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu!.menu,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Image.asset('assets/images/bgsplash.png', height: 120,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                    CurrencyFormat.convertToIdr(
                                        menu.harga, 0),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0x99FFC107))),
                              ],
                            ),
                          ),
                          Text('X${_qtyController.text}',
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0x99FFC107))),
                          Text(
                              CurrencyFormat.convertToIdr(
                                  menu.harga *
                                      int.parse(_qtyController.text),
                                  0),
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0x99FFC107))),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(CupertinoIcons.clear),
                      onPressed: () => Navigator.pop(context),
                      label: const Text('BATAL'),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(24)),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(CupertinoIcons.cart),
                      onPressed: () {
                        modalConfirmPesanan(context, menu: menu);
                      },
                      label: const Text('PESAN'),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(24)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> modalConfirmPesanan(BuildContext context,{Menu? menu}) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Konfirmasi Pesanan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.clear),
                onPressed: () => Navigator.pop(context),
                label: const Text('BATAL'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.cart),
                onPressed: () async {
                  final order = await apiService.addOrder(
                      idUser: user?.id_user, total: int.parse(_qtyController.text) * menu!.harga);

                  if (order['success']) {
                      apiService.addDetailOrder(
                          lastId: order['last_id'],
                          idMenu: menu.id_menu,
                          harga: int.parse(_qtyController.text) * menu.harga,
                          qty: int.parse(_qtyController.text));
                    
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Home()));

                    Fluttertoast.showToast(msg: order['message']);
                  }
                },
                label: const Text('PESAN'),
                style:
                    OutlinedButton.styleFrom(padding: const EdgeInsets.all(24)),
              ),
            ],
          );
        });
  }
}
