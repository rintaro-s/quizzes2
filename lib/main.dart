import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizHomePage(),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final List<Map<String, String>> _questions = [];
  final List<Map<String, String>> _incorrectQuestions = [];
  String _currentQuestion = '';
  String _currentAnswer = '';
  String _userAnswer = '';
  bool _quizStarted = false;
  int _currentQuestionIndex = 0;

  void _addQuestion() {
    setState(() {
      if (_questionController.text.isNotEmpty && _answerController.text.isNotEmpty) {
        _questions.add({
          'question': _questionController.text,
          'answer': _answerController.text,
        });
        _questionController.clear();
        _answerController.clear();
      }
    });
  }

  void _shuffleQuestions() {
    setState(() {
      _questions.shuffle();
    });
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _currentQuestionIndex = 0;
      _incorrectQuestions.clear();
      _showNextQuestion();
    });
  }

  void _showNextQuestion() {
    if (_currentQuestionIndex < _questions.length) {
      setState(() {
        _currentQuestion = _questions[_currentQuestionIndex]['question']!;
        _currentAnswer = _questions[_currentQuestionIndex]['answer']!;
        _userAnswer = '';
      });
    } else {
      _showResults();
    }
  }

  void _checkAnswer() {
    setState(() {
      if (_userAnswer.trim() == _currentAnswer.trim()) {
        _currentQuestionIndex++;
        _showNextQuestion();
      } else {
        _incorrectQuestions.add({
          'question': _currentQuestion,
          'answer': _currentAnswer,
        });
        _currentQuestionIndex++;
        _showNextQuestion();
      }
    });
  }

  void _showResults() {
    setState(() {
      _quizStarted = false;
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( // Kept the Column inside the SingleChildScrollView
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_quizStarted) ...[
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Enter your question',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'Enter the answer',
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: Text('Add Question'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _shuffleQuestions,
                  child: Text('Shuffle Questions'),
                ),
                SizedBox(height: 20),
                Text('Questions List:', style: TextStyle(fontSize: 18)),
                ..._questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  final isIncorrect = _incorrectQuestions.any(
                          (q) => q['question'] == question['question']
                  );
                  return ListTile(
                    title: Text(question['question']!),
                    subtitle: Text(question['answer']!),
                    trailing: isIncorrect
                        ? Icon(Icons.circle, color: Colors.red, size: 24)
                        : null,
                    onLongPress: () => _deleteQuestion(index),
                  );
                }).toList(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _questions.isNotEmpty ? _startQuiz : null,
                  child: Text('Start Quiz'),
                ),
              ],
              if (_quizStarted) ...[
                if (_currentQuestion.isNotEmpty) ...[
                  Text(
                    'Question:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _currentQuestion,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _userAnswer = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Your Answer',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    child: Text('Submit Answer'),
                  ),
                ],
                if (_currentQuestionIndex >= _questions.length) ...[
                  SizedBox(height: 20),
                  Text('Quiz Completed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Incorrect Questions:', style: TextStyle(fontSize: 18)),
                  ..._incorrectQuestions.map((q) => ListTile(
                    title: Text(q['question']!),
                    subtitle: Text(q['answer']!),
                  )),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _questions.clear();
                        _incorrectQuestions.clear();
                      });
                    },
                    child: Text('Clear All Questions'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _startQuiz,
                    child: Text('Restart Quiz'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
