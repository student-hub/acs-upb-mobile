// import 'package:acs_upb_mobile/widgets/radio_emoji.dart';
// import 'package:flutter/material.dart';
//
// class FeedbackFormField extends StatelessWidget {
//   const FeedbackFormField(
//       {@required this.question,
//       this.error});
//
//   /// `question` you want to ask
//   final String question;
//
//   /// `error` to be displayed below emojis row
//   ///
//   /// mostly used if no option is selected
//   final String error;
//
//   /// Determines the number of radio buttons according to their taste
//   ///
//   /// 😠 😕 😐 ☺ 😍
//   static final List<int> _radioButtons = [1, 2, 3, 4, 5];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           '$question',
//           style: const TextStyle(
//             fontSize: 18,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: _radioButtons.map((value) {
//             return RadioEmoji(
//               value: value,
//             );
//           }).toList(),
//         ),
//         const SizedBox(
//           height: 2,
//         ),
//         Visibility(
//           visible: error != null,
//           child: Text(
//             '$error',
//             style: const TextStyle(
//               color: Colors.red,
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }
// }
