import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:tv_flutter/api/weather.dart';
import 'package:tv_flutter/utils/const.dart';
import 'package:tv_flutter/utils/store.dart';
import 'package:tv_flutter/widgets/flexWithGaps.dart';

enum InputKey { playAddr, weatherAddr }

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  defaultSysCfg? cfg;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  defaultSysCfg? modifiedVal;

  @override
  void initState() {
    defaultSysCfg().getValues().then((val) {
      setState(() {
        cfg = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cfg == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('系统设置'),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: FlexWithGaps(
                  direction: Axis.vertical,
                  gap: 32,
                  children: [
                    FlexWithGaps(children: [
                      _renderText('天气地址'),
                      Expanded(
                        child: _input(
                          key: InputKey.weatherAddr,
                          cfg!.weatherAddr,
                          placeholder: '首页的天气信息获取地址, 默认北京',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入天气地址';
                            }
                            return null;
                          },
                        ),
                      )
                    ]),
                    FlexWithGaps(children: [
                      _renderText('配置地址'),
                      Expanded(
                        child: _input(cfg!.playAddr,
                            placeholder: '请输入配置地址url',
                            keyboardType: TextInputType.url,
                            key: InputKey.playAddr, validator: (String? val) {
                          if (val == null ||
                              val.isEmpty ||
                              !val.startsWith('http')) {
                            return '请输入合法的 URL 地址';
                          }
                          return null;
                        }),
                      )
                    ]),
                    ElevatedButton(
                      style: ButtonStyle(foregroundColor:
                          WidgetStateProperty.resolveWith<Color>((col) {
                        return Colors.black;
                      })),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onSave();
                        }
                      },
                      child: const Text('保存修改'),
                    ),
                  ],
                ))));
  }

  void _onSave() {
    if (modifiedVal != null) {
      final isSameCity = modifiedVal!.weatherAddr == cfg!.weatherAddr;
      if (modifiedVal!.playAddr == cfg!.playAddr && isSameCity) return;
      setState(() {
        cfg = defaultSysCfg(
            playAddr: modifiedVal!.playAddr,
            weatherAddr: modifiedVal!.weatherAddr);
      });
      defaultSysCfg().setValues(modifiedVal!).then((onValue) {
        BrnToast.show('保存成功！', context);

        if (!isSameCity) {
          localStore
              .create<List<Weather>>(LocalStoreKeyType.weather)
              .then((store) {
            Weather.getWeather(
                store: store, cityName: modifiedVal!.weatherAddr);
          });
        }
      });
    }
  }

  Widget _renderText(String msg) {
    return Text(style: const TextStyle(fontSize: 24), msg);
  }

  Widget _input(String initialValue,
      {String? placeholder,
      FormFieldValidator<String>? validator,
      required InputKey key,
      TextInputType? keyboardType}) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
        padding: const EdgeInsets.only(left: 8),
        child: TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: placeholder),
          style: const TextStyle(fontSize: 24),
          initialValue: initialValue,
          validator: validator,
          onChanged: (value) {
            String trimStr = value.trim();
            if (trimStr.isEmpty) return;
            defaultSysCfg val = modifiedVal ??
                defaultSysCfg(
                    playAddr: cfg!.playAddr, weatherAddr: cfg!.weatherAddr);
            if (key == InputKey.playAddr) {
              val.playAddr = trimStr;
            } else {
              val.weatherAddr = trimStr;
            }
            setState(() {
              modifiedVal = val;
            });
          },
        ));
  }
}
