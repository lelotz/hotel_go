import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:context_menus/context_menus.dart';
import 'package:flutter/services.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class IllustrationExample extends StatefulWidget {
  const IllustrationExample({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _IllustrationExampleState createState() => _IllustrationExampleState();
}

class _IllustrationExampleState extends State<IllustrationExample> {
  Color color = Colors.red;
  UnDrawIllustration illustration = UnDrawIllustration.mobile_application;
  Timer? timer;
  final List<UnDrawIllustration> _filtered = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios),onPressed: (){Get.back();},),
        actions: [
          IconButton(
              onPressed: () {
                showAboutDialog(context: context, children: [
                  TextButton(
                      onPressed: () =>
                          launch("https://pub.dev/packages/ms_undraw"),
                      child: const Text('https://pub.dev/packages/ms_undraw')),
                  TextButton(
                      onPressed: () => launch("https://undraw.co/"),
                      child: const Text('https://undraw.co/')),
                ]);
              },
              icon: const Icon(Icons.info))
        ],
        title: TextFormField(
          onChanged: (s) {
            timer?.cancel();
            timer = Timer(const Duration(seconds: 1), () {
              _filtered.clear();
              if (s.isNotEmpty) {
                _filtered.addAll(UnDrawIllustration.values.where((element) =>
                    _changeName(element.name)
                        .toLowerCase()
                        .contains(s.toLowerCase())));
              }
              setState(() {});
            });
          },
          cursorColor: Colors.black,
          style: const TextStyle(
            color: Colors.black,
            decorationColor: Colors.white,
          ),
          decoration: const InputDecoration(
            label: Text("Type to search",style: TextStyle(color: Colors.black),),
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            isDense: true,
            iconColor: Colors.white,
            focusColor: Colors.white,
            prefixIconColor: Colors.white,
            labelStyle: TextStyle(color: Colors.white),
            suffixIconColor: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.color_lens),
        onPressed: () {
          setState(() {
            color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                .withOpacity(1.0);
          });
        },
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1024),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1,
                  mainAxisExtent: 285 + 28 + 16,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16),
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, index) {
                final undraw = _filtered.isEmpty
                    ? UnDrawIllustration.values[index]
                    : _filtered[index];
                return ContextMenuRegion(
                  contextMenu: GenericContextMenu(
                    buttonConfigs: [
                      ContextMenuButtonConfig("Copy name",
                          onPressed: () => _copyName(undraw)),
                      ContextMenuButtonConfig("Copy widget code",
                          onPressed: () => _copyCode(undraw)),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4))
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(_changeName(undraw.name)),
                        SizedBox(
                          // height: 220+67,
                          child: Center(
                            child: UnDraw(
                              color: color,
                              useMemCache: false,
                              height: 170,
                              width: 200,
                              illustration: undraw,
                              placeholder:
                              const Text("Illustration is loading..."),
                              errorWidget: const Icon(Icons.error_outline,
                                  color: Colors.red, size: 50),
                            ),
                          ),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            TextButton.icon(
                                onPressed: () => _copyName(undraw),
                                icon: const Icon(Icons.copy),
                                label: const Text("Copy name")),
                            const Spacer(),
                            TextButton.icon(
                                onPressed: () => _copyCode(undraw),
                                icon: const Icon(Icons.code),
                                label: const Text("Copy Widget code")),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _filtered.isEmpty
                  ? UnDrawIllustration.values.length
                  : _filtered.length),
        ),
      ),
    );
  }

  String _changeName(String name) {
    return name
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((e) => "${e[0].toUpperCase()}${e.substring(1).toLowerCase()}")
        .toList()
        .join(' ')
        .trim();
  }

  _copyName(UnDrawIllustration undraw) {
    Clipboard.setData(ClipboardData(text: "UnDrawIllustration.${undraw.name}"));
  }

  _copyCode(UnDrawIllustration undraw) {
    Clipboard.setData(ClipboardData(text: """UnDraw(
      color: Theme.of(context).primaryColor,
      illustration: UnDrawIllustration.${undraw.name},
    )"""));
  }
}