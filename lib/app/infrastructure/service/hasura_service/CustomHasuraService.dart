import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:med_freq_2/app/data/text_model.dart';

import 'firebase_service/auth/auth_sign.dart';

String url = 'https://electric-man-43.hasura.app/v1/graphql';

//document
String docQuery = """
  query {
    texts_scan(order_by: {created_at: desc}) {
    created_at
    id_linha
    id_user_fire
    text_scan_users
  }
}
""";

class MyHasuraService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late HasuraConnect hasuraConnect;
  final WebFirebaseAuthService webauth = WebFirebaseAuthService();

  Future<void> initHasura() async {
    UserData? user = await webauth.signInAnonymously();

    if (user != null) {
      hasuraConnect =
          HasuraConnect(url, interceptors: [TokenInterceptor(auth)]);
    } else {
      developer.log('ERRO-LOGIN', name: 'FIRE-ANOMIMO');
      throw Error();
    }
  }

  Future<bool> getTextScans() async {
    var r = await hasuraConnect.query(docQuery);

    developer.log('HASURA', name: r.toString());

    final listBooks = (r['data']['texts_scan'] as List)
        .map((e) => TextCopy(
            text: e['text_scan_users'] as String,
            //time: (e['created_at'] as Timestamp).toDate()))
            time: (DateTime.parse(e['created_at'] as String)),
            id_linha: e['id_linha'] as String))
        .toList();

    developer.log('LIST-TIME', name: listBooks.toString());

    developer.log('LIST-tamanho', name: listBooks.length.toString());

    return false;
  }
}

class TokenInterceptor extends Interceptor {
  final FirebaseAuth auth;

  TokenInterceptor(this.auth);

  @override
  Future<void>? onConnected(HasuraConnect connect) {
    return null;
  }

  @override
  Future<void>? onDisconnected() {
    return null;
  }

  @override
  Future? onError(HasuraError request, HasuraConnect connect) {
    return Future.value(request);
  }

  @override
  Future? onRequest(Request request, HasuraConnect connect) async {
    User? user = await auth.currentUser;
    if (user != null) {
      final token = await user.getIdToken(true);
      if (token != null) {
        try {
          //request.headers['Authorization'] = 'Bearer ${token}';
          request.headers['x-hasura-admin-secret'] =
              'WxliCsqPbPWLJmUKsyXI5ONqpWqkf0egcVCkxkotkt1gcQaJ77viwZd4m0EKCxR3';
          return request;
        } catch (e) {
          developer.log('ERRAO', name: 'AUTH-FIRE');
          return null;
        }
      }
    }
  }

  @override
  Future? onResponse(Response data, HasuraConnect connect) {
    return Future.value(data);
  }

  @override
  Future<void>? onSubscription(Request request, Snapshot snapshot) {}

  @override
  Future<void>? onTryAgain(HasuraConnect connect) {}
}
