//
//  DrawerBookmarkViewController.h
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "BrowserViewController.h"
#import "Bookmark.h"
#import "BookmarkStore.h"
#import "BookmarkFormViewController.h"

@interface DrawerBookmarkViewController : UIViewController
{
    NSArray *list;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewBookmark;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
