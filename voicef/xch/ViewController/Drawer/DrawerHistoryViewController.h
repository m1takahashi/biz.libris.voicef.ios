//
//  DrawerHistoryViewController.h
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "BrowserViewController.h"
#import "History.h"
#import "HistoryStore.h"

@interface DrawerHistoryViewController : UIViewController
{
    NSArray *list;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewHistory;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
