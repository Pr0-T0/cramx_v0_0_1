class ExampleCandidateModel {
  final String question;
  final String answer;

  ExampleCandidateModel({
    required this.question,
    required this.answer,
  });

  // Factory method to create an instance from a database map
  factory ExampleCandidateModel.fromMap(Map<String, dynamic> map) {
    return ExampleCandidateModel(
      question: map['question'] ?? 'No Question',
      answer: map['answer'] ?? 'No Answer',
    );
  }
}
