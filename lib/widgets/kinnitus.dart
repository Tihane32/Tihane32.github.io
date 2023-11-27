import 'package:flutter/material.dart';

void Kinnitus(BuildContext context, String contentMessage) {
  bool dialogDismissed = false; // Flag to track whether the dialog is dismissed

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        // Use WillPopScope to detect when the user tries to dismiss the dialog
        onWillPop: () async {
          dialogDismissed = true; // Set the flag to true when the user dismisses the dialog
          return true;
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.transparent,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.all(0),
            content: Card(
              color: Color.fromARGB(255, 154, 202, 158).withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_outlined,
                      size: 60.0,
                      color: Color.fromARGB(255, 2, 150, 7),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kinnitatud!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            contentMessage,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  // Close the dialog after 5 seconds only if it was not dismissed manually
  Future.delayed(Duration(seconds: 5), () {
    if (!dialogDismissed) {
      Navigator.pop(context);
    }
  });
}

