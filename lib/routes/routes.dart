import 'package:get/get.dart';
import 'package:word_bank/components/about.dart';
import 'package:word_bank/components/achievement.dart';
import 'package:word_bank/components/member.dart';
import 'package:word_bank/components/settings.dart';
import 'package:word_bank/routes/routes_name.dart';
import 'package:word_bank/view/add_word_to_wordbank.dart';
import 'package:word_bank/view/add_wordbank.dart';
import 'package:word_bank/view/advance_word_puzzle_screen.dart';
import 'package:word_bank/view/builtin_wordbank_screen.dart';
import 'package:word_bank/view/change_password.dart';
import 'package:word_bank/view/edit_user.dart';
import 'package:word_bank/view/edit_word.dart';
import 'package:word_bank/view/exam_board_screen.dart';
import 'package:word_bank/view/forgot_password.dart';
import 'package:word_bank/view/home_screen.dart';
import 'package:word_bank/view/insta_view_login.dart';
import 'package:word_bank/view/login_screen.dart';
import 'package:word_bank/view/matching_mode_screen.dart';
import 'package:word_bank/view/notification_list.dart';
import 'package:word_bank/view/personal_wordbank_screen.dart';
import 'package:word_bank/view/push_test_screen.dart';
import 'package:word_bank/view/register_screen.dart';
import 'package:word_bank/view/reset_password.dart';
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
            isRename: Get.arguments != null && Get.arguments['isRename'] != null
                ? Get.arguments['isRename']
                : false,
            id: Get.arguments != null ? Get.arguments['id'] : null,
          ),
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
          page: () => WordsInUnitScreen(
              wordbankId: int.parse(Get.parameters['wordbankId']!)),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.advanceWordPuzzleScreen,
          page: () => const AdvanceWordPuzzleScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.noticationScreen,
          page: () => NotificationListScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.editUser,
          page: () => const EditUser(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.forgotPassword,
          page: () => const ForgotPassword(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.resetPassword,
          page: () => const ResetPassword(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.changePassword,
          page: () => const ChangePassword(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.settings,
          page: () => Settings(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.member,
          page: () => Member(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.achievement,
          page: () => Achievement(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.about,
          page: () => About(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.examBoardScreen,
          page: () => ExamBoardScreen(),
          transitionDuration: const Duration(microseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
