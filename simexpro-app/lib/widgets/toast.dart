// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class CustomToastWidget extends StatelessWidget {
//   final FToast fToast;
//   final String message;

//   CustomToastWidget(this.fToast, this.message);

//   void showToast() {
//     Widget toast = Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25.0),
//         color: Colors.greenAccent,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.check),
//           SizedBox(
//             width: 12.0,
//           ),
//           Text(message), // Utiliza el mensaje personalizado aquí
//         ],
//       ),
//     );

//     fToast.showToast(
//       child: toast,
//       gravity: ToastGravity.BOTTOM,
//       toastDuration: Duration(seconds: 2),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); // Puedes personalizar este widget según tus necesidades.
//   }
// }
