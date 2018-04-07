//
//  EXTAppDelegate.h
//

#import <UIKit/UIKit.h>
#import "SiteStore.h"
#import "HistoryStore.h"
#import "BookmarkStore.h"
#import "Reachability.h"
#import "Crittercism.h"


typedef NS_ENUM(NSUInteger, kExtCenterViewType) {
    kExtCenterViewTypeDefault,
    kExtCenterViewTypeFeed,         // お気に入り(内部データ)
    kExtCenterViewTypeSearchSyllabary,  // 五十音順
    kExtCenterViewTypeSearchKeyword,    // キーワード検索
    kExtCenterViewTypeSetting,
    kExtCenterViewTypeBrowser,
};

@interface EXTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL inReview;

-(void)switchCenterView:(NSUInteger)type params:(NSDictionary*)value;


@end
