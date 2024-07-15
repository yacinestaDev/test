// Shared Pref
const IS_FIRST_TIME = 'IS_FIRST_TIME';
const IS_REMEMBER = 'IS_REMEMBER';
const USERID = "USERID";
const FIRSTNAME = "FIRSTNAME";
const LASTNAME = "LASTNAME";
const EMAIL = "EMAIL";
const PASSWORD = "PASSWORD";
const IS_LOGIN = "IS_LOGIN";
const USER_ID = "USER_ID";
const USER_PROFILE_IMG = "USER_PROFILE_IMG";
const TOKEN = "TOKEN";
const DISPLAY_NAME = "DISPLAY_NAME";
const PHONE_NUMBER = "PHONE_NUMBER";
const USERNAME = "USERNAME";
const GENDER = "GENDER";
const AGE = "AGE";
const HEIGHT = "HEIGHT";
const HEIGHT_UNIT = "HEIGHT_UNIT";
const WEIGHT = "WEIGHT";
const WEIGHT_UNIT = "WEIGHT_UNIT";
const IS_SOCIAL = "IS_SOCIAL";
const IS_OTP = "IS_OTP";
const IS_IN_APP_PURCHASED = "IS_IN_APP_PURCHASED";
const ONE_SINGLE = "ONE_SINGLE";
const PLAYER_ID = 'PLAYER_ID';
const IS_SUBSCRIBE = 'IS_SUBSCRIBE';
const SUBSCRIPTION_DETAIL = 'SUBSCRIPTION_DETAIL';
const NOTIFICATION_DETAIL = 'NOTIFICATION_DETAIL';
const PROGRESS_SETTINGS_DETAIL = 'PROGRESS_SETTINGS_DETAIL';

const SITE_NAME = "SITE_NAME";
const SITE_DESCRIPTION = "SITE_DESCRIPTION";
const SITE_COPYRIGHT = "SITE_COPYRIGHT";
const FACEBOOK_URL = "FACEBOOK_URL";
const INSTAGRAM_URL = "INSTAGRAM_URL";
const TWITTER_URL = "TWITTER_URL";
const LINKED_URL = "LINKED_URL";
const CONTACT_EMAIL = "CONTACT_EMAIL";
const CONTACT_NUMBER = "CONTACT_NUMBER";
const HELP_SUPPORT = "HELP_SUPPORT";
const TERMS_SERVICE = "TERMS_SERVICE";
const PRIVACY_POLICY = "PRIVACY_POLICY";
const IS_FREE_TRIAL_START = 'IS_FREE_TRIAL_START';
const COUNTRY_CODE = 'COUNTRY_CODE';

/* Theme Mode Type */
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

/* METRICS */
const METRICS_WEIGHT = 'weight';
const METRICS_WEIGHT_UNIT = 'kg';
const METRICS_HEART_RATE = 'heart-rate';
const PUSH_UP_MIN = 'push-up-min';
const METRICS_HEART_UNIT = 'bpm';
const PUSH_UP_MIN_UNIT = 'Reps';
const METRICS_CM = 'cm';

/* Live Stream */
const PROGRESS = 'PROGRESS';
const TIMER = 'TIMER';
const PROGRESS_SETTING = 'PROGRESS_SETTING';
const PAYMENT = 'PAYMENT';

const LBS = 'lbs';
const FEET = 'feet';
const DURATION = 'duration';
const SETS = 'sets';
const TIME = 'time';

const LoginTypeApp = 'app';
const LoginTypeGoogle = 'gmail';
const LoginTypeOTP = 'mobile';
const LoginUser = 'user';
const LoginTypeApple = 'apple';

const statusActive = 'active';

const MALE = 'male';
const FEMALE = 'female';

/* Video Type */
const VideoTypeCustom = 'custom_url';
const VideoTypeYouTube = 'youtube';
const VideoTypeIFrame = 'iframe';

const ACTIVE = "active";
const INACTIVE = "inactive";
const CANCELLED = "cancelled";
const EXPIRED = "expired ";

const TermsCondition = "termsCondition";
const CurrencySymbol = "currencySymbol";
const CurrencyCode = "currencyCode";
const CurrencyPosition = "currencyPosition";
const OneSignalAppID = "oneSignalAppID";
const OnesignalRestApiKey = "onesignalRestApiKey";
const AdmobBannerId = "admobBannerId";
const AdmobInterstitialId = "admobInterstitialId";
const AdmobBannerIdIos = "admobBannerIdIos";
const AdmobInterstitialIdIos = "admobInterstitialIdIos";
const ChatGptApiKey = "chatGptApiKey";
const PrivacyPolicy = "privacyPolicy";
const subscriptions = "subscription_system";

//Ads
const AdsBannerDetail_Show_Ads_On_Diet_Detail = "AdsBannerDetail_Show_Ads_On_Diet_Detail";
const AdsBannerDetail_Show_Banner_Ads_OnDiet = "AdsBannerDetail_Show_Banner_Ads_OnDiet";
const AdsBannerDetail_Show_Ads_On_Workout_Detail = "AdsBannerDetail_Show_Ads_On_Workout_Detail";
const AdsBannerDetail_Show_Banner_On_Workouts = "AdsBannerDetail_Show_Banner_On_Workouts";
const AdsBannerDetail_Show_Ads_On_Exercise_Detail = "AdsBannerDetail_Show_Ads_On_Exercise_Detail";
const AdsBannerDetail_Show_Banner_On_Equipment = "AdsBannerDetail_Show_Banner_On_Equipment";
const AdsBannerDetail_Show_Ads_On_Product_Detail = "AdsBannerDetail_Show_Ads_On_Product_Detail";
const AdsBannerDetail_Show_Banner_On_Product = "AdsBannerDetail_Show_Banner_On_Product";
const AdsBannerDetail_Show_Ads_On_Progress_Detail = "AdsBannerDetail_Show_Ads_On_Progress_Detail";
const AdsBannerDetail_Show_Banner_On_BodyPart = "AdsBannerDetail_Show_Banner_On_BodyPart";
const AdsBannerDetail_Show_Ads_On_Blog_Detail = "AdsBannerDetail_Show_Ads_On_Blog_Detail";
const AdsBannerDetail_Show_Banner_On_Level = "AdsBannerDetail_Show_Banner_On_Level";

const IdealWeight = "idealweight";

const PAYMENT_TYPE_STRIPE = 'stripe';
const PAYMENT_TYPE_RAZORPAY = 'razorpay';
const PAYMENT_TYPE_PAYSTACK = 'paystack';
const PAYMENT_TYPE_FLUTTERWAVE = 'flutterwave';
const PAYMENT_TYPE_PAYPAL = 'paypal';
const PAYMENT_TYPE_PAYTABS = 'paytabs';
const PAYMENT_TYPE_PAYTM = 'paytm';
const PAYMENT_TYPE_MYFATOORAH = 'myfatoorah';
const PAYMENT_TYPE_ORANGE_MONEY = 'orangeMoney';

const FONT_SIZE_PREF = 'FONT_SIZE_PREF';
const IS_PLAYING = "IS_PLAYING";

const stripeURL = 'https://api.stripe.com/v1/payment_intents';
class DefaultValues {
  final String defaultLanguage = 'en';
}

DefaultValues defaultValues = DefaultValues();
