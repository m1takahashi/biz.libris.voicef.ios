//
//  SearchSyllabaryListViewController.h
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "ActorCellTextViewController.h"
#import "BrowserViewController.h"
#import "Actor.h"
#import "Reachability.h"


@interface SearchSyllabaryListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *list;
    NetworkStatus networkStatus;
    NSArray *syllabaryList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewActor;
@property (weak, nonatomic) NSString *paramSyllabary; // 持ち回し用

@end
