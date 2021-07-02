import 'package:flutter/material.dart';

Widget customListTitle ({required String title, required String singer, required String cover, onTap })
{
  return InkWell(
    onTap: onTap ,
    child: Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(5.0),
             image: DecorationImage(
               image: NetworkImage(cover),
               fit: BoxFit.cover,
             )
           ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                singer,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.0
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}