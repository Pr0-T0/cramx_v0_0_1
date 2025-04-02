// ignore_for_file: unnecessary_null_comparison

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cramx_v0_0_1/utils/candidate_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign In with Email and Password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Sign Up with Email and Password
  Future<AuthResponse> signUpwithEmailPassword(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user details (only email and uuid for now)
  Map<String, String>? getCurrentUserDetails() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return {
        "uuid": user.id,
        "email": user.email ?? "No email",
      };
    }
    return null;
  }

  // Fetch subjects
  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    final response = await _supabase.from('subjects').select('*');
    if (response == null || (response as List).isEmpty) {
      return [];
    }
    return List<Map<String, dynamic>>.from(response);
  }

  Future<String?> insertSubject(String userId, String deckName, String description) async {
  final response = await _supabase
      .from('subjects')
      .insert({
        'user_id': userId,
        'name': deckName,
        'description': description,
      })
      .select('id')
      .single();

  if (response != null && response['id'] is String) {
    return response['id'] as String;
  }
  return null;
}



  // Insert multiple flashcards linked to a subject
  Future<void> insertFlashcards(String userId, String subjectId, List<Map<String, String>> flashcards) async {
    final flashcardsData = flashcards.map((flashcard) {
      return {
        'user_id': userId,
        'subject_id': subjectId,
        'question': flashcard['question'] ?? '',
        'answer': flashcard['answer'] ?? '',
      };
    }).toList();

    await _supabase.from('flashcards').insert(flashcardsData);
  }

  // Fetch flashcards for a particular subject
  Future<List<ExampleCandidateModel>> fetchFlashcardsBySubject(String userId, String subjectId) async {
    final response = await _supabase
        .from('flashcards')
        .select('*')
        .eq('user_id', userId)
        .eq('subject_id', subjectId);

    if (response == null || (response as List).isEmpty) {
      return [];
    }
    return response.map<ExampleCandidateModel>((flashcard) => ExampleCandidateModel.fromMap(flashcard)).toList();
  }
}
