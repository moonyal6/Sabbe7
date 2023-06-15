import '../constants.dart';

const Map<String, dynamic> en =
{
  '@lang_data': {
    'lang_short': 'en',
    'lang_name': 'English'
  },
  '@counters': {
    cnt1_key: 'Subhanallah',
    cnt2_key: 'Alhamdulillah',
    cnt3_key: 'Allahu Akbar',
    cnt4_key: 'La ilaha illallah',
    cnt5_key: 'Astaghfirullah',
    cnt6_key: 'Sallallahu Alaihi Wasallam'
  },
  '@drawer': {
    'account_management': 'Account Management',
    'sign_in': 'Sign In',
    'settings': 'Settings',
    'local_report': 'Personal Report',
    'global_report': 'Public Report',
    'store': 'Sabbe7 Store',
    'about_us': 'About Us'
  },
  '@auth_pages': {
    'email': 'Email',
    'password': 'Password',
    '@sign_in_page': {
      'title': 'Log In to an Account',
      'sign_in': 'Sign In',
      'sign_up_text': "Don't have an account?",
      'sign_up': 'Sign Up',
    },
    '@sign_up_page': {
      'title': 'Create an Account',
      'sign_up': 'Sign Up',
      'sign_in_text': 'Already registered?',
      'sign_in': 'Log In',
    },
    '@error_dialog': {
      'title': 'Error!',
      'content': "Can't sign in",
      'button': 'OK',
    }
  },
  '@settings_page': {
    'title': 'Settings',
    '@titles': {
      'general': "General",
      'notifications': 'Notifications',
    },
    '@tiles': {
      'vibration': 'Vibration',
      'sound': 'Sound',
      'language': 'Language',
      'add_counter': 'Add New Counter',
      'enable_notifications': 'Send Notifications',
      'count_number': 'Count of Dhikr per Session',
      'notification_delay': 'Reminder Timing',
    },
    '@drop_downs': {
      'minute': 'min',
      'hour': 'h',
    }
  },
  '@account_management_page': {
    'title': 'My Account',
    'email': 'Email',
    'password': 'Password',
    'sign_out': 'Sign Out',
    '@sign_out_dialog': {
      'title': 'Sign Out?',
      'content': 'Do you want to sign out?',
      '@buttons': {
        'cancel': 'Cancel',
        'sign_out': 'Sign Out',
      },
    },
  },
  '@reports': {
    'global_report': 'Public Report',
    '@local_report': {
      'local_report': 'Personal Report',
      '@counters': {
        cnt1_key: 'Subhanallah',
        cnt2_key: 'Alhamdulillah',
        cnt3_key: 'Allahu Akbar',
        // cnt4_key: 'La ilaha illallah',
        // cnt5_key: 'Astaghfirullah',
        // cnt6_key: 'S.A.W.'
      },
    },
  },
  '@notification': {
    'title': "It's time for tasbeeh!",
    'content': "Your reminder:",
    '@buttons': {
      'add': "Add",
      'dismiss': "Dismiss",
    }
  },
};



const String enStr = """
{
  "@lang_data": {
    "lang_short": "en",
    "lang_name": "English"
  },
  "@counters": {
    "counter_1": "Subhanallah",
    "counter_2": "Alhamdulillah",
    "counter_3": "Allahu Akbar",
    "counter_4": "La ilaha illallah",
    "counter_5": "Astaghfirullah",
    "counter_6": "Sallallahu Alaihi Wasallam"
  },
  "@drawer": {
    "account_management": "Account Management",
    "sign_in": "Sign In",
    "settings": "Settings",
    "local_report": "Personal Report",
    "global_report": "Public Report",
    "store": "Sabbe7 Store",
    "about_us": "About Us"
  },
  "@auth_pages": {
    "email": "Email",
    "password": "Password",
    "@sign_in_page": {
      "title": "Log In to an Account",
      "sign_in": "Sign In",
      "sign_up_text": "Don't have an account?",
      "sign_up": "Sign Up"
    },
    "@sign_up_page": {
      "title": "Create an Account",
      "sign_up": "Sign Up",
      "sign_in_text": "Already registered?",
      "sign_in": "Log In"
    },
    "@error_dialog": {
      "title": "Error!",
      "content": "Can't sign in",
      "button": "OK"
    }
  },
  "@settings_page": {
    "title": "Settings",
    "@tiles": {
      "vibration": "Vibration",
      "sound": "Sound",
      "language": "Language"
    }
  },
  "@account_management_page": {
    "title": "My Account",
    "email": "Email",
    "password": "Password",
    "sign_out": "Sign Out",
    "@sign_out_dialog": {
      "title": "Sign Out?",
      "content": "Do you want to sign out?",
      "@buttons": {
        "cancel": "Cancel",
        "sign_out": "Sign Out"
      }
    }
  },
  "@reports": {
    "global_report": "Public Report",
    "@local_report": {
      "local_report": "Personal Report",
      "@counters": {
        "counter_1": "Subhanallah",
        "counter_2": "Alhamdulillah",
        "counter_3": "Allahu Akbar",
        "counter_4": "La ilaha illallah",
        "counter_5": "Astaghfirullah",
        "counter_6": "S.A.W."
      }
    }
  }
}
""";