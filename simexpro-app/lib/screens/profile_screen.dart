import 'package:flutter/material.dart';
import 'package:simexpro/utils/user_preferences.dart';
import 'package:simexpro/widgets/appbar_widget.dart';
import 'package:simexpro/widgets/profile_widget.dart';
import 'package:simexpro/model/user.dart';
import 'package:simexpro/widgets/button_widget.dart';

class ProfileScreen extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    final user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 20),
          buildAbout(user),
        ],
      ),
    );
  }

   Widget buildName(User user) => Column(
        children: [
          Text(
            user.username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ],
      );

 

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                child: Icon(
                Icons.person_outline,
                color: Color.fromRGBO(87, 69, 223, 1),
                size: 28.0,
                ),
              ),
            title: Text(
              "Nombre",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
            // Icon(
            //   Icons.person_outline,
            //   color: Color.fromRGBO(87, 69, 223, 1),
            //   size: 24.0,
            // ),
            // Text(
            //   'Nombre',
            //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            Divider(height: 50),

            const SizedBox(height: 16),
            Icon(
              Icons.markunread,
              color: Color.fromRGBO(87, 69, 223, 1),
              size: 24.0,
            ),
            Text(
              'Correo Electrónico',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              
            ),
            const SizedBox(height: 10),
            Text(
              user.email,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            Divider(height: 50),

            const SizedBox(height: 16),
            Icon(
              Icons.manage_accounts,
              color: Color.fromRGBO(87, 69, 223, 1),
              size: 24.0,
            ),
            Text(
              'Rol',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              user.rol,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            Divider(height: 50),

          ],
        ),
      );
}