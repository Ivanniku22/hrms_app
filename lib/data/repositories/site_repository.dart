import '../../core/services/firebase_service.dart';
import '../models/site_model.dart';

class SiteRepository {
  final FirebaseService _firebaseService;

  SiteRepository({
    required FirebaseService firebaseService,
  }) : _firebaseService = firebaseService;

  Future<SiteModel> getSiteById(String siteId) async {
    final siteDoc = await _firebaseService.firestore
        .collection('sites')
        .doc(siteId)
        .get();

    if (!siteDoc.exists || siteDoc.data() == null) {
      throw Exception('Assigned site not found.');
    }

    return SiteModel.fromFirestore(
      siteDoc.id,
      siteDoc.data()!,
    );
  }
}