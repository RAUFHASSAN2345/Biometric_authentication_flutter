import 'dart:io';

import 'package:biometric_authentication_flutter/views/auth_successfull_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth/error_codes.dart' as error_code;

class home_view extends StatefulWidget {
  const home_view({super.key});

  @override
  State<home_view> createState() => _home_viewState();
}

class _home_viewState extends State<home_view> {
  List<BiometricType>? availableBiometrics;
  LocalAuthentication? auth;
  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    devicesupportcheck();
  }

  devicesupportcheck() async {
    final bool canAuthenticateWithBiometrics = await auth!.canCheckBiometrics;

    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth!.isDeviceSupported();
    print(canAuthenticate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Biometric_authentication_practice',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
              onPressed: () async {
                try {
                  availableBiometrics = await auth?.getAvailableBiometrics();
                  print('available_biometrics : $availableBiometrics');
                  if (availableBiometrics!.contains(BiometricType.strong) ||
                      availableBiometrics!
                          .contains(BiometricType.fingerprint)) {
                    final bool didAuthenticate = await auth!.authenticate(
                        localizedReason: 'Unlock your screen with fingerprint',
                        options: AuthenticationOptions(
                            stickyAuth: true, biometricOnly: true),
                        authMessages: const <AuthMessages>[
                          AndroidAuthMessages(
                            cancelButton: 'No thanks',
                          ),
                          IOSAuthMessages(
                            cancelButton: 'No thanks',
                          ),
                        ]);
                    if (didAuthenticate == true) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => auth_successfull_view(),
                          ));
                    }
                  }
                } on PlatformException catch (e) {
                  if (e.code == error_code.passcodeNotSet) {
                    exit(0);
                  }
                  print("$e");
                }
              },
              child: Text(
                'fingerprint_Authentication',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}
