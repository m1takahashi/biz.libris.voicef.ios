//
//  FeedViewController.h
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FeedViewController.h"
#import "FeedListViewController.h"
#import "BrowserViewController.h"
#import "EntryCellViewController.h"
#import "EntryCellTextViewController.h"
#import "EulaNewViewController.h"
#import "FeedEntry.h"
#import "Channel.h"
#import "DaoChannel.h"
#import "Entry.h"
#import "DaoEntry.h"
#import "LocalFeed.h"

static const NSUInteger kNumPerPage = 50;

typedef NS_ENUM(NSUInteger, NewsActionType) {
    NewsActionTypeNone,
    NewsActionTypeInit,
    NewsActionTypeAdd,
    NewsActionTypeRefresh
};

typedef NS_ENUM(NSUInteger, ContentsScrollType) {
    ContentsScrollTypeDefault,
    ContentsScrollTypeUp,
    ContentsScrollTypeDown
};


@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
//    NSArray *dataSource;
    NSMutableArray *newsList;
    NSUInteger actionType;
    NSUInteger page;
    NSString *urlStrBase;
    DaoChannel *daoChannel;
    DaoEntry *daoEntry;
    UITableView *_tableView;
    UIRefreshControl *_refreshControl;
    // Scroll
    CGPoint scrollBeginingPoint;
    CGPoint scrollBeforePoint;
    NSUInteger scrollType;
    NetworkStatus networkStatus;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewEntry;


@end
