import 'package:cramx_v0_0_1/auth/auth_service.dart';
import 'package:cramx_v0_0_1/pages/home_page.dart';
import 'package:cramx_v0_0_1/utils/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import "package:cramx_v0_0_1/utils/candidate_model.dart";
import 'package:supabase_flutter/supabase_flutter.dart'; // Import ExampleCard

class CardView extends StatefulWidget {
  final String subjectId;
  const CardView({super.key, required this.subjectId});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  final CardSwiperController controller = CardSwiperController();
  List<ExampleCandidateModel> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    setState(() => isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw 'No user logged in';

      List<ExampleCandidateModel> fetchedCards =
          await AuthService().fetchFlashcardsBySubject(userId, widget.subjectId);

      setState(() {
        cards = fetchedCards;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCloseButton(),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (cards.isEmpty)
              const Center(child: Text('No flashcards available.'))
            else
              _buildCardSwiper(),
            _buildRefreshButton(),
          ],
        ),
      ),
    );
  }
  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IconButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          ),
          icon: const Icon(Icons.close),
        ),
      ),
    );
  }

  Widget _buildCardSwiper() {
    return Expanded(
      child: CardSwiper(
        controller: controller,
        cardsCount: cards.length,
        onSwipe: _onSwipe,
        onUndo: _onUndo,
        numberOfCardsDisplayed: 3,
        backCardOffset: const Offset(40, 40),
        padding: const EdgeInsets.all(24.0),
        cardBuilder: (context, index, _, __) {
          return ExampleCard(cards[index]); // Uses ExampleCard for flipping
        },
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        onPressed: () => controller.swipe(CardSwiperDirection.bottom),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    debugPrint('Swiped card $previousIndex in ${direction.name}. Next card: $currentIndex');
    return true;
  }

  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    debugPrint('Undo swipe on card $currentIndex from ${direction.name}');
    return true;
  }
}
