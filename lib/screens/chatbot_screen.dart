import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  // Sample static messages for demonstration
  final List<_ChatMessage> _messages = [
    _ChatMessage(text: "I just... feel like I'm never enough", isUser: true),
    _ChatMessage(
      text:
          "That sounds really heavy to carry. Can you tell me what's making you feel this way today?",
      isUser: false,
    ),
    _ChatMessage(
      text:
          "I try so hard. But it's like... it's never good enough. For anyone",
      isUser: true,
    ),
    _ChatMessage(
      text:
          "I hear you. That feeling, that no matter what you do, it still falls short, can be incredibly painful. You're trying so hard, and that matters.",
      isUser: false,
    ),
    _ChatMessage(
      text: "I just want to feel like I'm doing okay. Like I'm not failing",
      isUser: true,
    ),
    _ChatMessage(text: "...", isUser: false, isTyping: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF3A3075),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Safe Space',
          style: TextStyle(
            color: Color(0xFF3A3075),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.chat_bubble_outline, color: Color(0xFF3A3075)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: index == 0 ? 0 : 12,
                      left: msg.isUser ? 60 : 0,
                      right: msg.isUser ? 0 : 60,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color:
                          msg.isUser
                              ? const Color(0xFF6A5AE0)
                              : const Color(0xFFF6F5FB),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
                        bottomRight: Radius.circular(msg.isUser ? 4 : 20),
                      ),
                    ),
                    child:
                        msg.isTyping
                            ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: Center(
                                    child: Text(
                                      '... ',
                                      style: TextStyle(
                                        color: Color(0xFF6A5AE0),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              msg.text,
                              style: TextStyle(
                                color:
                                    msg.isUser
                                        ? Colors.white
                                        : const Color(0xFF3A3075),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F5FA),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF6A5AE0),
                  radius: 26,
                  child: IconButton(
                    icon: const Icon(Icons.stop, color: Colors.white),
                    onPressed: () {}, // Placeholder for stop/send action
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isTyping;
  _ChatMessage({
    required this.text,
    required this.isUser,
    this.isTyping = false,
  });
}
