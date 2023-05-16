import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:flutter/material.dart';

class MainTestScreen extends StatefulWidget {
  const MainTestScreen({super.key});

  @override
  State<MainTestScreen> createState() => _MainTestScreenState();
}

class _MainTestScreenState extends State<MainTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TransmissionButton(
                    title: 'Splash',
                    destination: NameRoutes.kSplashScreen,
                  ),
                  TransmissionButton(
                    title: "Welcome",
                    destination: NameRoutes.kWelcomeScreen,
                  ),
                  TransmissionButton(
                    title: 'onBoarding',
                    destination: NameRoutes.kIntroScreen,
                  ),
                  TransmissionButton(
                    title: 'Successful ',
                    destination: NameRoutes.kSuccessScreen,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TransmissionButton(
                    title: 'Notification',
                    destination: NameRoutes.kNotificationScreen,
                  ),
                  TransmissionButton(
                    title: 'Main Screen',
                    destination: NameRoutes.kHomeScreen,
                  ),
                  TransmissionButton(
                    title: 'AppReview',
                    destination: NameRoutes.kAppReview,
                  ),
                  TransmissionButton(
                    title: 'Profile',
                    destination: NameRoutes.kProfileScreen,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TransmissionButton(
                    title: 'Appointments',
                    destination: NameRoutes.kAppointmentsScreen,
                  ),
                  TransmissionButton(
                    title: 'SearchForSpecialties',
                    destination: NameRoutes.kSearchForSpecialtiesScreen,
                  ),
                  TransmissionButton(
                    title: 'SearchForCity',
                    destination: NameRoutes.kSearchForCityScreen,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TransmissionButton(
                    title: 'ResultOfSearch',
                    destination: NameRoutes.kResultOfSearch,
                  ),
                  TransmissionButton(
                    title: 'DoctorScreen',
                    destination: NameRoutes.kDoctorScreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransmissionButton extends StatelessWidget {
  const TransmissionButton(
      {Key? key, required this.title, required this.destination})
      : super(key: key);
  final String title;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow)),
      onPressed: () {
        Navigator.pushNamed(context, destination);
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
