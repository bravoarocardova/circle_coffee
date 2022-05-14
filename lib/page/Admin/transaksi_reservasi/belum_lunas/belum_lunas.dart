import 'package:circle_coffee/helpers/currency_format.dart';
import 'package:circle_coffee/page/Admin/transaksi/detail_transaksi/detail_transaksi.dart';
import 'package:circle_coffee/page/Admin/transaksi_reservasi/detail_transaksi_reservasi/detail_transaksi_reservasi.dart';
import 'package:circle_coffee/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BelumLunas extends StatefulWidget {
  const BelumLunas({Key? key}) : super(key: key);

  @override
  State<BelumLunas> createState() => _BelumLunasState();
}

class _BelumLunasState extends State<BelumLunas> {
  bool isLoading = true;
  List<dynamic> data = <dynamic>[];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _fetchListPesanan();
    
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _searchList(_searchController.text);
      }else{
        _fetchListPesanan();
      }
    });
    

  }

  _fetchListPesanan() async {
    final order = await ApiService().getAllPesananProses();
    var pesananOrder = order['data'];

    if (mounted) {
      setState(() {
        data = pesananOrder;
        isLoading = false;
      });
    }
  }

  _searchList(String text) async {
    final getSearch = await ApiService().getAllPesananProses(nama:text);
    if (mounted) {
      setState(() {
        data = getSearch!['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: _searchController,
              style: const TextStyle(fontFamily: 'sans serif'),
              decoration: const InputDecoration(
                prefixIcon:
                    Icon(CupertinoIcons.search, color: Color(0x99FFC107)),
                hintText: 'Pencarian',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
              ),
            )
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: data.isEmpty
                ? const Center(
                    child: Text('Data Kosong'),
                  )
                : listPesanan()
            ),
          ),
        ],
      );
  }

  Widget listPesanan(){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailTransaksiReservasi(
                        idTransaksi: data[index]['id'],
                      ))),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${data[index]['nama']} (${data[index]['no_telp']})',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5))),
                ),  
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${data[index]['reservasi']} (${data[index]['tgl_reservasi']})',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey, width: 0.5))),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data[index]['status'] + ' (' + data[index]['petugas']['nama'] + ')',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                          data[index]['tgl_transaksi'],
                          style: const TextStyle(fontSize: 18),
                        ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey, width: 0.5))),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Total Pesanan',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                          CurrencyFormat.convertToIdr(
                              int.parse(data[index]['total']), 0),
                          style: const TextStyle(
                              fontFamily: 'Satisfy',
                              fontSize: 24,
                              color: Color(0x99FFC107))),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}