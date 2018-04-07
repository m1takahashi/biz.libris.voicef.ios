//
//  SearchKeywordViewController.h
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "Actor.h"
#import "ActorCellTextViewController.h"
#import "Reachability.h"
#import "BrowserViewController.h"

@interface SearchKeywordViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NetworkStatus networkStatus;
    NSMutableArray *list;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarKeyword;
@property (weak, nonatomic) IBOutlet UITableView *tableViewResult;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
