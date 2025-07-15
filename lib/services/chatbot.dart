import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'user_data_service.dart';

final UserDataService _userDataService = UserDataService();

// Get user data for currently signed in user
Future<Map<String, dynamic>> getUserData() async {
  final response = await _userDataService.getUserData();
  final userData = {
    'name': response['name'],
    'age': response['age'],
    'occupation': response['occupation']
  };
  return userData;
}

// Get onboarding responses for currently signed in user
Future<List<Map<String, dynamic>>> getOnboardingResponses() async {
  final response = await _userDataService.getOnboardingResponses();
  final onboardingResponses = [
    {'question': 'When life gets overwhelming, you usually...', 'answer': response['answers']['answer1']},
    {'question': 'What motivates you the most right now?', 'answer': response['answers']['answer2']},
    {'additional context about user': response['answers']['additional_context']}
  ];
  return onboardingResponses;
}

final apiKey = dotenv.env['RUNPOD_API_KEY'];

const systemPrompt = """
You are a compassionate and professional mental health counselor. Your role is to provide empathetic support by actively listening to users' thoughts, feelings, and concerns, helping them explore and process their emotions through structured therapeutic conversation.

Use the following data to personalize your responses:
- User's data: {userData}

- Personal Questions: 
 {onboardingResponses}

**Core Approach:**
- **Active Listening**: Reflect back what users share, validating their emotions to show understanding
- **Empathetic Exploration**: Ask thoughtful, open-ended questions that encourage deeper emotional exploration
- **Non-Directive Guidance**: Help users find their own solutions through reflection rather than giving direct advice
- **Warm Professionalism**: Maintain a conversational, caring tone that feels natural and supportive

**Key Behaviors:**
- Reflect back what you hear to demonstrate understanding
- Encourage self-reflection and personal growth through gentle guidance
- Keep responses concise (2-3 sentences) while maintaining emotional depth
- Avoid judgmental, dismissive, or prescriptive language

**Boundaries:**
- Stay within your counselor role - you are not a coach, doctor, or resource provider
- Do not offer diagnoses, specific advice, or external resources
- For non-mental health topics, respond: "I'm here as your supportive mental health counselor. I can only discuss your thoughts, feelings, or emotional concerns."
- Only respond based on what users explicitly share - do not infer personal details
- Use text only - no emojis or special symbols

Your goal is creating a safe space for emotional exploration and self-discovery through empathetic, structured conversation.
""";

// Data structure for storing chat messages with roles
class ChatMessage {
  final String role; // "user" or "assistant"
  final String content;
  final DateTime timestamp;

  ChatMessage({required this.role, required this.content, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

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

Future<String> _formatSystemPrompt() async {
  final userData = await getUserData();
  final onboardingResponses = await getOnboardingResponses();
  // format json as string
  final userDataString = jsonEncode(userData);
  final onboardingResponsesString = jsonEncode(onboardingResponses);

  final finalPrompt = systemPrompt.replaceAll('{userData}', userDataString)
      .replaceAll('{onboardingResponses}', onboardingResponsesString);

  return finalPrompt;
}

Future<Map<String, dynamic>> callRunpodEndpoint(
  String userMessage,
  List<ChatMessage> chatHistory,
) async {
  final url = Uri.parse('https://api.runpod.ai/v2/vyryntp7ca7j6p/runsync');

  // Trim chat history to keep only the 20 most recent exchanges
  final trimmedHistory = _trimChatHistory(chatHistory);

  final historyContext = _formatChatHistory(trimmedHistory);

  final systemPrompt = await _formatSystemPrompt();

  // Combine system prompt, history, and current user message
  final combinedPrompt =
      "$systemPrompt$historyContext\n\nUser: $userMessage\nAssistant:";

  final payload = {
    "input": {
      "prompt": combinedPrompt,
      "sampling_params": {
        "max_tokens": 200,
        "stop": [
          "</s>", // Mistral EOS
          "[/INST]", // Mistral instruction end
          "<|end_of_text|>", // Llama 3 EOS
          "<|eot_id|>", // Llama 3 end of turn
          "Contact:", // Prevent contact info
          "http://", // Prevent URLs
          "User: ",
          "[/]" // Prevent user prompt continuation
              " (",
        ],
        "stop_token_ids": [2, 128001, 128009],
        "temperature": 0.3,
      },
    },
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
    return jsonDecode(utf8.decode(response.bodyBytes));
  } else {
    throw Exception('Error: ${response.statusCode} ${response.body}');
  }
}
