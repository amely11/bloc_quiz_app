import 'package:flutter_bloc/flutter_bloc.dart';

// Define Quiz Events
abstract class QuizEvent {}

class SelectAnswerEvent extends QuizEvent {
  final String answer;
  SelectAnswerEvent(this.answer);
}

class RestartQuizEvent extends QuizEvent {}

// Define Quiz States
abstract class QuizState {}

class QuestionState extends QuizState {
  final String question;
  final List<String> options;
  QuestionState(this.question, this.options);
}

class ResultState extends QuizState {
  final int correctAnswers;
  ResultState(this.correctAnswers);

  int get score => (correctAnswers / 3 * 100).toInt(); // Hitung skor dari 0-100
}

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Apakah Flutter menggunakan bahasa Dart?',
      'options': ['Benar', 'Salah'],
      'correctAnswer': 'Benar'
    },
    {
      'question': 'Apakah Flutter framework untuk backend?',
      'options': ['Benar', 'Salah'],
      'correctAnswer': 'Benar'
    },
    {
      'question': 'Apakah YES berarti YA?',
      'options': ['Benar', 'Salah'],
      'correctAnswer': 'Benar'
    },
  ];

  QuizBloc()
      : super(QuestionState(
            'Apakah Flutter menggunakan bahasa Dart?', ['Benar', 'Salah'])) {
    // Event listener for selecting an answer
    on<SelectAnswerEvent>((event, emit) {
      if (_questions[_currentQuestionIndex]['correctAnswer'] == event.answer) {
        _correctAnswers++;
      }

      _currentQuestionIndex++;

      if (_currentQuestionIndex < _questions.length) {
        final nextQuestion = _questions[_currentQuestionIndex];
        emit(QuestionState(nextQuestion['question'], nextQuestion['options']));
      } else {
        // End of the quiz, show result
        final resultState = ResultState(_correctAnswers);
        emit(resultState);
        print('Nilai anda: ${resultState.score}'); // Cetak nilai ke console
      }
    });

    // Event listener for restarting the quiz
    on<RestartQuizEvent>((event, emit) {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      final firstQuestion = _questions[_currentQuestionIndex];
      emit(QuestionState(firstQuestion['question'], firstQuestion['options']));
    });
  }

  // Getter untuk currentQuestionIndex
  int get currentQuestionIndex => _currentQuestionIndex;
}
