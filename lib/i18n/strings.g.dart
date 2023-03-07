 

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;
 
enum AppLocale {
	en// 'en' (base locale, fallback)
	/* es, // 'es'
	fr, // 'fr'
	pt,  */// 'pt'
}
 
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;
 
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale useDeviceLocale() {
		final locale = AppLocaleUtils.findDeviceLocale();
		return setLocale(locale);
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

			_translationProviderKey.currentState?.setLocale(_currLocale);

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String rawLocale) {
		final locale = AppLocaleUtils.parse(rawLocale);
		return setLocale(locale);
	}

	/// Gets current locale.
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}
}

/// Provides utility functions without any side effects.
class AppLocaleUtils {
	AppLocaleUtils._(); // no constructor

	/// Returns the locale of the device as the enum type.
	/// Fallbacks to base locale.
	static AppLocale findDeviceLocale() {
		final String? deviceLocale = WidgetsBinding.instance.window.locale.toLanguageTag();
		if (deviceLocale != null) {
			final typedLocale = _selectLocale(deviceLocale);
			if (typedLocale != null) {
				return typedLocale;
			}
		}
		return _baseLocale;
	}

	/// Returns the enum type of the raw locale.
	/// Fallbacks to base locale.
	static AppLocale parse(String rawLocale) {
		return _selectLocale(rawLocale) ?? _baseLocale;
	}
}

// context enums

// interfaces generated as mixins

// translation instances

late _StringsEn _translationsEn = _StringsEn.build();
/* late _StringsEs _translationsEs = _StringsEs.build();
late _StringsFr _translationsFr = _StringsFr.build();
late _StringsPt _translationsPt = _StringsPt.build(); */

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {

	/// Gets the translation instance managed by this library.
	/// [TranslationProvider] is using this instance.
	/// The plural resolvers are set via [LocaleSettings].
	_StringsEn get translations {
		switch (this) {
			case AppLocale.en: return _translationsEn;
			/* case AppLocale.es: return _translationsEs;
			case AppLocale.fr: return _translationsFr;
			case AppLocale.pt: return _translationsPt; */
		}
	}

	/// Gets a new translation instance.
	/// [LocaleSettings] has no effect here.
	/// Suitable for dependency injection and unit tests.
	///
	/// Usage:
	/// final t = AppLocale.en.build(); // build
	/// String a = t.my.path; // access
	_StringsEn build() {
		switch (this) {
			case AppLocale.en: return _StringsEn.build();
	 
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
			/* case AppLocale.es: return 'es';
			case AppLocale.fr: return 'fr';
			case AppLocale.pt: return 'pt'; */
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return const Locale.fromSubtags(languageCode: 'en');
 
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
	/* 		case 'es': return AppLocale.es;
			case 'fr': return AppLocale.fr;
			case 'pt': return AppLocale.pt; */
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();

	static _InheritedLocaleData of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget;
	}
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	Locale get flutterLocale => locale.flutterLocale; // shortcut
	final _StringsEn translations; // store translations to avoid switch call

	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization feature not used

// helpers

final _localeRegex = RegExp(r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);
		final country = match.group(5);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}

		if (selected == null && country != null) {
			// match country
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.contains(country) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

// Path: <root>
class _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build();

	/// Access flat map
	dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	late final Map<String, dynamic> _flatMap = _buildFlatMap();

	// ignore: unused_field
	late final _StringsEn _root = this;

	// Translations
	String get appname => 'MyChurch App';
	String get selectlanguage => 'Select Language';
	String get chooseapplanguage => 'Choose App Language';
	String get nightmode => 'Night Mode';
	String get initializingapp => 'initializing...';
	String get home => 'Home';
	String get branches => 'Branches';
	String get inbox => 'Inbox';
	String get downloads => 'Downloads';
	String get settings => 'Settings';
	String get events => 'Events';
	String get myplaylists => 'My Playlists';
	String get website => 'Website';
	String get hymns => 'Hymns';
  String get giving => 'Giving';
  String get streaming => 'Streaming';
	String get articles => 'Articles';
	String get notes => 'Notes';
	String get donate => 'Donate';
	String get savenotetitle => 'Note Title';
	String get nonotesfound => 'No notes found';
	String get newnote => 'New';
	String get deletenote => 'Delete Note';
	String get deletenotehint => 'Do you want to delete this note? This action cannot be reversed.';
	String get bookmarks => 'Bookmarks';
	String get socialplatforms => 'Social Platforms';
	List<String> get onboardingpagetitles => [
		'Welcome to MyChurch',
		'Packed with Features',
		'Audio, Video \n and Live Streaming',
		'Create Account',
	];
	List<String> get onboardingpagehints => [
		'Extend beyond the Sunday mornings &amp; the four walls of your church. Everything you need to communicate and engage with a mobile-focused world.',
		'We have brought together all of the top features that your church app must have. Events, Devotionals, Notifications, Notes and multi-version bible.',
		'Allow users across the globe watch videos, listen to audio messages and watch live streams of your church services.',
		'Start your journey to a never-ending worship experience.',
	];
	String get next => 'NEXT';
	String get done => 'Get Started';
	String get quitapp => 'Quit App!';
	String get quitappwarning => 'Do you wish to close the app?';
	String get quitappaudiowarning => 'You are currently playing an audio, quitting the app will stop the audio playback. If you do not wish to stop playback, just minimize the app with the center button or click the Ok button to quit app now.';
	String get ok => 'Ok';
	String get retry => 'RETRY';
	String get oops => 'Ooops!';
	String get save => 'Save';
	String get cancel => 'Cancel';
	String get error => 'Error';
	String get success => 'Success';
	String get skip => 'Skip';
	String get skiplogin => 'Skip Login';
	String get skipregister => 'Skip Registration';
	String get dataloaderror => 'Could not load requested data at the moment, check your data connection and click to retry.';
	String get suggestedVideosforyou => 'Latest videos messages';
  String get suggestedAudioforyou => 'Resent audio messages';
  String get suggestedCategoryforyou => 'Discover by category';
  String get suggestedforyou => 'Suggested for you';
	String get videomessages => 'Video Messages';
	String get audiomessages => 'Audio Messages';
	String get devotionals => 'Sermons';
	String get categories => 'Categories';
	String get category => 'Category';
	String get videos => 'Videos';
	String get audios => 'Audios';
	String get biblebooks => 'Bible';
	String get audiobible => 'Audio Bible';
	String get livestreams => 'Livestreams';
	String get radio => 'Radio';
	String get allitems => 'All Items';
  String get viewAll => 'View All';
	String get emptyplaylist => 'No Playlists';
	String get notsupported => 'Not Supported';
	String get cleanupresources => 'Cleaning up resources';
	String get grantstoragepermission => 'Please grant accessing storage permission to continue';
	String get sharefiletitle => 'Watch or Listen to ';
	String get sharefilebody => 'Via MyChurch App, Download now at ';
	String get sharetext => 'Enjoy unlimited Audio & Video streaming';
	String get sharetexthint => 'Join the Video and Audio streaming platform that lets you watch and listen to millions of files from around the world. Download now at';
	String get download => 'Download';
	String get addplaylist => 'Add to playlist';
	String get bookmark => 'Bookmark';
	String get unbookmark => 'UnBookmark';
	String get share => 'Share';
	String get deletemedia => 'Delete File';
	String get deletemediahint => 'Do you wish to delete this downloaded file? This action cannot be undone.';
	String get searchhint => 'Search Audio & Video Messages';
	String get performingsearch => 'Searching Audios and Videos';
	String get nosearchresult => 'No results Found';
	String get nosearchresulthint => 'Try input more general keyword';
	String get addtoplaylist => 'Add to playlist';
	String get newplaylist => 'New playlist';
	String get playlistitm => 'Playlist';
	String get mediaaddedtoplaylist => 'Media added to playlist.';
	String get mediaremovedfromplaylist => 'Media removed from playlist';
	String get clearplaylistmedias => 'Clear All Media';
	String get deletePlayList => 'Delete Playlist';
	String get clearplaylistmediashint => 'Go ahead and remove all media from this playlist?';
	String get deletePlayListhint => 'Go ahead and delete this playlist and clear all media?';
	String get comments => 'Comments';
	String get replies => 'Replies';
	String get reply => 'Reply';
	String get logintoaddcomment => 'Login to add a comment';
	String get logintoreply => 'Login to reply';
	String get writeamessage => 'Write a message...';
	String get nocomments => 'No Comments found \nclick to retry';
	String get errormakingcomments => 'Cannot process commenting at the moment..';
	String get errordeletingcomments => 'Cannot delete this comment at the moment..';
	String get erroreditingcomments => 'Cannot edit this comment at the moment..';
	String get errorloadingmorecomments => 'Cannot load more comments at the moment..';
	String get deletingcomment => 'Deleting comment';
	String get editingcomment => 'Editing comment';
	String get deletecommentalert => 'Delete Comment';
	String get editcommentalert => 'Edit Comment';
	String get deletecommentalerttext => 'Do you wish to delete this comment? This action cannot be undone';
	String get loadmore => 'load more';
	String get messages => 'Messages';
	String get guestuser => 'Guest User';
	String get fullname => 'Full Name';
	String get emailaddress => 'Email Address';
	String get password => 'Password';
	String get repeatpassword => 'Repeat Password';
	String get register => 'Register';
	String get login => 'Login';
	String get logout => 'Logout';
	String get logoutfromapp => 'Logout from app?';
	String get logoutfromapphint => 'You wont be able to like or comment on articles and videos if you are not logged in.';
	String get gotologin => 'Go to Login';
	String get resetpassword => 'Reset Password';
	String get logintoaccount => 'Already have an account? Login';
	String get emptyfielderrorhint => 'You need to fill all the fields';
	String get invalidemailerrorhint => 'You need to enter a valid email address';
	String get passwordsdontmatch => 'Passwords dont match';
	String get processingpleasewait => 'Processing, Please wait...';
	String get createaccount => 'Create an account';
	String get forgotpassword => 'Forgot Password?';
	String get orloginwith => 'Or Login With';
	String get facebook => 'Facebook';
	String get google => 'Google';
	String get moreoptions => 'More Options';
	String get about => 'About Us';
	String get privacy => 'Privacy Policy';
	String get terms => 'App Terms';
	String get rate => 'Rate App';
	String get version => 'Version';
	String get pulluploadmore => 'pull up load';
	String get loadfailedretry => 'Load Failed!Click retry!';
	String get releaseloadmore => 'release to load more';
	String get nomoredata => 'No more Data';
	String get errorReportingComment => 'Error Reporting Comment';
	String get reportingComment => 'Reporting Comment';
	String get reportcomment => 'Report Options';
	List<String> get reportCommentsList => [
		'Unwanted commercial content or spam',
		'Pornography or sexual explicit material',
		'Hate speech or graphic violence',
		'Harassment or bullying',
	];
	String get bookmarksMedia => 'My Bookmarks';
	String get noitemstodisplay => 'No Items To Display';
	String get loginrequired => 'Login Required';
	String get loginrequiredhint => 'To subscribe on this platform, you need to be logged in. Create a free account now or log in to your existing account.';
	String get subscriptions => 'App Subscriptions';
	String get subscribe => 'SUBSCRIBE';
	String get subscribehint => 'Subscription Required';
	String get playsubscriptionrequiredhint => 'You need to subscribe before you can listen to or watch this media.';
	String get previewsubscriptionrequiredhint => 'You have reached the allowed preview duration for this media. You need to subscribe to continue listening or watching this media.';
	String get copiedtoclipboard => 'Copied to clipboard';
	String get downloadbible => 'Download Bible';
	String get downloadversion => 'Download';
	String get downloading => 'Downloading';
	String get failedtodownload => 'Failed to download';
	String get pleaseclicktoretry => 'Please click to retry.';
	String get of => 'Of';
	String get nobibleversionshint => 'There is no bible data to display, click on the button below to download atleast one bible version.';
	String get downloaded => 'Downloaded';
	String get enteremailaddresstoresetpassword => 'Enter your email to reset your password';
	String get backtologin => 'BACK TO LOGIN';
	String get signintocontinue => 'Sign in to continue';
	String get signin => 'S I G N  I N';
	String get signinforanaccount => 'SIGN UP FOR AN ACCOUNT?';
	String get alreadyhaveanaccount => 'Already have an account?';
	String get updateprofile => 'Update Profile';
	String get updateprofilehint => 'To get started, please update your profile page, this will help us in connecting you with other people';
	String get autoplayvideos => 'AutoPlay Videos';
	String get gosocial => 'Go Social';
	String get searchbible => 'Search Bible';
	String get filtersearchoptions => 'Filter Search Options';
	String get narrowdownsearch => 'Use the filter button below to narrow down search for a more precise result.';
	String get searchbibleversion => 'Search Bible Version';
	String get searchbiblebook => 'Search Bible Book';
	String get search => 'Search';
	String get setBibleBook => 'Set Bible Book';
	String get oldtestament => 'Old Testament';
	String get newtestament => 'New Testament';
	String get limitresults => 'Limit Results';
	String get setfilters => 'Set Filters';
	String get bibletranslator => 'Bible Translator';
	String get chapter => ' Chapter ';
	String get verse => ' Verse ';
	String get translate => 'translate';
	String get bibledownloadinfo => 'Bible Download started, Please do not close this page until the download is done.';
	String get received => 'received';
	String get outoftotal => 'out of total';
	String get set => 'SET';
	String get selectColor => 'Select Color';
	String get switchbibleversion => 'Switch Bible Version';
	String get switchbiblebook => 'Switch Bible Book';
	String get gotosearch => 'Go to Chapter';
	String get changefontsize => 'Change Font Size';
	String get font => 'Font';
	String get readchapter => 'Read Chapter';
	String get showhighlightedverse => 'Show Highlighted Verses';
	String get downloadmoreversions => 'Download more versions';
	String get suggestedusers => 'Suggested users to follow';
	String get unfollow => 'UnFollow';
	String get follow => 'Follow';
	String get searchforpeople => 'Search for people';
	String get viewpost => 'View Post';
	String get viewprofile => 'View Profile';
	String get mypins => 'My Pins';
	String get viewpinnedposts => 'View Pinned Posts';
	String get personal => 'Personal';
	String get update => 'Update';
	String get phonenumber => 'Phone Number';
	String get showmyphonenumber => 'Show my phone number to users';
	String get dateofbirth => 'Date of Birth';
	String get showmyfulldateofbirth => 'Show my full date of birth to people viewing my status';
	String get notifications => 'Notifications';
	String get notifywhenuserfollowsme => 'Notify me when a user follows me';
	String get notifymewhenusercommentsonmypost => 'Notify me when users comment on my post';
	String get notifymewhenuserlikesmypost => 'Notify me when users like my post';
	String get churchsocial => 'Church Social';
	String get shareyourthoughts => 'Share your thoughts';
	String get readmore => '...Read more';
	String get less => ' Less';
	String get couldnotprocess => 'Could not process requested action.';
	String get pleaseselectprofilephoto => 'Please select a profile photo to upload';
	String get pleaseselectprofilecover => 'Please select a cover photo to upload';
	String get updateprofileerrorhint => 'You need to fill your name, date of birth, gender, phone and location before you can proceed.';
	String get gender => 'Gender';
	String get male => 'Male';
	String get female => 'Female';
	String get dob => 'Date Of Birth';
	String get location => 'Current Location';
	String get qualification => 'Qualification';
	String get aboutme => 'About Me';
	String get facebookprofilelink => 'Facebook Profile Link';
	String get twitterprofilelink => 'Twitter Profile Link';
	String get linkdln => 'Linkedln Profile Link';
	String get likes => 'Likes';
	String get likess => 'Like(s)';
	String get pinnedposts => 'My Pinned Posts';
	String get unpinpost => 'Unpin Post';
	String get unpinposthint => 'Do you wish to remove this post from your pinned posts?';
	String get postdetails => 'Post Details';
	String get posts => 'Posts';
	String get followers => 'Followers';
	String get followings => 'Followings';
	String get my => 'My';
	String get edit => 'Edit';
	String get delete => 'Delete';
	String get deletepost => 'Delete Post';
	String get deleteposthint => 'Do you wish to delete this post? Posts can still appear on some users feeds.';
	String get maximumallowedsizehint => 'Maximum allowed file upload reached';
	String get maximumuploadsizehint => 'The selected file exceeds the allowed upload file size limit.';
	String get makeposterror => 'Unable to make post at the moment, please click to retry.';
	String get makepost => 'Make Post';
	String get selectfile => 'Select File';
	String get images => 'Images';
	String get shareYourThoughtsNow => 'Share your thoughts ...';
	String get photoviewer => 'Photo Viewer';
	String get nochatsavailable => 'No Conversations available \n Click the add icon below \nto select users to chat with';
	String get typing => 'Typing...';
	String get photo => 'Photo';
	String get online => 'Online';
	String get offline => 'Offline';
	String get lastseen => 'Last Seen';
	String get deleteselectedhint => 'This action will delete the selected messages.  Please note that this only deletes your side of the conversation, \n the messages will still show on your partners device.';
	String get deleteselected => 'Delete selected';
	String get unabletofetchconversation => 'Unable to Fetch \nyour conversation with \n';
	String get loadmoreconversation => 'Load more conversations';
	String get sendyourfirstmessage => 'Send your first message to \n';
	String get unblock => 'Unblock ';
	String get block => 'Block';
	String get writeyourmessage => 'Write your message...';
	String get clearconversation => 'Clear Conversation';
	String get clearconversationhintone => 'This action will clear all your conversation with ';
	String get clearconversationhinttwo => '.\n  Please note that this only deletes your side of the conversation, the messages will still show on your partners chat.';
	String get facebookloginerror => 'Something went wrong with the login process.\n, Here is the error Facebook gave us';
}
 
extension on _StringsEn {
	Map<String, dynamic> _buildFlatMap() {
		return {
			'appname': 'MyChurch App',
			'selectlanguage': 'Select Language',
			'chooseapplanguage': 'Choose App Language',
			'nightmode': 'Night Mode',
			'initializingapp': 'initializing...',
			'home': 'Home',
			'branches': 'Branches',
			'inbox': 'Inbox',
			'downloads': 'Downloads',
			'settings': 'Settings',
			'events': 'Events',
			'myplaylists': 'My Playlists',
			'website': 'Website',
			'hymns': 'Hymns',
      'giving': 'Giving',
      'streaming':'Streaming',
			'articles': 'Articles',
			'notes': 'Notes',
			'donate': 'Donate',
			'savenotetitle': 'Note Title',
			'nonotesfound': 'No notes found',
			'newnote': 'New',
			'deletenote': 'Delete Note',
			'deletenotehint': 'Do you want to delete this note? This action cannot be reversed.',
			'bookmarks': 'Bookmarks',
			'socialplatforms': 'Social Platforms',
			'onboardingpagetitles.0': 'Welcome to MyChurch',
			'onboardingpagetitles.1': 'Packed with Features',
			'onboardingpagetitles.2': 'Audio, Video \n and Live Streaming',
			'onboardingpagetitles.3': 'Create Account',
			'onboardingpagehints.0': 'Extend beyond the Sunday mornings &amp; the four walls of your church. Everything you need to communicate and engage with a mobile-focused world.',
			'onboardingpagehints.1': 'We have brought together all of the top features that your church app must have. Events, Devotionals, Notifications, Notes and multi-version bible.',
			'onboardingpagehints.2': 'Allow users across the globe watch videos, listen to audio messages and watch live streams of your church services.',
			'onboardingpagehints.3': 'Start your journey to a never-ending worship experience.',
			'next': 'NEXT',
			'done': 'Get Started',
			'quitapp': 'Quit App!',
			'quitappwarning': 'Do you wish to close the app?',
			'quitappaudiowarning': 'You are currently playing an audio, quitting the app will stop the audio playback. If you do not wish to stop playback, just minimize the app with the center button or click the Ok button to quit app now.',
			'ok': 'Ok',
			'retry': 'RETRY',
			'oops': 'Ooops!',
			'save': 'Save',
			'cancel': 'Cancel',
			'error': 'Error',
			'success': 'Success',
			'skip': 'Skip',
			'skiplogin': 'Skip Login',
			'skipregister': 'Skip Registration',
			'dataloaderror': 'Could not load requested data at the moment, check your data connection and click to retry.',
			'suggestedVideosforyou': 'Latest videos messages',
      'suggestedAudioforyou': 'Resent audio messages',
			'suggestedCategoryforyou': 'Discover by category',
			'suggestedforyou': 'Suggested for you', 
			'videomessages': 'Video Messages',
			'audiomessages': 'Audio Messages',
			'devotionals': 'Sermons',
			'categories': 'Categories',
			'category': 'Category',
			'videos': 'Videos',
			'audios': 'Audios',
			'biblebooks': 'Bible',
			'audiobible': 'Audio Bible',
			'livestreams': 'Livestreams',
			'radio': 'Radio',
			'allitems': 'All Items',
			'emptyplaylist': 'No Playlists',
			'notsupported': 'Not Supported',
			'cleanupresources': 'Cleaning up resources',
			'grantstoragepermission': 'Please grant accessing storage permission to continue',
			'sharefiletitle': 'Watch or Listen to ',
			'sharefilebody': 'Via MyChurch App, Download now at ',
			'sharetext': 'Enjoy unlimited Audio & Video streaming',
			'sharetexthint': 'Join the Video and Audio streaming platform that lets you watch and listen to millions of files from around the world. Download now at',
			'download': 'Download',
			'addplaylist': 'Add to playlist',
			'bookmark': 'Bookmark',
			'unbookmark': 'UnBookmark',
			'share': 'Share',
			'deletemedia': 'Delete File',
			'deletemediahint': 'Do you wish to delete this downloaded file? This action cannot be undone.',
			'searchhint': 'Search Audio & Video Messages',
			'performingsearch': 'Searching Audios and Videos',
			'nosearchresult': 'No results Found',
			'nosearchresulthint': 'Try input more general keyword',
			'addtoplaylist': 'Add to playlist',
			'newplaylist': 'New playlist',
			'playlistitm': 'Playlist',
			'mediaaddedtoplaylist': 'Media added to playlist.',
			'mediaremovedfromplaylist': 'Media removed from playlist',
			'clearplaylistmedias': 'Clear All Media',
			'deletePlayList': 'Delete Playlist',
			'clearplaylistmediashint': 'Go ahead and remove all media from this playlist?',
			'deletePlayListhint': 'Go ahead and delete this playlist and clear all media?',
			'comments': 'Comments',
			'replies': 'Replies',
			'reply': 'Reply',
			'logintoaddcomment': 'Login to add a comment',
			'logintoreply': 'Login to reply',
			'writeamessage': 'Write a message...',
			'nocomments': 'No Comments found \nclick to retry',
			'errormakingcomments': 'Cannot process commenting at the moment..',
			'errordeletingcomments': 'Cannot delete this comment at the moment..',
			'erroreditingcomments': 'Cannot edit this comment at the moment..',
			'errorloadingmorecomments': 'Cannot load more comments at the moment..',
			'deletingcomment': 'Deleting comment',
			'editingcomment': 'Editing comment',
			'deletecommentalert': 'Delete Comment',
			'editcommentalert': 'Edit Comment',
			'deletecommentalerttext': 'Do you wish to delete this comment? This action cannot be undone',
			'loadmore': 'load more',
			'messages': 'Messages',
			'guestuser': 'Guest User',
			'fullname': 'Full Name',
			'emailaddress': 'Email Address',
			'password': 'Password',
			'repeatpassword': 'Repeat Password',
			'register': 'Register',
			'login': 'Login',
			'logout': 'Logout',
			'logoutfromapp': 'Logout from app?',
			'logoutfromapphint': 'You wont be able to like or comment on articles and videos if you are not logged in.',
			'gotologin': 'Go to Login',
			'resetpassword': 'Reset Password',
			'logintoaccount': 'Already have an account? Login',
			'emptyfielderrorhint': 'You need to fill all the fields',
			'invalidemailerrorhint': 'You need to enter a valid email address',
			'passwordsdontmatch': 'Passwords dont match',
			'processingpleasewait': 'Processing, Please wait...',
			'createaccount': 'Create an account',
			'forgotpassword': 'Forgot Password?',
			'orloginwith': 'Or Login With',
			'facebook': 'Facebook',
			'google': 'Google',
			'moreoptions': 'More Options',
			'about': 'About Us',
			'privacy': 'Privacy Policy',
			'terms': 'App Terms',
			'rate': 'Rate App',
			'version': 'Version',
			'pulluploadmore': 'pull up load',
			'loadfailedretry': 'Load Failed!Click retry!',
			'releaseloadmore': 'release to load more',
			'nomoredata': 'No more Data',
			'errorReportingComment': 'Error Reporting Comment',
			'reportingComment': 'Reporting Comment',
			'reportcomment': 'Report Options',
			'reportCommentsList.0': 'Unwanted commercial content or spam',
			'reportCommentsList.1': 'Pornography or sexual explicit material',
			'reportCommentsList.2': 'Hate speech or graphic violence',
			'reportCommentsList.3': 'Harassment or bullying',
			'bookmarksMedia': 'My Bookmarks',
			'noitemstodisplay': 'No Items To Display',
			'loginrequired': 'Login Required',
			'loginrequiredhint': 'To subscribe on this platform, you need to be logged in. Create a free account now or log in to your existing account.',
			'subscriptions': 'App Subscriptions',
			'subscribe': 'SUBSCRIBE',
			'subscribehint': 'Subscription Required',
			'playsubscriptionrequiredhint': 'You need to subscribe before you can listen to or watch this media.',
			'previewsubscriptionrequiredhint': 'You have reached the allowed preview duration for this media. You need to subscribe to continue listening or watching this media.',
			'copiedtoclipboard': 'Copied to clipboard',
			'downloadbible': 'Download Bible',
			'downloadversion': 'Download',
			'downloading': 'Downloading',
			'failedtodownload': 'Failed to download',
			'pleaseclicktoretry': 'Please click to retry.',
			'of': 'Of',
			'nobibleversionshint': 'There is no bible data to display, click on the button below to download atleast one bible version.',
			'downloaded': 'Downloaded',
			'enteremailaddresstoresetpassword': 'Enter your email to reset your password',
			'backtologin': 'BACK TO LOGIN',
			'signintocontinue': 'Sign in to continue',
			'signin': 'S I G N  I N',
			'signinforanaccount': 'SIGN UP FOR AN ACCOUNT?',
			'alreadyhaveanaccount': 'Already have an account?',
			'updateprofile': 'Update Profile',
			'updateprofilehint': 'To get started, please update your profile page, this will help us in connecting you with other people',
			'autoplayvideos': 'AutoPlay Videos',
			'gosocial': 'Go Social',
			'searchbible': 'Search Bible',
			'filtersearchoptions': 'Filter Search Options',
			'narrowdownsearch': 'Use the filter button below to narrow down search for a more precise result.',
			'searchbibleversion': 'Search Bible Version',
			'searchbiblebook': 'Search Bible Book',
			'search': 'Search',
			'setBibleBook': 'Set Bible Book',
			'oldtestament': 'Old Testament',
			'newtestament': 'New Testament',
			'limitresults': 'Limit Results',
			'setfilters': 'Set Filters',
			'bibletranslator': 'Bible Translator',
			'chapter': ' Chapter ',
			'verse': ' Verse ',
			'translate': 'translate',
			'bibledownloadinfo': 'Bible Download started, Please do not close this page until the download is done.',
			'received': 'received',
			'outoftotal': 'out of total',
			'set': 'SET',
			'selectColor': 'Select Color',
			'switchbibleversion': 'Switch Bible Version',
			'switchbiblebook': 'Switch Bible Book',
			'gotosearch': 'Go to Chapter',
			'changefontsize': 'Change Font Size',
			'font': 'Font',
			'readchapter': 'Read Chapter',
			'showhighlightedverse': 'Show Highlighted Verses',
			'downloadmoreversions': 'Download more versions',
			'suggestedusers': 'Suggested users to follow',
			'unfollow': 'UnFollow',
			'follow': 'Follow',
			'searchforpeople': 'Search for people',
			'viewpost': 'View Post',
			'viewprofile': 'View Profile',
			'mypins': 'My Pins',
			'viewpinnedposts': 'View Pinned Posts',
			'personal': 'Personal',
			'update': 'Update',
			'phonenumber': 'Phone Number',
			'showmyphonenumber': 'Show my phone number to users',
			'dateofbirth': 'Date of Birth',
			'showmyfulldateofbirth': 'Show my full date of birth to people viewing my status',
			'notifications': 'Notifications',
			'notifywhenuserfollowsme': 'Notify me when a user follows me',
			'notifymewhenusercommentsonmypost': 'Notify me when users comment on my post',
			'notifymewhenuserlikesmypost': 'Notify me when users like my post',
			'churchsocial': 'Church Social',
			'shareyourthoughts': 'Share your thoughts',
			'readmore': '...Read more',
			'less': ' Less',
			'couldnotprocess': 'Could not process requested action.',
			'pleaseselectprofilephoto': 'Please select a profile photo to upload',
			'pleaseselectprofilecover': 'Please select a cover photo to upload',
			'updateprofileerrorhint': 'You need to fill your name, date of birth, gender, phone and location before you can proceed.',
			'gender': 'Gender',
			'male': 'Male',
			'female': 'Female',
			'dob': 'Date Of Birth',
			'location': 'Current Location',
			'qualification': 'Qualification',
			'aboutme': 'About Me',
			'facebookprofilelink': 'Facebook Profile Link',
			'twitterprofilelink': 'Twitter Profile Link',
			'linkdln': 'Linkedln Profile Link',
			'likes': 'Likes',
			'likess': 'Like(s)',
			'pinnedposts': 'My Pinned Posts',
			'unpinpost': 'Unpin Post',
			'unpinposthint': 'Do you wish to remove this post from your pinned posts?',
			'postdetails': 'Post Details',
			'posts': 'Posts',
			'followers': 'Followers',
			'followings': 'Followings',
			'my': 'My',
			'edit': 'Edit',
			'delete': 'Delete',
			'deletepost': 'Delete Post',
			'deleteposthint': 'Do you wish to delete this post? Posts can still appear on some users feeds.',
			'maximumallowedsizehint': 'Maximum allowed file upload reached',
			'maximumuploadsizehint': 'The selected file exceeds the allowed upload file size limit.',
			'makeposterror': 'Unable to make post at the moment, please click to retry.',
			'makepost': 'Make Post',
			'selectfile': 'Select File',
			'images': 'Images',
			'shareYourThoughtsNow': 'Share your thoughts ...',
			'photoviewer': 'Photo Viewer',
			'nochatsavailable': 'No Conversations available \n Click the add icon below \nto select users to chat with',
			'typing': 'Typing...',
			'photo': 'Photo',
			'online': 'Online',
			'offline': 'Offline',
			'lastseen': 'Last Seen',
			'deleteselectedhint': 'This action will delete the selected messages.  Please note that this only deletes your side of the conversation, \n the messages will still show on your partners device.',
			'deleteselected': 'Delete selected',
			'unabletofetchconversation': 'Unable to Fetch \nyour conversation with \n',
			'loadmoreconversation': 'Load more conversations',
			'sendyourfirstmessage': 'Send your first message to \n',
			'unblock': 'Unblock ',
			'block': 'Block',
			'writeyourmessage': 'Write your message...',
			'clearconversation': 'Clear Conversation',
			'clearconversationhintone': 'This action will clear all your conversation with ',
			'clearconversationhinttwo': '.\n  Please note that this only deletes your side of the conversation, the messages will still show on your partners chat.',
			'facebookloginerror': 'Something went wrong with the login process.\n, Here is the error Facebook gave us',
		};
	}
}
 