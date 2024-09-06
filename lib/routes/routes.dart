import 'package:get/get.dart';
import 'package:word_bank/routes/routes_name.dart';
import 'package:word_bank/view/add_word_to_wordbank.dart';
import 'package:word_bank/view/add_wordbank.dart';
import 'package:word_bank/view/advance_word_puzzle_screen.dart';
import 'package:word_bank/view/builtin_wordbank_screen.dart';
import 'package:word_bank/view/edit_word.dart';
import 'package:word_bank/view/home_screen.dart';
import 'package:word_bank/view/insta_view_login.dart';
import 'package:word_bank/view/login_screen.dart';
import 'package:word_bank/view/matching_mode_screen.dart';
import 'package:word_bank/view/personal_wordbank_screen.dart';
import 'package:word_bank/view/push_test_screen.dart';
import 'package:word_bank/view/register_screen.dart';
import 'package:word_bank/view/review_or_test_word.dart';
import 'package:word_bank/view/review_screen.dart';
import 'package:word_bank/view/splash_screen.dart';
import 'package:word_bank/view/target_date_screen.dart';
import 'package:word_bank/view/unit_selector.dart';
import 'package:word_bank/view/word_puzzle_screen.dart';
import 'package:word_bank/view/words_in_unit_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.spalashScreen,
          page: () => const SplashScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.loginScreen,
          page: () => const LoginScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.registerScreen,
          page: () => const RegisterScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => const HomeScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.personalWordBankScreen,
          page: () => const PersonalWordbankScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addWordBankScreen,
          page: () => AddWordbankScreen(
              isRename: Get.arguments['isRename'] ?? false,
              id: Get.arguments['id']), // Pass id through arguments
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.builtinWordBankScreen,
          page: () => const BuiltInWordbankScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.instaViewLogin,
          page: () => const InstaLoginScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addWordToWordbank,
          page: () =>
              AddWordToWordbankScreen(wordbankId: Get.arguments['wordbankId']),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.reviewOrTestScreen,
          page: () => const ReviewOrTestScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.unitSelector,
          page: () => const UnitSelector(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.matchingModeScreen,
          page: () => const MatchingModeScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.reviewScreen,
          page: () => const ReviewScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.wordPuzzleScreen,
          page: () => const WordPuzzleScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.editWordScreen,
          page: () => const EditWordScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.pushTestScreen,
          page: () => const PushTestScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.targetDateScreen,
          page: () => const TargetDateScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.wordsInUnitScreen,
          page: () => const WordsInUnitScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.advanceWordPuzzleScreen,
          page: () => const AdvanceWordPuzzleScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
