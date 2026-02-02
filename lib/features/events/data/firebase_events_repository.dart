import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/entities/event.dart';


// 1. REPOSITORY PROVIDER
final firebaseEventsRepositoryProvider = Provider<FirebaseEventsRepository>(
  (ref) => FirebaseEventsRepository());

// 2. EVENTS LIST STREAM PROVIDER
final eventsListProvider = StreamProvider<List<Event>>((ref) {
  final repository = ref.watch(firebaseEventsRepositoryProvider);
  return repository.getUpcomingEvents();
});

// 3. SINGLE EVENT DETAIL PROVIDER
final eventDetailsProvider = StreamProvider.family<Event?, String>((ref, id) {
  final repository = ref.watch(firebaseEventsRepositoryProvider);
  return repository.getEventById(id);
});

class FirebaseEventsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all upcoming events, ordered by date
  Stream<List<Event>> getUpcomingEvents() => _firestore
        .collection('events')
        // Filter out past events if you want, or just show active ones
        // .where('eventDate', isGreaterThan: DateTime.now()) 
        .orderBy('eventDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        
        // Handle Firestore Timestamp to DateTime conversion safely
        if (data['eventDate'] is Timestamp) {
          data['eventDate'] = (data['eventDate'] as Timestamp).toDate().
          toIso8601String();
        }
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate().
          toIso8601String();
        }
        if (data['updatedAt'] is Timestamp) {
          data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().
          toIso8601String();
        }

        return Event.fromJson(data);
      }).toList());

  // Fetch single event
  Stream<Event?> getEventById(String id) =>
   _firestore.collection('events').doc(id).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      final data = doc.data()!;
      data['id'] = doc.id;
      
      // Timestamp conversions
      if (data['eventDate'] is Timestamp) {
        data['eventDate'] = (
          data['eventDate'] as Timestamp).toDate().toIso8601String();
      }
      
      return Event.fromJson(data);
    });
}