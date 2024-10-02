import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/quiz_bloc.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Flutter'),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        centerTitle: true, // Center the title
        titleTextStyle: const TextStyle(
          color: Colors.black, // Black text color
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuestionState) {
            // Hitung nomor pertanyaan
            int questionNumber =
                context.read<QuizBloc>().currentQuestionIndex + 1;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tampilkan nomor pertanyaan
                    Text(
                      'Pertanyaan $questionNumber', // Dynamic title for question number
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        height: 20), // Spacing between title and question box
                    Container(
                      padding: const EdgeInsets.all(
                          30.0), // Add more space inside the box
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors
                                .black), // Black border around the question
                        borderRadius: BorderRadius.circular(
                            15), // Slightly more rounded corners
                      ),
                      child: Text(
                        state.question,
                        style:
                            const TextStyle(fontSize: 15), // Adjust text size
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                        height: 40), // Spacing between question and buttons
                    const Text(
                      'Pilih jawaban anda!', // Instruction text
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: state.options.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String option = entry.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10), // Space between buttons
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: idx == 0
                                  ? Colors.blue
                                  : Colors.red, // Consistent colors for buttons
                              minimumSize:
                                  const Size(250, 60), // Set button size
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30), // More rounded buttons
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<QuizBloc>()
                                  .add(SelectAnswerEvent(option));
                            },
                            child: Text(
                              option,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white), // White text on buttons
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ResultState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Quiz Selesai!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nilai anda: ${state.score}', // Display the calculated score
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<QuizBloc>().add(RestartQuizEvent());
                    },
                    child: const Text('Ulangi Quiz'),
                  ),
                ],
              ),
            );
          }
          return Container(); // Default empty container if no state
        },
      ),
    );
  }
}
