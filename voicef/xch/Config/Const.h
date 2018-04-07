//
//  Const.h
//

#ifndef xch_Const_h
#define xch_Const_h

#ifdef DEBUG
#define EXT_DOMAIN @""
#else
#define EXT_DOMAIN @""
#endif

#define EXT_IMAGE_PROXY_URL     @"http://" EXT_DOMAIN "/scripts/image-proxy.php?url="
#define EXT_ACTOR_URL_FORMAT    @"http://" EXT_DOMAIN "/app/api/actor?syllabary_category=%@"
#define EXT_FEED_URL_FORMAT     @"http://" EXT_DOMAIN "/app/api/feed-url?url=%@"
#define EXT_SEARCH_URL_FORMAT   @"http://" EXT_DOMAIN "/app/api/search-keyword?keyword=%@"
#define EXT_SETTING_URL_FORMAT  @"http://" EXT_DOMAIN "/app/api/setting"

#define EXT_DEFAULT_PAGE    @"http://" EXT_DOMAIN "/app/index/gw"
#define EXT_REVIEW_URL      @""
#define EXT_EXTRAGE_URL     @""
#define EXT_OURAPPS_URL     @""


// Support Mail
#define EXT_SUPPORT_MAIL_ADDR       @""
#define EXT_SUPPORT_MAIL_SUBJECT    @"不適切コンテンツ報告"
#define EXT_SUPPORT_MAIL_CONTENTS   @"mailto:" EXT_SUPPORT_MAIL_ADDR "?Subject=" EXT_SUPPORT_MAIL_SUBJECT "&body="
#define EXT_SUPPORT_MAIL_BODY       @"URL : %@\n"

// 友達におしえるメール
#define EXT_INVITE_MAIL_SUBJECT     @""
#define EXT_INVITE_MAIL_CONTENTS    @"mailto: ?Subject=" EXT_INVITE_MAIL_SUBJECT "&body=" EXT_REVIEW_URL

// SQLite
#define DB_FILE_NAME @"voicef.db"

// Banner
static const float kExtBannerWidth      = 320.0;
static const float kExtBannerHeight     = 50.0;

// Navigation,ToolBar...
static const float kExtStatusBarHeight      = 20.0;
static const float kExtNavigationBarHeight  = 44.0;
static const float kExtViewPagerHight       = 49.0;
static const float kExtToolBarHeight        = 44.0;

// Drawer
static const float kExtDrawerMaxWidth   = 320.0;
static const float kExtDrawerMinWidth   = 240.0;

// Animation
static const float kEXTBrowserAnimationDuration = 0.1f;

// NavigationBar Color
#define EXT_NAVIGATION_BAR_COLOR        @"BDC3C4"
#define EXT_NAVIGATION_BAR_TINT_COLOR   @"333333"
#define EXT_NAVIGATION_BAR_TITLE_COLOR  @"333333"


#endif