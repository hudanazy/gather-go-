import 'package:flutter/material.dart';

Future<bool> showMyDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Send event"),
      content: Text(
          "The event request will now be sent for approval. Are you sure you want to continue?"),
      actions: [
        TextButton(
            child: Text("No",
                //             Text('Are you sure you want to continue?"'),,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}

Future<bool> showApproveDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Approve event"),
      content:
          Text("Are you sure you want to you want to approve this event ?"),
      actions: [
        TextButton(
            child: Text("No",
                //             Text('Are you sure you want to continue?"'),,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}

Future<bool> showDispproveDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Disapprove event"),
      content:
          Text("Are you sure you want to you want to disapprove this event ?"),
      actions: [
        TextButton(
            child: Text("No",
                //             Text('Are you sure you want to continue?"'),,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
  // return showDialog<void>(
  //   context: context,
  //   barrierDismissible: false, // user must tap button!
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: const Text('Send event?'),
  //       content: SingleChildScrollView(
  //         child: ListBody(
  //           children: const <Widget>[
  //             Text("The event request will now be sent for approval."),
  //             Text('Are you sure you want to continue?"'),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('No'),
  //           onPressed: () {
  //             Navigator.pop(context, false);
  //           },
  //         ),
  //         TextButton(
  //           child: const Text('Send event'),
  //           onPressed: () {
  //             Navigator.pop(context, true);
  //           },
  //         ),
  //       ],
  //     );
  //   },
  // );
}

Future<bool> showBookDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Book event"),
      content:
          Text("Are you sure you want to book this event ?"),
      actions: [
        TextButton(
            child: Text("No",
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}