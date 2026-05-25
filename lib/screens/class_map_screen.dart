import 'package:flutter/material.dart';
import '../screens/chapter_map_screen.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/responsive_helper.dart';

class ClassMapScreen extends StatefulWidget {
  const ClassMapScreen({super.key});

  @override
  State<ClassMapScreen> createState() => _ClassMapScreenState();
}

class _ClassMapScreenState extends State<ClassMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _class4Controller;
  late AnimationController _class5Controller;
  late AnimationController _class6Controller;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 300);
    _class4Controller = AnimationController(vsync: this, duration: duration);
    _class5Controller = AnimationController(vsync: this, duration: duration);
    _class6Controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _class4Controller.dispose();
    _class5Controller.dispose();
    _class6Controller.dispose();
    super.dispose();
  }

  void _onClassPressed(
    int classNumber,
    AnimationController controller,
  ) {
    controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        controller.reverse();
      });
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChapterMapScreen(classNumber: classNumber),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguage(),
      builder: (context, _) {
        final lang = AppLanguage().language;
        String s(String key) => AppStrings.get(key, lang);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(builder: (context) {
              final responsive = context.responsive;
              return Padding(
                padding: EdgeInsets.all(responsive.spacing12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(responsive.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, responsive.spacing4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.brown, size: context.responsive.iconSizeSmall),
                    onPressed: () => Navigator.pop(context),
                    tooltip: s('btn_back'),
                    padding: EdgeInsets.all(responsive.spacing8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              );
            }),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFFDF5E6),
                  ),
                ),
              ),
              SafeArea(
                child: Builder(builder: (context) {
                  final responsive = context.responsive;
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: responsive.spacing20, vertical: responsive.spacing24),
                    children: [
                      SizedBox(height: responsive.spacing40),
                      Text(
                        s('choose_class'),
                        textAlign: TextAlign.center,
                        style: responsive.getTextStyle(
                          size: TextSize.heading,
                          color: Colors.brown,
                          weight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: responsive.spacing8),
                      Text(
                        s('class_subtitle'),
                        textAlign: TextAlign.center,
                        style: responsive.getTextStyle(
                          size: TextSize.body,
                          color: Colors.brown.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: responsive.spacing40),
                      Center(child: _springClassButton(
                        s('class_4'),
                        Icons.looks_4,
                        Colors.purple.shade700,
                        _class4Controller,
                        4,
                        responsive,
                      )),
                      SizedBox(height: responsive.spacing24),
                      Center(child: _springClassButton(
                        s('class_5'),
                        Icons.looks_5,
                        Colors.indigo.shade700,
                        _class5Controller,
                        5,
                        responsive,
                      )),
                      SizedBox(height: responsive.spacing24),
                      Center(child: _springClassButton(
                        s('class_6'),
                        Icons.looks_6,
                        Colors.cyan.shade700,
                        _class6Controller,
                        6,
                        responsive,
                      )),
                      SizedBox(height: responsive.spacing40),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _springClassButton(
    String text,
    IconData icon,
    Color color,
    AnimationController controller,
    int classNumber,
    ResponsiveHelper responsive,
  ) {
    return GestureDetector(
      onTapDown: (_) => _onClassPressed(classNumber, controller),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Transform.scale(
              scale: 0.95 + (controller.value * 0.15),
              child: child,
            ),
            child: Container(
              width: responsive.spacing32 * 2.2,
              height: responsive.spacing32 * 2.2,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: Offset(0, responsive.spacing8),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: Colors.white, size: responsive.iconSizeLarge),
              ),
            ),
          ),
          SizedBox(height: responsive.spacing12),
          Text(
            text,
            style: TextStyle(
              color: Colors.brown,
              fontSize: responsive.fontSizeBody,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
