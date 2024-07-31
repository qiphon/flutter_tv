import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:tv_flutter/api/index.dart';

class FeedbackErr {
  static uploadString(String text) {
    log('upload text $text');
    request
        .post(
      'https://open.feishu.cn/open-apis/bot/v2/hook/fab38087-8005-40ac-ae8f-c6efe5cb6173',
      data: jsonEncode({
        'msg_type': 'interactive',
        'card': {
          'header': {
            'title': {
              'content': '「TV 反馈」',
              'tag': 'plain_text',
            },
          },
          'elements': [
            {
              'tag': 'div',
              'text': {
                'content': '''
                        **feed back from flutter tv**
                        **feedbackText：** ${text} 
                        **platform: **: ${Platform.operatingSystem}
                        **version: **: ${Platform.version}
                        **operatingSystemVersion: **: ${Platform.operatingSystemVersion}
                     ''',
                'tag': 'plain_text',
              },
            },
          ],
        },
      }),
    )
        .catchError((err) {
      log('$err');
    });
  }
}
