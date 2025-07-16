import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'box_breathing_step_screen.dart';
import '../widgets/custom_back_button.dart';

class BoxBreathingWalkthroughScreen extends StatefulWidget {
  const BoxBreathingWalkthroughScreen({Key? key}) : super(key: key);

  @override
  State<BoxBreathingWalkthroughScreen> createState() =>
      _BoxBreathingWalkthroughScreenState();
}

class _BoxBreathingWalkthroughScreenState
    extends State<BoxBreathingWalkthroughScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < _walkthroughs.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  static final List<_WalkthroughData> _walkthroughs = [
    _WalkthroughData(
      backgroundColor: Colors.white,
      textColor: Colors.black,
      content:
          'Inhale, hold, exhale, hold—each for 4 seconds. A calming rhythm to centre your mind.',
      imageAsset: 'assets/images/nature-benefits.svg',
    ),
    _WalkthroughData(
      backgroundColor: Color(0xFFB8B8FF),
      textColor: Colors.white,
      content: '''
• Inhale through your nose for 4 seconds
• Hold your breath for 4 seconds
• Exhale slowly through your mouth for 4 seconds
• Hold your breath again for 4 seconds
• Repeat this cycle for 4 minutes''',

      imageAsset: 'assets/images/serene.svg',
    ),
    _WalkthroughData(
      backgroundColor: Color(0xFF39346B),
      textColor: Colors.white,
      customContent:
          (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 394,
                  width: 358,
                  child: SvgPicture.asset(
                    'assets/images/Meditation-pana.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Pro Tip',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Maintain a steady pace; visualise tracing a square with each phase.',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
    ),
    _WalkthroughData(
      backgroundColor: Color(0xFF28254A),
      textColor: Colors.white,
      customContent:
          (context) => Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 148),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Environment',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Sit upright in a quiet space with minimal distractions',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    height: 349,
                    width: 349,
                    child: SvgPicture.asset(
                      'assets/images/Breathing exercise-cuate.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: SizedBox(
                      width: 348,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF28254A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => BoxBreathingStepScreen(
                                    totalSeconds: 4 * 60, // 4 minutes
                                  ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Let's Start",
                              style: TextStyle(
                                fontFamily: 'General Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: -0.5,
                                color: Color(0xFF28254A),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Color(0xFF28254A),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _walkthroughs.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, index) {
          final data = _walkthroughs[index];
          final isLastPage = index == _walkthroughs.length - 1;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isLastPage ? null : _nextPage,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: data.backgroundColor,
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 8,
                    child: CustomBackButton(
                      iconColor: data.textColor,
                      iconSize: 24,
                      onPressed: () {
                        if (_currentPage == 0) {
                          Navigator.of(context).pop();
                        } else {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                  if (data.customContent != null)
                    data.customContent!(context)
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            data.content ?? '',
                            style: TextStyle(
                              color: data.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Quicksand',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (data.imageAsset != null)
                          SizedBox(
                            height:
                                data.imageAsset ==
                                        'assets/images/nature-benefits.svg'
                                    ? 255
                                    : data.imageAsset ==
                                        'assets/images/serene.svg'
                                    ? 342
                                    : 180,
                            width:
                                data.imageAsset ==
                                        'assets/images/nature-benefits.svg'
                                    ? 406
                                    : data.imageAsset ==
                                        'assets/images/serene.svg'
                                    ? 364
                                    : null,
                            child:
                                data.imageAsset!.endsWith('.svg')
                                    ? SvgPicture.asset(
                                      data.imageAsset!,
                                      fit: BoxFit.contain,
                                    )
                                    : Image.asset(
                                      data.imageAsset!,
                                      fit: BoxFit.contain,
                                    ),
                          ),
                      ],
                    ),
                  if (!isLastPage)
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Tap anywhere to continue',
                          style: TextStyle(
                            color: data.textColor.withOpacity(0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Quicksand',
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WalkthroughData {
  final Color backgroundColor;
  final Color textColor;
  final String? content;
  final String? imageAsset;
  final Widget Function(BuildContext)? customContent;

  const _WalkthroughData({
    required this.backgroundColor,
    required this.textColor,
    this.content,
    this.imageAsset,
    this.customContent,
  });
}
