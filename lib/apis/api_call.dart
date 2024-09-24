import 'package:word_bank/apis/api_manager.dart';
import 'package:word_bank/apis/response/app_url.dart';

class ApiCall {
  //Auth
  login(data) async {
    return await ApiManager().postData(AppUrl.login, data);
  }

  register(data) async {
    return await ApiManager().postData(AppUrl.register, data);
  }

  forgotPassword(data) async {
    return await ApiManager().postData(AppUrl.forgotPassword, data);
  }

  resetPassword(data) async {
    return await ApiManager().postData(AppUrl.resetPassword, data);
  }

//word
  addWordToWordksbank(id, data) async {
    final String url = '${AppUrl.words}?user_id=$id';
    return await ApiManager().postData(url, data);
  }

  getWords(id) async {
    final String url = '${AppUrl.getWords}?id=$id';
    return await ApiManager().getData(url);
  }

  deleteWord(id) async {
    final String url = '${AppUrl.words}/$id';
    return await ApiManager().deleteData(url, {});
  }

  updateWord(id, data) async {
    final String url = '${AppUrl.words}/$id';
    print("update word------>$url");
    return await ApiManager().updateData(url, data);
  }

//Wordbank
  addWordsBank(data) async {
    return await ApiManager().postData(AppUrl.wordbanks, data);
  }

  getWordsBank(userId) async {
    final String url = '${AppUrl.getWordBank}?user_id=$userId';
    return await ApiManager().getData(url);
  }

  getBuiltInWordsBank() async {
    return await ApiManager().getData(AppUrl.getWordBank);
  }

  deleteWordsBank(id) async {
    final String url = '${AppUrl.wordbanks}/$id';
    return await ApiManager().deleteData(url, {});
  }

  updateWordBank(id, body) async {
    final String url = '${AppUrl.wordbanks}/$id';
    return await ApiManager().updateData(url, body);
  }

  //wordbank-units
  addWordsUnits(data) async {
    return await ApiManager().postData(AppUrl.wordbankUnits, data);
  }

  getWordsUnits(id) async {
    final String url = '${AppUrl.getUnits}?id=$id';
    return await ApiManager().getData(url);
  }

  deleteWordsUnits(id) async {
    final String url = '${AppUrl.wordbankUnits}/$id';
    return await ApiManager().deleteData(url, {});
  }

  updateWordBankUnits(id, body) async {
    final String url = '${AppUrl.wordbankUnits}/$id';
    return await ApiManager().updateData(url, body);
  }

  getExamType(unit_id) async {
    final String url = '${AppUrl.getExamType}?unit_id=$unit_id';
    return await ApiManager().getData(url);
  }

  getExam(unit_id, exam_id) async {
    final String url = '${AppUrl.exam}?unit_id=$unit_id&exam_id=$exam_id';
    print("get exam url---->$url");
    return await ApiManager().getData(url);
  }

  getReview(unit_id) async {
    final String url = '${AppUrl.review}?id=$unit_id';
    print("get review url---->$url");
    return await ApiManager().getData(url);
  }

  aiDataHandler(word) async {
    final String url = '${AppUrl.generatesentence}?word=$word';
    print("get ai data url---->$url");
    return await ApiManager().postData(url, {});
  }

  gameResult(body) async {
    return await ApiManager().postData(AppUrl.gameResult, body);
  }

  getUnitWords(id) async {
    final String url = '${AppUrl.getUnitWords}?unit_id=$id';
    print("getUnitWordsy---->$url");

    return await ApiManager().getData(url);
  }
}
