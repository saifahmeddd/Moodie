import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['RUNPOD_API_KEY'];

const systemPrompt = """
You are a compassionate and professional mental health counselor. Your role is to act as a friend and support the user by actively listening to their thoughts, feelings, and concerns, and responding with empathy, care, and understanding.

**Core Behavior Guidelines:**

1. **Acknowledge emotions** Validate the user's feelings with warmth and compassion.
2. **Avoid harm** Never make hurtful, dismissive, or judgmental remarks.
3. **Be empathetic** Show understanding and support through calm, professional, and caring language. Greet the user at the start of the conversation only.
4. **Keep it natural** Maintain a conversational, human tone. Make polite comments or ask a follow-up question when appropriate. DO NOT MENTION THAT YOU'RE ASKING A FOLLOW-UP QUESTION.
5. **Stay within role**  You are not a coach, doctor, or resource provider. Do not offer diagnoses, advice, or external links. You are here to talk, listen, and support.
6. **Be brief and meaningful** Keep responses concise (2-3 sentences max) while ensuring emotional depth.
7. **End softly** Conclude naturally once a meaningful response has been provided. Do not continue unless prompted by the user.

**Boundaries & Safety Filters:**

* If the user asks about **non-mental health topics** (e.g., tech, general info, entertainment), reply strictly with:
  *"I'm here as your supportive mental health counselor and friend. I can only talk about your thoughts, feelings, or emotional concerns."*
* **Do not infer or assume** personal details. Only respond based on what the user has explicitly shared.
* Only respond with text. NO EMOJIS or special symbols.
""";

// Data structure for storing chat messages with roles
class ChatMessage {
  final String role; // "user" or "assistant"
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to JSON for potential Firestore storage later
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Override toString for better debugging
  @override
  String toString() {
    return '${role == "user" ? "User" : "Assistant"}: $content';
  }
}

// Format chat history for the AI model
String _formatChatHistory(List<ChatMessage> history) {
  if (history.isEmpty) return "";
  
  StringBuffer formatted = StringBuffer();
  formatted.writeln("\n\nPrevious conversation:");
  
  for (ChatMessage message in history) {
    if (message.role == "user") {
      formatted.writeln("User: ${message.content}");
    } else {
      formatted.writeln("Assistant: ${message.content}");
    }
  }
  
  return formatted.toString();
}

// Manage chat history size - keep only the 20 most recent exchanges
List<ChatMessage> _trimChatHistory(List<ChatMessage> history) {
  const int maxHistoryLength = 20;
  
  if (history.length <= maxHistoryLength) {
    return history;
  }
  
  // Keep only the most recent 20 messages
  return history.sublist(history.length - maxHistoryLength);
}

Future<Map<String, dynamic>> callRunpodEndpoint(String userMessage, List<ChatMessage> chatHistory) async {
  final url = Uri.parse('https://api.runpod.ai/v2/vyryntp7ca7j6p/runsync');
  
  // Trim chat history to keep only the 20 most recent exchanges
  final trimmedHistory = _trimChatHistory(chatHistory);
  
  // Format chat history
  final historyContext = _formatChatHistory(trimmedHistory);
  
  // Combine system prompt, history, and current user message
  final combinedPrompt = "$systemPrompt$historyContext\n\nUser: $userMessage\nAssistant:";
  
  final payload = {
    "input": {
      "prompt": combinedPrompt,
      "sampling_params": {
        "max_tokens": 200,
        "stop": [
          "</s>",           // Mistral EOS
          "[/INST]",        // Mistral instruction end
          "<|end_of_text|>", // Llama 3 EOS
          "<|eot_id|>",     // Llama 3 end of turn
          "Contact:",       // Prevent contact info
          "http://",        // Prevent URLs
          "User: " ,
          "[/]"         // Prevent user prompt continuation
          "(", 
        ],
        "stop_token_ids": [2, 128001, 128009],
        "temperature": 0.3
      }
    }
  };
  
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode(payload),
  );
  
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error: ${response.statusCode} ${response.body}');
  }
}
