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
    final String url = '${AppUrl.getWords}?user_id=$id';
    return await ApiManager().getData(url);
  }

  deleteWord(id) async {
    final String url = '${AppUrl.words}/$id';
    return await ApiManager().deleteData(url, {});
  }

  updateWord(id) async {
    final String url = '${AppUrl.words}/$id';
    return await ApiManager().updateData(url, {});
  }

//Wordbank
  addWordsBank(data) async {
    return await ApiManager().postData(AppUrl.wordbanks, data);
  }

  getWordsBank(userId) async {
    final String url = '${AppUrl.getWordBank}?user_id=$userId';
    return await ApiManager().getData(url);
  }

  deleteWordsBank(id) async {
    final String url = '${AppUrl.wordbanks}/$id';
    print("deleteWordsBank url is------->$url");
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

  getWordsUnits(userId) async {
    final String url = '${AppUrl.wordbankUnits}?user_id=$userId';
    return await ApiManager().getData(url);
  }

  deleteWordsUnits(id) async {
    final String url = '${AppUrl.wordbankUnits}/$id';
    return await ApiManager().deleteData(url, {});
  }
}
