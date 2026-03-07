import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/ai/presentation/pages/ai_page.dart';
import 'package:nepalink/features/dashboard/ai/presentation/view_model/ai_view_model.dart';
import 'package:nepalink/features/dashboard/ai/domain/entities/ai_entity.dart';
import 'package:nepalink/features/dashboard/ai/domain/usecases/get_ai_summaries_usecase.dart';

@GenerateMocks([GetAiSummariesUsecase])
import 'ai_page_test.mocks.dart';

void main() {
  late MockGetAiSummariesUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockGetAiSummariesUsecase();
  });

  group('AiPage widget tests', () {
    // FIX 3: The mock returns a Future.delayed(10s), which leaves a pending timer
    // after the widget tree is disposed — Flutter test framework throws on this.
    // Fix: after pump(), advance time by the full delay duration using
    // tester.pump(duration) so the timer fires and completes cleanly.
    testWidgets('shows loading indicator when state is loading', (
      tester,
    ) async {
      when(mockUsecase.call()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(seconds: 10),
          () => const Right(<AiEntity>[]),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );

      // One pump renders the first frame — the async call hasn't resolved yet,
      // so the ViewModel is still in the loading state.
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Drain the pending 10-second timer so no timers are left when the
      // test ends, preventing the "Timer is still pending" assertion error.
      await tester.pump(const Duration(seconds: 10));
    });

    testWidgets('shows No AI Summaries Yet when list is empty', (tester) async {
      when(
        mockUsecase.call(),
      ).thenAnswer((_) async => const Right(<AiEntity>[]));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No AI Summaries Yet'), findsOneWidget);
    });

    testWidgets('shows error message when usecase fails', (tester) async {
      when(mockUsecase.call()).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Failed to load summaries')),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Failed to load summaries'), findsOneWidget);
    });

    testWidgets('shows Retry button on error', (tester) async {
      when(mockUsecase.call()).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Failed to load summaries')),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows AI Summaries app bar title', (tester) async {
      when(
        mockUsecase.call(),
      ).thenAnswer((_) async => const Right(<AiEntity>[]));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('AI Summaries'), findsOneWidget);
    });

    testWidgets('shows summaries list when data is loaded', (tester) async {
      final tSummaries = [
        AiEntity(
          id: 'ai-001',
          description: 'Morning checkup',
          aiSummary: 'Patient is stable',
          date: DateTime(2025, 3, 10),
          status: 'completed',
          memberName: 'Ram Bahadur',
          nurseName: 'Kiran Rana',
        ),
      ];
      when(mockUsecase.call()).thenAnswer((_) async => Right(tSummaries));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Morning checkup'), findsOneWidget);
    });

    testWidgets('shows ai summary text in card', (tester) async {
      final tSummaries = [
        AiEntity(
          id: 'ai-001',
          description: 'Morning checkup',
          aiSummary: 'Patient is stable and recovering well',
          date: DateTime(2025, 3, 10),
          status: 'completed',
          memberName: 'Ram Bahadur',
          nurseName: 'Kiran Rana',
        ),
      ];
      when(mockUsecase.call()).thenAnswer((_) async => Right(tSummaries));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Patient is stable and recovering well'),
        findsOneWidget,
      );
    });

    testWidgets('shows member name in summary card', (tester) async {
      final tSummaries = [
        AiEntity(
          id: 'ai-001',
          description: 'Evening medication',
          aiSummary: 'Medication administered',
          date: DateTime(2025, 3, 10),
          status: 'pending',
          memberName: 'Sita Devi',
          nurseName: 'Kiran Rana',
        ),
      ];
      when(mockUsecase.call()).thenAnswer((_) async => Right(tSummaries));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiViewModelProvider.overrideWith(
              (ref) => AiViewModel(getAiSummaries: mockUsecase),
            ),
          ],
          child: const MaterialApp(home: AiPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Sita Devi'), findsOneWidget);
    });
  });
}
