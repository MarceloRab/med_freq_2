import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_freq_2/app/infrastructure/service/hasura_service/CustomHasuraService.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _Home2State();
}

class _Home2State extends State<HomeView> {
  /// TODO: Erro Fire - teste ready banco de dados

  FirebaseFirestore dbFirestore = FirebaseFirestore.instance;

  late MyHasuraService hasuraService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hasuraService = MyHasuraService();
    //hasuraService.initHasura();

    dbFirestore
        .collection('version_pre_paga')
        .doc('check_version')
        .get()
        .then((dynamic doc) {
      if (doc.data() != null) {
        developer.log(doc.data()['pay'], name: 'ERRO-VERSION-FREE-FIRE');
      } else {
        developer.log('NULO', name: 'ERRO-VERSION-FREE-FIRE');
      }
    });

   /* Future.delayed(const Duration(seconds: 3), () {
      hasuraService.getTextScans();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
