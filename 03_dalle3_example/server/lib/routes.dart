import 'dart:math';
import 'dart:convert';
import 'package:dotenv/dotenv.dart' show load, env;
import 'package:openai_dart/openai_dart.dart';
import 'package:shelf/shelf.dart';


Future<Response> routesHandler(Request request) async {
  if (request.url.path == 'hello') {
    return Response.ok('Hello, world!');
  } else if (request.url.path == 'randomString') {
    var randomString = _generateRandomString(16);
    return Response.ok(randomString);
  } else if (request.url.path == 'generate') {
    //return await _echoRequest(request);
    return await _generateImage(request);
  }
  return Response.notFound('Not Found');
}

Future<Response> _generateImage(Request request) async {
  load(); // 加载.env文件中的配置

  final apiKey = env['OPENAI_API_KEY'];
  if (apiKey == null) {
    return Response.internalServerError(body: 'OpenAI API key not found.');
  }

  try {
    final payload = await request.readAsString();
    final data = json.decode(payload);
    final prompt = data['prompt'];
    print(prompt);

    final client = OpenAIClient(apiKey: apiKey);
    final res = await client.createImage(
      request: CreateImageRequest(
        model: CreateImageRequestModel.model(ImageModels.dallE3),
        prompt: prompt,
        quality: ImageQuality.hd,
        size: ImageSize.v1024x1792,
        style: ImageStyle.natural,
      ),
    );

    if (res.data.isEmpty) {
      return Response.internalServerError(body: 'Error: Received empty data from OpenAI.');
    }

    final imageUrl = res.data.first.url;
    return Response.ok(json.encode({'imageUrl': imageUrl}), headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: 'Error generating image: $e');
  }
}

String _generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}
