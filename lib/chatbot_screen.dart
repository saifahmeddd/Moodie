import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'services/chatbot.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add a welcome message
    _messages.add(_ChatMessage(
      text: "Hi! I'm here to listen and support you. Feel free to share what's on your mind.",
      isUser: false,
    ));
  }

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty || _isLoading) return;

    // Add user message to chat
    setState(() {
      _messages.add(_ChatMessage(text: userMessage, isUser: true));
      _controller.clear();
      _isLoading = true;
      // Add typing indicator
      _messages.add(_ChatMessage(text: "", isUser: false, isTyping: true));
    });
    _scrollToBottom();

    try {
      // Call the chatbot API
      final result = await callRunpodEndpoint(userMessage);
      
      // Remove typing indicator
      setState(() {
        _messages.removeLast();
      });

      if (result['status'] == 'COMPLETED' && result['output'] != null) {
        // Extract the AI response from the output
        final output = result['output'][0];
        final response = output['choices'][0]['tokens'][0];
        
        // Add AI response to chat
        setState(() {
          _messages.add(_ChatMessage(text: response.trim(), isUser: false));
        });
        _scrollToBottom();
      } else {
        // Handle unexpected response format
        setState(() {
          _messages.add(_ChatMessage(
            text: "I'm sorry, I'm having trouble responding right now. Please try again.",
            isUser: false,
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      // Remove typing indicator
      setState(() {
        _messages.removeLast();
      });
      
      // Handle error
      setState(() {
        _messages.add(_ChatMessage(
          text: "I'm sorry, there was an issue connecting. Please check your connection and try again.",
          isUser: false,
        ));
      });
      _scrollToBottom();
      print('Chatbot API error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Widget _buildTypingDot(int delay) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: Color(0xFF6868B9),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

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
          onPressed: () => Navigator.pop(context),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              'assets/icons/chatbubble.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF3A3075),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
                          ? const Color(0xFF6868B9)
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
                                  width: 40,
                                  height: 20,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildTypingDot(0),
                                        _buildTypingDot(200),
                                        _buildTypingDot(400),
                                      ],
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
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Share what's on your mind...",
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
                  backgroundColor: _isLoading ? Colors.grey : const Color(0xFF6868B9),
                  radius: 26,
                  child: IconButton(
                    icon: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _sendMessage,
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
