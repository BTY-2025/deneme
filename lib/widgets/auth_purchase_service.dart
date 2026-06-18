import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:pdfaireader/firebase_options.dart';
import 'package:pdfaireader/widgets/db_service.dart';

class AuthPurchaseService {
  static final ValueNotifier<bool> isPremiumNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> userIdNotifier = ValueNotifier<String?>(null);

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      String uid = userCredential.user!.uid;
      userIdNotifier.value = uid;

      await Purchases.setLogLevel(LogLevel.debug);
      if (defaultTargetPlatform == TargetPlatform.android) {
        await Purchases.configure(PurchasesConfiguration("goog_QnWMvpyzRcveLDBHmPxrnENCOSS")..appUserID = uid);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        await Purchases.configure(PurchasesConfiguration("appl_yUJAYwnBrhevamRertqLuVvrPzD")..appUserID = uid);
      }

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _updatePremiumStatus(customerInfo);

      Purchases.addCustomerInfoUpdateListener((info) {
        _updatePremiumStatus(info);
      });

    } catch (e) {
      debugPrint("Initialization error: $e");
    }
  }

  static void _updatePremiumStatus(CustomerInfo info) {
    final isPremium = info.entitlements.all['Pdfology Pro']?.isActive ?? false;
    isPremiumNotifier.value = isPremium;

    final uid = userIdNotifier.value;
    if (uid != null) {
      DbService.updateUserPremiumStatus(uid, isPremium);
    }
  }

  static Future<void> buyPremium() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      Offering? activeOffering = offerings.current ?? offerings.all['default'];
      if (activeOffering != null && activeOffering.monthly != null) {
        CustomerInfo customerInfo = await Purchases.purchasePackage(activeOffering.monthly!);
        _updatePremiumStatus(customerInfo);
      } else {
        debugPrint("No active offering or monthly package found.");
      }
    } catch (e) {
      debugPrint("Purchase failed: $e");
    }
  }
}
