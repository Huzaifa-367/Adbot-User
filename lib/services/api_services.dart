import 'dart:convert';

import 'package:adbot/widgets/api/toast_message.dart';
import 'package:http/http.dart' as http;

import '../helper/local_storage.dart';

class ApiServices {
  static var client = http.Client();

  static Future<String> generateResponse1(String prompt, String model) async {
    var url = Uri.https("api.openai.com","/v1/completions");

    Map<String, dynamic> newresponse;


    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${LocalStorage.getChatGptApiKey()}"
        },
        body: json.encode({
          "model": model,
          "prompt": prompt,
          "temperature": 0,
          "max_tokens": LocalStorage.getSelectedToken(),
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
        }),
      );

      // Do something with the response
       newresponse = jsonDecode(utf8.decode(response.bodyBytes));

      return newresponse['choices'][0]['text'];

    }catch(e){
      ToastMessage.error('Maybe model is not Ready. Please try another one.');
      return 'Model is not Supported please try another';
    }
  }


  static Future<String> generateResponse2(String prompt) async {

    var url = Uri.https("api.openai.com", "/v1/chat/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${LocalStorage.getChatGptApiKey()}"
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content": prompt
          }
        ]
      }),
    );

    // Do something with the response
    Map<String, dynamic> newresponse = jsonDecode(utf8.decode(response.bodyBytes));

    return newresponse['choices'][0]['message']['content'];
  }

  // static Future<AiTypeModel> getModels() async {
  //   var url = Uri.https("api.openai.com","/v1/models");
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       "Authorization": "Bearer ${LocalStorage.getChatGptApiKey()}"
  //     }
  //   );
  //
  //   // Do something with the response
  //   AiTypeModel newresponse = AiTypeModel.fromJson(jsonDecode(response.body));
  //
  //
  //   return newresponse;
  // }
}
