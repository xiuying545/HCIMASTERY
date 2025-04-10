import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/design_challenge_parent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp1/screen/user/design_challenge/components.dart';


class ProfileDesignChallengePage extends StatefulWidget {
  const ProfileDesignChallengePage({super.key});

  @override
  _ProfileDesignChallengePageState createState() =>
      _ProfileDesignChallengePageState();
}

class _ProfileDesignChallengePageState
    extends DesignChallengeUIState<ProfileDesignChallengePage> {

  @override
  void initState() {
    super.initState();
    components = [
      ProfilePicture(),
      Bio(),
      ContactInfo(),
      EditProfile(),
      Name()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: Text('Profile Page',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            key: lockKey,
            tooltip: 'Lock the element',
            icon: Icon(isPlay ? Icons.lock : Icons.pan_tool),
            onPressed: () => setState(() => isPlay = !isPlay),
          ),
          IconButton(
            key: backgroundColorKey,
            tooltip: 'Change Background Color',
            icon: const Icon(Icons.format_paint),
            onPressed: () async {
              final color = await showColorPickerDialog(canvasBackgroundColor);
              if (color != null) setState(() => canvasBackgroundColor = color);
            },
          ),
        ],
      ),
      body: buildCanvasBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  



  Widget _buildBottomBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      child: BottomAppBar(
        color: Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
       _buildBottomButton('GUIDE', Icons.tips_and_updates, () => showTutorial(true)),
            _buildBottomButton('CHECK', Icons.rate_review, _handleSubmitDesign, key: checkButtonKey),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(String label, IconData icon, VoidCallback onTap, {Key? key}) {
    return ElevatedButton.icon(
      key: key,
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.luckiestGuy(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        elevation: 0,
      ),
    );
  }

  void _toggleOverlay() {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 100,
          left: MediaQuery.of(context).size.width * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            color: Colors.blue.shade900.withOpacity(0.8),
            elevation: 8,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildOverlayIconButton(Icons.account_circle, 'ProfilePicture'),
                  _buildOverlayIconButton(Icons.person, 'Name'),
                  _buildOverlayIconButton(Icons.info, 'Bio'),
                  _buildOverlayIconButton(Icons.phone, 'ContactInfo'),
                  _buildOverlayIconButton(Icons.edit, 'EditProfile'),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(overlayEntry!);
    } else {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  Widget _buildOverlayIconButton(IconData icon, String type) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: () {
        setState(() {
          switch (type) {
            case 'ProfilePicture': components.add(ProfilePicture()); break;
            case 'Name': components.add(Name()); break;
            case 'Bio': components.add(Bio()); break;
            case 'ContactInfo': components.add(ContactInfo()); break;
            case 'EditProfile': components.add(EditProfile()); break;
          }
        });
        _toggleOverlay();
      },
      tooltip: type,
    );
  }

  void _handleSubmitDesign() {
    submitDesign((feedback, designScore) {
      setState(() {
        score = designScore;
        feedbackText = feedback;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Design Feedback"),
          content: Text(feedback),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    });
  }
}
