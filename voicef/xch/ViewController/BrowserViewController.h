//
//  BrowserViewController.h
//

#import <UIKit/UIKit.h>
#import "Channel.h"
#import "DaoChannel.h"
#import "LocalFeed.h"
#import "AdBlock.h"
#import "UserInfo.h"
#import "UIViewController+MJPopupViewController.h"
#import "BookmarkFormViewController.h"
#import "FeedEntry.h"
#import "History.h"
#import "HistoryStore.h"
#import "Reachability.h"

typedef NS_ENUM(NSUInteger, BrowserScrollType) {
    BrowserScrollTypeDefault,
    BrowserScrollTypeUp,
    BrowserScrollTypeDown
};

// アドレスバーに入力された文字のタイプ（URL|キーワード）
typedef NS_ENUM(NSUInteger, AddressBarInputType) {
    AddressBarInputTypeUrl,
    AddressBarInputTypeKeyword
};

@interface BrowserViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    UIWebView *webView;
    NSUInteger webViewLoads;
    // Scroll
    CGPoint scrollBeginingPoint;
    CGPoint scrollBeforePoint;
    NSUInteger scrollType;
    UIView *customToolBar;
    UIButton *btnBookmark;
    Channel *tmpChannel;
    NetworkStatus networkStatus;
}

@property (weak, nonatomic) NSString *paramUrl; // URL持ち回し用
@property (weak, nonatomic) FeedEntry *paramFeedEntry;

@end
