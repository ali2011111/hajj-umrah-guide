import '../models/hajj_day.dart';

const List<HajjDay> hajjDays = [
  HajjDay(
    date: '8th',
    title: 'Day of Tarwiyah',
    location: 'Mina',
    activities: [
      'Enter Ihram for Hajj',
      'Travel to Mina',
      'Pray the five prayers in Mina',
      'Spend the night in Mina',
    ],
  ),

  HajjDay(
    date: '9th',
    title: 'Day of Arafah',
    location: 'Arafat',
    activities: [
      'Travel from Mina to Arafat after sunrise',
      'Spend the day in worship and dua at Arafat',
      'Perform Wuquf (standing) at Arafat',
      'Pray Dhuhr and Asr combined at Arafat',
      'Travel to Muzdalifah after sunset',
    ],
  ),

  HajjDay(
    date: "Night of 9th",
    title: "Muzdalifah",
    location: "Muzdalifah",
    activities: [
      "Pray Maghrib and Isha combined at Muzdalifah",
      "Collect pebbles for Jamarat",
      "Spend the night in Muzdalifah",
      "Pray Fajr at Muzdalifah",
      "Travel back to Mina after Fajr",
    ],
  ),

  HajjDay(
    date: '11th',
    title: 'Days of Tashreeq',
    location: 'Mina',
    activities: [
      'Stone the small Jamarah',
      'Stone the middle Jamarah',
      'Stone Jamrat al-Aqabah',
      'Spend the night in Mina',
    ],

  ),

  HajjDay(
    date: '12th',
    title: 'Days of Tashreeq',
    location: 'Mina',
    activities: [
      'Stone the small Jamarah',
      'Stone the middle Jamarah',
      'Stone Jamrat al-Aqabah',
      'Leave Mina or stay for the 13th',
    ],

  ),

  HajjDay(
    date: '13th',
    title: 'Final Day in Mina',
    location: 'Mina',
    activities: [
      'Stone the small Jamarah',
      'Stone the middle Jamarah',
      'Stone Jamrat al-Aqabah',
      'Leave Mina and return to Makkah',
    ],

  ),

  HajjDay(
    date: 'Farewell',
    title: 'Tawaf al-Wada',
    location: 'Makkah',
    activities: [
      'Perform seven rounds of Tawaf',
      'Pray two rak\'ah after Tawaf',
      'Drink Zamzam',
      'Depart from Makkah',
    ],

  ),

];