///
/// @file 直播页面
///

library;

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:tv_flutter/api/lives.dart';
import 'package:video_player/video_player.dart';

enum MenuType { first, second }

class Lives extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Lives();
  }
}

class _Lives extends State<Lives> {
  VideoPlayerController? _controller;
  bool playerReady = false;
  bool isPlaying = true;
  bool isShowMenu = false;
  Map<String, List<Channel>>? categoryMaps;
  Channel? selectChannel;
  String activeCateName = '';
  String activeChannelName = '';
  String playerSourceUrl = '';

  @override
  void initState() {
    super.initState();
    Channel.getAllValues().then((list) {
      if (list != null && list.isNotEmpty) {
        Map<String, List<Channel>> categoryMap = {};
        Channel? firstSource;

        list.forEach((cha) {
          String group = cha.groupName;
          firstSource ??= cha;
          List<Channel>? currentGroup = categoryMap[group];
          if (currentGroup != null) {
            categoryMap[group]!.add(cha);
          } else {
            categoryMap[group] = [cha];
          }
        });

        setState(() {
          categoryMaps = categoryMap;
          selectChannel = firstSource;
          activeCateName = firstSource?.groupName ?? '';
          activeChannelName = firstSource?.name ?? '';
          playerSourceUrl = firstSource?.urls[0] ?? '';
        });
        _initPlayer(firstSource?.urls[0]);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Lives oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  _initPlayer(String? url) {
    if (_controller != null) {
      _controller?.dispose();
    }
    setState(() {
      playerReady = false;
    });

    _controller = VideoPlayerController.networkUrl(Uri.parse(url ?? ''),
        // httpHeaders: RequestHeaders,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ))
      ..initialize().then((_) {
        setState(() {
          playerReady = true;
        });
      })
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    final menuWidth = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned(
                  child: playerReady
                      ? Center(
                          child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ))
                      : const BrnPageLoading(content: '加载中.....')),
              selectChannel != null
                  ? Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                          onDoubleTap: _changePlayState,
                          onTap: _toggleShowMenu,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 44, 16, 8),
                            decoration: BoxDecoration(
                              color: isShowMenu
                                  ? Color.fromARGB(172, 101, 101, 98)
                                  : Colors.transparent,
                            ),
                            child: !isShowMenu
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      _renderCategoryAndChannel(
                                          MenuType.first, menuWidth),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      _renderCategoryAndChannel(
                                          MenuType.second, menuWidth),
                                      _renderUrlSource(menuWidth),
                                    ],
                                  ),
                          )),
                    )
                  : const SizedBox(),
            ],
          )),
    );
  }

  Widget _shadowText(String text, {bool active = false}) {
    return Text(
        style:
            TextStyle(color: active ? Colors.blue : Colors.white, fontSize: 24),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text);
  }

  _changePlayState() {
    if (!playerReady || isShowMenu) return;
    if (isPlaying) {
      _controller?.pause();
    } else {
      _controller?.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  _toggleShowMenu() {
    setState(() {
      activeCateName = selectChannel?.groupName ?? '';
      isShowMenu = !isShowMenu;
    });
  }

  _changePlayerSource(String url) {
    _initPlayer(url);
    setState(() {
      playerSourceUrl = url;
    });
  }

  Widget _renderUrlSource(double menuWidth) {
    if (selectChannel == null || selectChannel!.groupName != activeCateName) {
      return SizedBox();
    } else {
      final liveSource = [_shadowText('直播源')];
      liveSource.addAll(selectChannel!.urls.map((url) {
        return GestureDetector(
            onTap: () => _changePlayerSource(url),
            child: Container(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Center(
                    child: _shadowText(url, active: playerSourceUrl == url))));
      }).toList());

      return GestureDetector(
          onTap: () {},
          child: Container(
              width: menuWidth,
              color: const Color.fromARGB(100, 0, 0, 0),
              height: double.infinity,
              child: ListView(
                  scrollDirection: Axis.vertical, children: liveSource)));
    }
  }

  Widget _renderCategoryAndChannel(MenuType menuType, double menuWidth) {
    List<Widget> menuItem = [];
    List<String> categorys =
        categoryMaps != null ? categoryMaps!.keys.toList() : [];
    if (menuType == MenuType.first) {
      for (int i = 0; i < categorys.length; i++) {
        menuItem.add(_renderCategoryItem('${categorys[i]}'));
      }
    } else {
      if (activeCateName.isNotEmpty && categoryMaps != null) {
        List<Channel>? channels = categoryMaps![activeCateName];

        if (channels != null) {
          for (int i = 0; i < channels.length; i++) {
            menuItem
                .add(_renderMenuItem(channels[i].name, channel: channels[i]));
          }
        }
      }
    }
    return GestureDetector(
        onTap: () {},
        child: Container(
            width: menuWidth,
            color: const Color.fromARGB(100, 0, 0, 0),
            height: double.infinity,
            child:
                ListView(scrollDirection: Axis.vertical, children: menuItem)));
  }

  Widget _renderCategoryItem(String text) {
    bool isActive = activeCateName == text;
    return GestureDetector(
        onTap: () => _onMenuClick(menuType: MenuType.first, name: text),
        child: Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Center(child: _shadowText(text, active: isActive))));
  }

  Widget _renderMenuItem(String text, {required Channel channel}) {
    final isActive = activeChannelName == text;
    return GestureDetector(
        onTap: () => _onMenuClick(
            menuType: MenuType.second, name: channel.name, channel: channel),
        child: Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Center(child: _shadowText(text, active: isActive))));
  }

  _onMenuClick(
      {required MenuType menuType, required String name, Channel? channel}) {
    if (menuType == MenuType.first) {
      setState(() {
        activeCateName = name;
      });
    } else if (menuType == MenuType.second && channel != null) {
      String playUrl = channel.urls[0];
      setState(() {
        activeCateName = channel.groupName;
        selectChannel = channel;
        activeChannelName = name;
        playerSourceUrl = playUrl;
      });
      _initPlayer(playUrl);
    }
  }
}
