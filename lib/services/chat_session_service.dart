import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'chatbot.dart';

class ChatSessionService {
  static const String _collectionName = 'chat_sessions';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  // Create a new chat session
  Future<String> createChatSession() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final sessionId = _uuid.v4();
    final now = FieldValue.serverTimestamp();

    final sessionData = {
      'userId': user.uid,
      'sessionId': sessionId,
      'createdAt': now,
      'updatedAt': now,
      'messages': <Map<String, dynamic>>[],
    };

    await _firestore
        .collection(_collectionName)
        .doc(sessionId)
        .set(sessionData);

    return sessionId;
  }

  // Add a message to an existing chat session
  Future<void> addMessageToSession(String sessionId, ChatMessage message) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final messageData = {
      'role': message.role,
      'content': message.content,
      'timestamp': Timestamp.now(), // Use regular timestamp instead of serverTimestamp
      'messageId': _uuid.v4(),
    };

    await _firestore
        .collection(_collectionName)
        .doc(sessionId)
        .update({
      'messages': FieldValue.arrayUnion([messageData]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get chat session by ID
  Future<ChatSession?> getChatSession(String sessionId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final doc = await _firestore
        .collection(_collectionName)
        .doc(sessionId)
        .get();

    if (!doc.exists) return null;

    return ChatSession.fromFirestore(doc);
  }

  // Get all chat sessions for the current user
  Future<List<ChatSession>> getUserChatSessions() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final querySnapshot = await _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: user.uid)
        .get();

    final sessions = querySnapshot.docs
        .map((doc) => ChatSession.fromFirestore(doc))
        .toList();

    // Sort by updatedAt in memory (descending - newest first)
    sessions.sort((a, b) {
      final aTime = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    return sessions;
  }

  // Delete a chat session
  Future<void> deleteChatSession(String sessionId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection(_collectionName)
        .doc(sessionId)
        .delete();
  }

  // Update multiple messages at once (for efficiency)
  Future<void> updateChatSession(String sessionId, List<ChatMessage> messages) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final messageDataList = messages.map((message) => {
      'role': message.role,
      'content': message.content,
      'timestamp': Timestamp.now(), // Use regular timestamp instead of serverTimestamp
      'messageId': _uuid.v4(),
    }).toList();

    await _firestore
        .collection(_collectionName)
        .doc(sessionId)
        .update({
      'messages': messageDataList,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Stream chat sessions (for real-time updates)
  Stream<List<ChatSession>> streamUserChatSessions() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final sessions = snapshot.docs
              .map((doc) => ChatSession.fromFirestore(doc))
              .toList();
          
          // Sort by updatedAt in memory (descending - newest first)
          sessions.sort((a, b) {
            final aTime = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });
          
          return sessions;
        });
  }
}

// Model class for chat sessions
class ChatSession {
  final String userId;
  final String sessionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ChatSessionMessage> messages;

  ChatSession({
    required this.userId,
    required this.sessionId,
    this.createdAt,
    this.updatedAt,
    required this.messages,
  });

  factory ChatSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ChatSession(
      userId: data['userId'] ?? '',
      sessionId: data['sessionId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      messages: (data['messages'] as List<dynamic>? ?? [])
          .map((msg) => ChatSessionMessage.fromMap(msg as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'messages': messages.map((msg) => msg.toMap()).toList(),
    };
  }

  // Convert to ChatMessage list for AI context
  List<ChatMessage> toChatMessages() {
    return messages.map((msg) => ChatMessage(
      role: msg.role,
      content: msg.content,
    )).toList();
  }
}

// Model class for individual messages in a session
class ChatSessionMessage {
  final String role;
  final String content;
  final DateTime? timestamp;
  final String? messageId;

  ChatSessionMessage({
    required this.role,
    required this.content,
    this.timestamp,
    this.messageId,
  });

  factory ChatSessionMessage.fromMap(Map<String, dynamic> map) {
    return ChatSessionMessage(
      role: map['role'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
      messageId: map['messageId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
      'messageId': messageId,
    };
  }
} 