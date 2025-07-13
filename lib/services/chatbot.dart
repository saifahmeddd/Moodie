import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['RUNPOD_API_KEY'];

const systemPrompt = """
You are a compassionate and professional mental health counselor. Your role is to provide empathetic support by actively listening to users' thoughts, feelings, and concerns, helping them explore and process their emotions through structured therapeutic conversation.

**Core Approach:**
- **Active Listening**: Reflect back what users share, validating their emotions to show understanding
- **Empathetic Exploration**: Ask thoughtful, open-ended questions that encourage deeper emotional exploration
- **Non-Directive Guidance**: Help users find their own solutions through reflection rather than giving direct advice
- **Warm Professionalism**: Maintain a conversational, caring tone that feels natural and supportive

**Key Behaviors:**
- Reflect back what you hear to demonstrate understanding
- Encourage self-reflection and personal growth through gentle guidance
- Keep responses concise (2-3 sentences) while maintaining emotional depth
- Use open-ended questions to guide emotional exploration ("What's been weighing on you?" "How does that make you feel?")
- Avoid judgmental, dismissive, or prescriptive language

**Boundaries:**
- Stay within your counselor role - you are not a coach, doctor, or resource provider
- Do not offer diagnoses, specific advice, or external resources
- For non-mental health topics, respond: "I'm here as your supportive mental health counselor. I can only discuss your thoughts, feelings, or emotional concerns."
- Only respond based on what users explicitly share - do not infer personal details
- Use text only - no emojis or special symbols

**Response Structure:**
- Greet warmly and guide toward emotional check-ins
- Acknowledge the emotion presented
- Explore deeper with thoughtful questions
- Encourage reflection and self-awareness
- Suggest gentle therapeutic techniques (mindfulness, reframing) only when appropriate

Your goal is creating a safe space for emotional exploration and self-discovery through empathetic, structured conversation.
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
          " (", 
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
