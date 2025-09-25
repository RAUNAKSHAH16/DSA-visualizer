
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _apiKey = 'f9e34b8bf7a0ae2643189736f96207506ec854b18d295e93c25196f39dae7173'; // Replace with your real key

  static Future<String> getChatResponse(String userMessage) async {
    final url = Uri.parse(
        "https://api.together.xyz/v1/chat/completions"); // ✅ Change 1: OpenRouter endpoint

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + _apiKey,

    };
    final body = jsonEncode({
      "model": "deepseek-ai/DeepSeek-R1-Distill-Llama-70B-free"
    , // ✅ Change 3: OpenRouter model
      "messages": [
        {
          "role": "system",
          "content": "You are a helpful assistant that explains DSA algorithms clearly.",
        },
        {
          "role": "user",
          "content": userMessage,
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else if (response.statusCode == 429) {
        return '⚠️ Too many requests. Please wait a moment and try again.';
      } else {
        return '❌ Failed to get response. Status: ${response.statusCode}';
      }
    } catch (e) {
      return '❌ Network or parsing error: $e';
    }
  }
}
