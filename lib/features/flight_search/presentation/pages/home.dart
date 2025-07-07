import 'dart:ui';
import 'package:flight_search/components/shared/custom_text.dart';
import 'package:flight_search/components/shared/gap.dart';
import 'package:flight_search/components/shared/page_indicator.dart';
import 'package:flight_search/components/shared/pageview.dart';
import 'package:flight_search/features/flight_search/presentation/widgets/search_btn.dart';
import 'package:flight_search/utils/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String route = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _page = 0;
  void setPage(int i) {
    _page = i;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: fullHeight(context) / 1.7,
              pinned: true,
              backgroundColor: Colors.transparent,
              title: TextView(
                text: 'Home',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    CustomPageView(
                      pageController: _pageController,
                      pageSnapping: true,
                      onPageChange: setPage,
                      autoScroll: false,
                      autoScrollDuration: const Duration(seconds: 5),
                      pages: [
                        _OnboardIntro(
                          key: UniqueKey(),
                          imagePath: 'assets/png/intro1.png',
                          title: 'Search Flights Instantly',
                          subtitle: 'Find the best flight deals in seconds',
                          bgColor: Color(0xff3AA6F9),
                        ),
                        _OnboardIntro(
                          key: UniqueKey(),
                          imagePath: 'assets/png/intro2.png',
                          title: 'Compare Prices Easily',
                          subtitle:
                              'Find the best deals on flights from multiple airlines in one place.',
                          bgColor: Color(0xff7C5CE0),
                        ),
                        _OnboardIntro(
                          key: UniqueKey(),
                          imagePath: 'assets/png/intro3.png',
                          title: 'Book with Confidence',
                          subtitle:
                              'Secure your travel plans with our reliable booking process.',
                          bgColor: Color(0xffFF7A59),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: PageViewIndicator(
                        itemCount: 3,
                        currentPage: _page,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: fullHeight(context) / 2,
                color: Colors.white,
                child: Column(children: [_InviteFriends()]),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SearchButton(),
    );
  }
}

class _OnboardIntro extends StatelessWidget {
  const _OnboardIntro({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    super.key,
  });
  final String imagePath;
  final String title;
  final String subtitle;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullHeight(context),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bgColor.withValues(alpha: .6),
            bgColor.withValues(alpha: .8),
            bgColor.withValues(alpha: 1),
            bgColor,
            Colors.white,
          ],
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Gap(10),
          TextView(
            text: title,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
          TextView(
            text: subtitle,
            fontSize: 14,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
          const Gap(20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(
                    alpha: 0.3,
                  ), // semi-transparent
                  elevation: 2,
                ),
                child: TextView(
                  text: 'Get Started',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteFriends extends StatelessWidget {
  const _InviteFriends();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          RiveAnimatedIcon(
            height: 50,
            width: 50,
            loopAnimation: true,
            riveIcon: RiveIcon.share,
            color: Colors.blue,
            strokeWidth: 3,
          ),
          const Gap(24),
          const TextView(
            text: 'Invite friends, earn rewards!',
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const Gap(8),
          TextView(
            text:
                'Both you and your friends get points when they join using your referral.',
            color: Colors.grey.shade600,
            fontSize: 14,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(
                    alpha: 0.3,
                  ), // semi-transparent
                  elevation: 2,
                ),
                child: TextView(
                  text: 'Invite Friends',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
