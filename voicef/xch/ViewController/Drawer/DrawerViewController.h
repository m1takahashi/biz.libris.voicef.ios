//
//  DrawerViewController.h
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "DrawerHistoryViewController.h"
#import "DrawerBookmarkViewController.h"
#import "SearchSyllabaryTopViewController.h"

@interface DrawerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
