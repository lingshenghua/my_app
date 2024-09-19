import 'package:flutter/material.dart';

class NestedScrollPage extends StatefulWidget {
  const NestedScrollPage({super.key});

  @override
  State<NestedScrollPage> createState() => _NestedScrollPageState();
}

class _NestedScrollPageState extends State<NestedScrollPage> {
  final List<String> _tabs = const ['tab1', 'tab2', "tab3", "tab4"];
  final ScrollController _customScrollController = ScrollController();
  final ScrollController _nestedScrollController = ScrollController();

  final List<GlobalKey> _anchorKeys = List.generate(
      ['tab1', 'tab2', "tab3", "tab4"].length, (index) => GlobalKey());

  /// 滚动到对应锚点的方法
  void _scrollToAnchor(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyContext = _anchorKeys[index].currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _nestedScrollController.addListener(onScroll);
    _customScrollController.addListener(onScroll);
  }

  void onScroll() {
    print(_nestedScrollController.offset);
    print('1111111111111111111111111111111');
    print(_customScrollController.offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          // controller: _nestedScrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _buildHeader(context, innerBoxIsScrolled),
            ];
          },
          body: _buildTabBarView(),
        ),
      ),
    );
  }

  // 头部
  Widget _buildHeader(BuildContext context, bool innerBoxIsScrolled) {
    return // SliverOverlapAbsorber 的作用是处理重叠滚动效果，
        // 防止 CustomScrollView 中的滚动视图与其他视图重叠。
        SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver:
          // SliverAppBar 的作用是创建可折叠的顶部应用程序栏，
          // 它可以随着滚动而滑动或固定在屏幕顶部，并且可以与其他 Sliver 小部件一起使用。
          SliverAppBar(
        title: const Text('NestedScrollPage'),
        pinned: true,
        elevation: 6,
        //影深
        expandedHeight: 300.0,
        forceElevated: innerBoxIsScrolled,
        //为true时展开有阴影
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: Colors.blue,
            child: const Center(
              child: Text('滚动一致性'),
            ),
          ),
        ),

        // 底部固定栏
        bottom: MyCustomAppBar(
          child: Column(
            children: [
              TabBar(
                tabs: _tabs
                    .map((String name) => Tab(
                          text: name,
                        ))
                    .toList(),
              ),
              Container(
                height: 50,
                color: Colors.greenAccent,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_tabs.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _scrollToAnchor(index),
                          child: Text('锚点${index + 1}'),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: _tabs.map((String name) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                // controller: _customScrollController,
                key: PageStorageKey<String>(name),
                slivers: <Widget>[
                  // SliverOverlapInjector 的作用是处理重叠滚动效果，
                  // 确保 CustomScrollView 中的滚动视图不会与其他视图重叠。
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),

                  // 固定高度内容
                  SliverToBoxAdapter(
                    child: Container(
                      key: _anchorKeys[0],
                      height: 700,
                      color: Colors.greenAccent,
                      child: const Center(child: Text('固定高度内容0')),
                    ),
                  ),

                  // 固定高度内容
                  SliverToBoxAdapter(
                    child: Container(
                      height: 600,
                      key: _anchorKeys[1],
                      color: Colors.red,
                      child: const Center(child: Text('固定高度内容1')),
                    ),
                  ),

                  // 固定高度内容
                  SliverToBoxAdapter(
                    child: Container(
                      height: 800,
                      key: _anchorKeys[2],
                      color: Colors.blue,
                      child: const Center(child: Text('固定高度内容2')),
                    ),
                  ),

                  // 固定高度内容
                  SliverToBoxAdapter(
                    child: Container(
                      height: 500,
                      key: _anchorKeys[3],
                      color: Colors.yellow,
                      child: const Center(child: Text('固定高度内容3')),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }).toList(),
    );
  }
}


class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const MyCustomAppBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20.0);
}