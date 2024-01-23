import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:openai_dart/openai_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

Future<Response> routesHandler(Request request) async {
  if (request.url.path == 'hello') {
    return Response.ok('Hello, world!');
  } else if (request.url.path == 'randomString') {
    var randomString = _generateRandomString(16);
    return Response.ok(randomString);
  } else if (request.url.path == 'generate') {
    return await _echoRequest(request);
  }
  return Response.notFound('Not Found');
}

String _generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}

Future<Response> _echoRequest(Request request) async {
  try {
    // 注释掉了原来获取环境变量的代码
    final openaiApiKey = Platform.environment['OPENAI_API_KEY'];

    // 使用硬编码的 API 密钥（出于安全考虑，建议使用环境变量或其他安全方式）
    //final openaiApiKey = "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";
    //print('openaiApiKey is ' + openaiApiKey);
    
    // 检查 API 密钥是否为空
    if (openaiApiKey == null) {
      print('API key is null');
      return Response.internalServerError(body: 'OpenAI API key not found.');
    } else {
      print("API key is found. Proceeding to generate image.");
    }




    
    // 读取请求内容
    final content = await request.readAsString();
    print('Request content: $content');
    /*
    // 解析请求数据
    final requestData = json.decode(content);
    print('Parsed request data: $requestData');

    // 获取 prompt
    final prompt = requestData['prompt'] as String? ?? 'A cute baby sea otter';
    print('Using prompt: $prompt');
    */

    final decodedContent = Uri.decodeQueryComponent(content);
    print('Decoded request content: $decodedContent');

    // 解析请求内容为键值对
    final Map<String, String> params = Uri.splitQueryString(decodedContent);
    print('Parsed parameters: $params');

    // 获取 prompt
    final prompt = params['prompt'] ?? 'A cute baby sea otter';
    print('Using prompt: $prompt');    

    // 创建 OpenAI 客户端
    final client = OpenAIClient(apiKey: openaiApiKey);
    print('OpenAI client created');

    // 创建图片
    final res = await client.createImage(
      request: CreateImageRequest(
        model: CreateImageRequestModel.model(ImageModels.dallE3),
        prompt: prompt,
        quality: ImageQuality.hd,
        size: ImageSize.v1024x1792,
        style: ImageStyle.natural,
      ),
    );

    // 检查响应
    print('Received response: ${res.data}');
    if (res.data.isEmpty) {
      print('Response data is empty');
      return Response.internalServerError(body: 'Error: Received empty data from OpenAI');
    }

    // 获取图片 URL
    final imageUrl = res.data.first.url;
    print('Image URL: $imageUrl');

    // 返回响应
    return Response.ok(json.encode({'imageUrl': imageUrl}));
  } catch (e) {
    print('Error during image generation: $e');
    return Response.internalServerError(body: 'Error generating image: $e');
  }
}
