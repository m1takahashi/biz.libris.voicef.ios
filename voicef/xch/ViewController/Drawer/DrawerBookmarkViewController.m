//
//  DrawerBookmarkViewController.m
//

#import "DrawerBookmarkViewController.h"

@interface DrawerBookmarkViewController ()

@end

@implementation DrawerBookmarkViewController
@synthesize tableViewBookmark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"bookmark", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // iOS7対応 罫線
    [UITableViewCell appearance].separatorInset = UIEdgeInsetsZero;
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(toggleEditingMode:)];
    [self.navigationItem setRightBarButtonItem:editItem];
    
    [self.tableViewBookmark setAllowsSelectionDuringEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    list = [[BookmarkStore defaultStore] allBookmarks];
    [self.tableViewBookmark reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (![self.tableViewBookmark isEditing]) {
        [self.mm_drawerController setMaximumLeftDrawerWidth:kExtDrawerMinWidth];
    }
    [super viewWillDisappear:animated];
}


#pragma mark - Button
// 編集モード
- (void)toggleEditingMode:(id)sender
{
    if ([self.tableViewBookmark isEditing]) {
        [self.tableViewBookmark setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                               target:self
                                                                                               action:@selector(toggleEditingMode:)];
        [self.mm_drawerController setMaximumLeftDrawerWidth:kExtDrawerMinWidth
                                                   animated:YES
                                                 completion:nil];
        
        self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
        
    } else {
        [self.tableViewBookmark setEditing:YES animated:YES];
        // navigation Barの右側に[Done]ボタンを表示する。
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(toggleEditingMode:)];
        [self.mm_drawerController setMaximumLeftDrawerWidth:kExtDrawerMaxWidth
                                                   animated:YES
                                                 completion:nil];
        
        self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
        self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    }
}

#pragma mark - TableView
//セクションあたりの行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}


//セルを生成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	NSString *CellIdentifier = @"Cell";
    cell = [self.tableViewBookmark dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    Bookmark *bookmark = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = bookmark.bookmarkTitle;
    
    return cell;
}

// セル選択
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bookmark *bookmark = [list objectAtIndex:indexPath.row];
    if ([self.tableViewBookmark isEditing]) {
        // 編集
        BookmarkFormViewController *view = [[BookmarkFormViewController alloc] init];
        [view setParamBookmark:bookmark];
        [view setParamEditType:BookmarkFormEditTypeEdit];
        [self.navigationController pushViewController:view animated:YES];
    } else {
        //
        [APP_DELEGATE switchCenterView:kExtCenterViewTypeBrowser params:@{@"ParamUrl":bookmark.bookmarkUrl}];
        [self.mm_drawerController closeDrawerAnimated:YES
                                           completion:^(BOOL finished) {
                                               [self.navigationController popViewControllerAnimated:NO];
                                           }];
    }
}

// ブックマーク削除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *bookmarks = [[BookmarkStore defaultStore] allBookmarks];
        Bookmark *bookmark = [bookmarks objectAtIndex:[indexPath row]];
        [[BookmarkStore defaultStore] removeBookmark:bookmark];
        // その行をアニメーション付きでTableRowから削除する
        [self.tableViewBookmark deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
    }
}

// ブックマーク移動
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BookmarkStore defaultStore] moveBookmarkAtIndex:(int)sourceIndexPath.row
                                              toIndex:(int)destinationIndexPath.row];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
