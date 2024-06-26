import '../constants.dart';

const Map<String, dynamic> tr = {
  '@lang_data': {
    'lang_short': 'tr',
    'lang_name': 'Türkçe'
  },
  '@counters': {
    cnt1_key: 'Sübhanallah',
    cnt2_key: 'Elhamdülillah',
    cnt3_key: 'Allahu Ekber',
    cnt4_key: 'La İlahe İllallah',
    cnt5_key: 'Estağfirullah',
    cnt6_key: 'Sallallahu Aleyhi ve Sellem'
  },
  '@drawer': {
    'account_management': 'Hesap Yönetimi',
    'sign_in': 'Giriş Yap',
    'settings': 'Ayarlar',
    'local_report': 'Şahıs Rapor',
    'global_report': 'Genel Rapor',
    'store': 'Sabbe7 Mağaza',
    'about_us': 'Hakkimizda'
  },
  '@auth_pages': {
    'email': 'E-Posta',
    'password': 'Şifre',
    '@sign_in_page': {
      'title': 'Hesaba Giriş Yap',
      'sign_in': 'Giriş Yap',
      'sign_up_text': "Hesabınız yok mu?",
      'sign_up': 'Hesap Oluştur',
    },
    '@sign_up_page': {
      'title': 'Hesap Oluştur',
      'sign_up': 'Kayıt Ol',
      'sign_in_text': 'Hesabın zaten var mı?',
      'sign_in': 'Giriş Yap',
    },
    '@error_dialog': {
      'title': 'Hata!',
      'content': "Bir hata oluştu.",
      'button': 'Tamam',
    },
  },
  '@settings_page': {
      'title': 'Ayarlar',
    '@titles': {
      'general': "Genel",
      'notifications': 'Bildirimler',
    },
    '@tiles': {
      'vibration': 'Titreşim',
      'sound': 'Ses',
      'language': 'Dil',
      'add_counter': 'Yeni Sayıcı Ekle',
      'enable_notifications': 'Bildirim Gönder',
      'count_number': 'Oturumdaki Zikir Sayısı',
      'notification_delay': 'Hatırlatıcı Zamanlaması',
    },
    '@drop_downs': {
      'minute': 'dk',
      'hour': 's',
    }
  },
  '@account_management_page': {
    'title': 'Hesabım',
    'email': 'E-Posta',
    'password': 'Şifre',
    'sign_out': 'Çıkış Yap',
    '@sign_out_dialog': {
      'title': 'Çıkış Yap?',
      'content': 'Oturumu kapatmak istiyor musunuz?',
      '@buttons': {
        'cancel': 'Kapat',
        'sign_out': 'Çıkış Yap',
      },
    },
  },
  '@reports': {
    'global_report': 'Genel Rapor',
    '@local_report': {
      'local_report': 'Şahıs Rapor',
      '@counters': {
        cnt1_key: 'Sübhanallah',
        cnt2_key: 'Elhamdülillah',
        cnt3_key: 'Allahu Ekber',
        // cnt4_key: 'La İlahe İllallah',
        // cnt5_key: 'Estağfirullah',
        // cnt6_key: 'S.A.V.'
      },
    },
  },
  '@notification': {
    'title': "Tesbih vakti geldi!",
    'content': "Hatırlatmanız:",
    '@buttons': {
      'add': "Ekle",
      'dismiss': "İptal",
    }
  },
};



const String trStr = """
{
  "@lang_data": {
    "lang_short": "tr",
    "lang_name": "Türkçe"
  },
  "@counters": {
    "counter_1": "Sübhanallah",
    "counter_2": "Elhamdülillah",
    "counter_3": "Allahu Ekber",
    "counter_4": "La İlahe İllallah",
    "counter_5": "Estağfirullah",
    "counter_6": "Sallallahu Aleyhi ve Sellem"
  },
  "@drawer": {
    "account_management": "Hesap Yönetimi",
    "sign_in": "Giriş Yap",
    "settings": "Ayarlar",
    "local_report": "Şahıs Rapor",
    "global_report": "Genel Rapor",
    "store": "Sabbe7 Mağaza",
    "about_us": "Hakkimizda"
  },
  "@auth_pages": {
    "email": "E-Posta",
    "password": "Şifre",
    "@sign_in_page": {
      "title": "Hesaba Giriş Yap",
      "sign_in": "Giriş Yap",
      "sign_up_text": "Hesabınız yok mu?",
      "sign_up": "Hesap Oluştur"
    },
    "@sign_up_page": {
      "title": "Hesap Oluştur",
      "sign_up": "Kayıt Ol",
      "sign_in_text": "Hesabın zaten var mı?",
      "sign_in": "Giriş Yap"
    },
    "@error_dialog": {
      "title": "Hata!",
      "content": "Bir hata oluştu.",
      "button": "Tamam"
    }
  },
  "@settings_page": {
    "title": "Ayarlar",
    "@tiles": {
      "vibration": "Titreşim",
      "sound": "Ses",
      "language": "Dil"
    }
  },
  "@account_management_page": {
    "title": "Hesabım",
    "email": "E-Posta",
    "password": "Şifre",
    "sign_out": "Çıkış Yap",
    "@sign_out_dialog": {
      "title": "Çıkış Yap?",
      "content": "Oturumu kapatmak istiyor musunuz?",
      "@buttons": {
        "cancel": "Kapat",
        "sign_out": "Çıkış Yap"
      }
    }
  },
  "@reports": {
    "global_report": "Genel Rapor",
    "@local_report": {
      "local_report": "Şahıs Rapor",
      "@counters": {
        "counter_1": "Sübhanallah",
        "counter_2": "Elhamdülillah",
        "counter_3": "Allahu Ekber",
        "counter_4": "La İlahe İllallah",
        "counter_5": "Estağfirullah",
        "counter_6": "S.A.V."
      }
    }
  }
}
""";