import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:injectable/injectable.dart';

typedef ThoughtMetadata = ({String icon, String title, String? reaction});

abstract interface class AiService {
  Future<ThoughtMetadata> generateMetadata(String content);
}

@LazySingleton(as: AiService)
class FirebaseAiService implements AiService {
  const FirebaseAiService();

  static const _modelName = 'gemini-2.5-flash-lite';

  @override
  Future<ThoughtMetadata> generateMetadata(String content) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: _modelName,
      generationConfig: .new(
        responseMimeType: 'application/json',
        responseSchema: .object(
          properties: {
            'icon': .string(
              description: 'An emoji that best represents the text.',
            ),
            'title': .string(
              description: 'A very short title (max 3 words) for the text.',
            ),
            'reaction': .string(
              description:
                  'A short, encouraging or witty reaction message'
                  ' to the user based on the text.',
            ),
          },
        ),
      ),
    );

    final response = await model.generateContent([
      .text(
        'Analyze the following text and generate metadata: '
        '"$content"',
      ),
    ]);
    final text = response.text;

    if (text == null) {
      throw Exception('Empty response from AI');
    }

    final json = jsonDecode(text) as Map<String, dynamic>;
    return (
      icon: json['icon'] as String,
      title: json['title'] as String,
      reaction: json['reaction'] as String,
    );
  }
}
