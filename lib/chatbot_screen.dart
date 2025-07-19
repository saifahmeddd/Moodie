import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'services/chatbot.dart';
import 'services/chat_session_service.dart';
import 'screens/chat_sidebar.dart';
import 'package:intl/intl.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = []; // UI messages
  final List<ChatMessage> _chatHistory = []; // Chat history for AI context
  bool _isLoading = false;

  // Chat session management
  final ChatSessionService _chatSessionService = ChatSessionService();
  String? _currentSessionId;

  // Sidebar management
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;
  late Animation<double> _overlayAnimation;
  bool _isSidebarOpen = false;
  List<ChatSession> _chatSessions = [];

  // Manage chat history size - keep only the 20 most recent exchanges
  void _trimChatHistory() {
    const int maxHistoryLength = 20;

    if (_chatHistory.length > maxHistoryLength) {
      // Remove the oldest messages to keep only the 20 most recent
      _chatHistory.removeRange(0, _chatHistory.length - maxHistoryLength);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeChatSession();
    _initializeSidebar();
    _loadChatSessions();
  }

  void _initializeSidebar() {
    _sidebarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sidebarAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut),
    );

    _overlayAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadChatSessions() async {
    try {
      final sessions = await _chatSessionService.getUserChatSessions();
      setState(() {
        _chatSessions = sessions;
      });
    } catch (e) {
      // Handle error silently or show user-friendly error
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });

    if (_isSidebarOpen) {
      _sidebarController.forward();
      // Refresh chat sessions when sidebar opens
      _loadChatSessions();
    } else {
      _sidebarController.reverse();
    }
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
    _sidebarController.reverse();
  }

  String _formatSessionDate(DateTime? date) {
    if (date == null) return 'Unknown date';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  Future<void> _deleteConversation(String sessionId) async {
    try {
      // Show confirmation dialog
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Delete Conversation',
              style: TextStyle(
                fontFamily: 'General Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: const Text(
              'Are you sure you want to delete this conversation? This action cannot be undone.',
              style: TextStyle(fontFamily: 'General Sans'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (shouldDelete == true) {
        // Delete from Firebase
        await _chatSessionService.deleteChatSession(sessionId);

        // If we're deleting the current session, reset the current session ID
        if (_currentSessionId == sessionId) {
          _currentSessionId = null;
        }

        // Refresh the sidebar to show updated list
        await _loadChatSessions();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Conversation deleted successfully',
                style: TextStyle(fontFamily: 'General Sans'),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error deleting conversation: $e');
      print('Stack trace: ${e.toString()}');

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to delete conversation. Please try again.',
              style: TextStyle(fontFamily: 'General Sans'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _loadConversation(String sessionId) async {
    try {
      _closeSidebar(); // Close sidebar when a conversation is tapped

      setState(() {
        _isLoading = true;
        _messages.clear();
        _chatHistory.clear();
      });
      _scrollToBottom(); // Scroll to bottom to show loading indicator if needed

      final session = await _chatSessionService.getChatSession(sessionId);

      if (session != null) {
        _currentSessionId = session.sessionId;

        final loadedMessages =
            session.messages
                .map(
                  (msg) => _ChatMessage(
                    text: msg.content,
                    isUser: msg.role == 'user',
                  ),
                )
                .toList();

        final loadedHistory =
            session.messages
                .map(
                  (msg) => ChatMessage(
                    role: msg.role,
                    content: msg.content,
                    timestamp: msg.timestamp,
                  ),
                )
                .toList();

        setState(() {
          _messages.addAll(loadedMessages);
          _chatHistory.addAll(loadedHistory);
          _isLoading = false;
        });

        _scrollToBottom();
      } else {
        print('Could not find session with ID: $sessionId');
        setState(() {
          _isLoading = false;
          _messages.add(
            _ChatMessage(text: "Could not load conversation.", isUser: false),
          );
        });
      }
    } catch (e) {
      print('Error loading conversation: $e');
      setState(() {
        _isLoading = false;
        _messages.add(
          _ChatMessage(
            text: "An error occurred while loading the conversation.",
            isUser: false,
          ),
        );
      });
    }
  }

  void _startNewChat() {
    _closeSidebar();
    setState(() {
      _messages.clear();
      _chatHistory.clear();
      _currentSessionId = null;
      _isLoading = false;
      _controller.clear();
    });
    _initializeChatSession(); // Re-initialize with welcome message
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  Future<void> _initializeChatSession() async {
    final userData = await getUserData();
    String userName = userData['name'];
    try {
      // Add welcome message to UI
      _messages.add(
        _ChatMessage(
          text:
              "Hi $userName! I'm here to listen and support you. Feel free to share what's on your mind.",
          isUser: false,
        ),
      );

      // Add welcome message to chat history
      final welcomeMessage = ChatMessage(
        role: "assistant",
        content:
            "Hi $userName! I'm here to listen and support you. Feel free to share what's on your mind.",
      );
      _chatHistory.add(welcomeMessage);
      _trimChatHistory();

      // Note: Session will be created when first user message is sent

      setState(() {});
    } catch (e) {
      print('Error initializing chat: $e');
      print('Stack trace: ${e.toString()}');
    }
  }

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty || _isLoading) return;

    // Add user message to UI
    setState(() {
      _messages.add(_ChatMessage(text: userMessage, isUser: true));
      _controller.clear();
      _isLoading = true;
      // Add typing indicator to UI
      _messages.add(_ChatMessage(text: "", isUser: false, isTyping: true));
    });
    _scrollToBottom();

    // Add user message to chat history
    final userChatMessage = ChatMessage(role: "user", content: userMessage);
    _chatHistory.add(userChatMessage);
    _trimChatHistory();

    // Create session if this is the first user message (conversation length > 1)
    if (_currentSessionId == null && _chatHistory.length > 1) {
      try {
        _currentSessionId = await _chatSessionService.createChatSession();
      } catch (e) {
        // Handle error silently
      }
    }

    // Save user message to session if session exists and conversation has more than 1 message
    if (_currentSessionId != null && _chatHistory.length > 1) {
      try {
        await _chatSessionService.addMessageToSession(
          _currentSessionId!,
          userChatMessage,
        );
      } catch (e) {
        // Handle error silently
      }
    }

    try {
      // Call the chatbot API with chat history
      final result = await callRunpodEndpoint(userMessage, _chatHistory);

      // Remove typing indicator from UI
      setState(() {
        _messages.removeLast();
      });

      if (result['status'] == 'COMPLETED' && result['output'] != null) {
        // Extract the AI response from the output
        final output = result['output'][0];
        final response = output['choices'][0]['tokens'][0];
        // Clean up the response: remove '[/INST]' and trim whitespace
        final cleanResponse = response.replaceAll('[/INST]', '').trim();

        // Add AI response to UI
        setState(() {
          _messages.add(_ChatMessage(text: cleanResponse, isUser: false));
        });

        // Add AI response to chat history
        final assistantChatMessage = ChatMessage(
          role: "assistant",
          content: cleanResponse,
        );
        _chatHistory.add(assistantChatMessage);
        _trimChatHistory();

        // Save only successful assistant message to session if session exists and conversation has more than 1 message
        if (_currentSessionId != null && _chatHistory.length > 1) {
          try {
            print(
              'Attempting to save assistant message to session: $_currentSessionId',
            );
            print('Message content: $cleanResponse');
            await _chatSessionService.addMessageToSession(
              _currentSessionId!,
              assistantChatMessage,
            );
            print('Successfully saved assistant message to session');
          } catch (e) {
            print('Error saving assistant message to session: $e');
            print('Stack trace: ${e.toString()}');
          }
        } else if (_chatHistory.length <= 1) {
          print(
            'Skipping assistant message save - conversation has ${_chatHistory.length} messages (need > 1)',
          );
        } else {
          print('No current session ID available');
        }

        _scrollToBottom();
      } else {
        // Handle unexpected response format
        const errorMessage =
            "I'm sorry, I'm having trouble responding right now. Please try again.";
        setState(() {
          _messages.add(_ChatMessage(text: errorMessage, isUser: false));
        });

        // Add error message to chat history
        final errorChatMessage = ChatMessage(
          role: "assistant",
          content: errorMessage,
        );
        _chatHistory.add(errorChatMessage);
        _trimChatHistory();

        // Note: Not saving error message to session to avoid wasting space

        _scrollToBottom();
      }
    } catch (e) {
      // Remove typing indicator from UI
      setState(() {
        _messages.removeLast();
      });

      // Handle error
      const errorMessage =
          "I'm sorry, there was an issue connecting. Please check your connection and try again.";
      setState(() {
        _messages.add(_ChatMessage(text: errorMessage, isUser: false));
      });

      // Add error message to chat history
      final errorChatMessage = ChatMessage(
        role: "assistant",
        content: errorMessage,
      );
      _chatHistory.add(errorChatMessage);
      _trimChatHistory();

      // Note: Not saving error message to session to avoid wasting space

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Safe Space',
              style: TextStyle(
                color: Color(0xFF3A3075),
                fontFamily: 'quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            // Debug indicator showing chat history count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFF6868B9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_chatHistory.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _toggleSidebar,
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
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main chat content
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 12,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment:
                            msg.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _sendMessage(),
                          enabled: !_isSidebarOpen,
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
                        backgroundColor:
                            _isLoading ? Colors.grey : const Color(0xFF6868B9),
                        radius: 26,
                        child: IconButton(
                          icon: Icon(
                            _isLoading ? Icons.hourglass_empty : Icons.send,
                            color: Colors.white,
                          ),
                          onPressed:
                              (_isLoading || _isSidebarOpen)
                                  ? null
                                  : _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Overlay
          if (_isSidebarOpen)
            AnimatedBuilder(
              animation: _overlayAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(_overlayAnimation.value),
                    child: GestureDetector(
                      onTap: _closeSidebar,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                );
              },
            ),

          // Sidebar
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, child) {
              return Positioned(
                top: 0,
                right:
                    MediaQuery.of(context).size.width *
                    _sidebarAnimation.value *
                    -1,
                bottom: 0,
                child: ChatSidebar(
                  onClose: _closeSidebar,
                  onNewChat: _startNewChat,
                  onConversationTap: _loadConversation,
                  onConversationDelete: (String sessionId) {
                    _deleteConversation(sessionId);
                  },
                  chatSessions: _chatSessions,
                ),
              );
            },
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
