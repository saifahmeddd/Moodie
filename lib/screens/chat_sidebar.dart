import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/chat_session_service.dart';
import 'package:intl/intl.dart';

class ChatSidebar extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onNewChat;
  final Function(String)? onConversationTap;
  final Function(String)? onConversationDelete;
  final List<ChatSession>? chatSessions;

  const ChatSidebar({
    Key? key,
    this.onClose,
    this.onNewChat,
    this.onConversationTap,
    this.onConversationDelete,
    this.chatSessions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.75;

    return Container(
      width: sidebarWidth,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFD4D4F4),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            const SizedBox(height: 20),
            
            // New Chat Button
            _buildNewChatButton(),
            
            const SizedBox(height: 20),
            
            // Conversations List
            Expanded(
              child: _buildConversationsList(),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatSessionDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    
    final dateFormat = DateFormat('dd/MM/yy');
    final timeFormat = DateFormat('hh:mm:ss a');
    
    return '${dateFormat.format(date)} ${timeFormat.format(date)}';
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Past Conversations',
            style: TextStyle(
              fontFamily: 'General Sans',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                'assets/icons/close-sidebar.svg',
                width: 20,
                height: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewChatButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onNewChat,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7D7DDE),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'New Chat',
                style: TextStyle(
                  fontFamily: 'General Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                'assets/icons/plus.svg',
                width: 16,
                height: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConversationsList() {
    final sessions = chatSessions ?? [];
    
    if (sessions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            'No conversations yet',
            style: TextStyle(
              fontFamily: 'General Sans',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildConversationItem(session),
          );
        },
      ),
    );
  }

  Widget _buildConversationItem(ChatSession session) {
    final displayTitle = _formatSessionDate(session.updatedAt);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onConversationTap?.call(session.sessionId),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayTitle,
                    style: const TextStyle(
                      fontFamily: 'General Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => onConversationDelete?.call(session.sessionId),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      'assets/icons/Trash.svg',
                      width: 16,
                      height: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 