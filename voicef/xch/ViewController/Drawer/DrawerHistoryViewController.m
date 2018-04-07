//
//  DrawerHistoryViewController.m
//

#import "DrawerHistoryViewController.h"

@interface DrawerHistoryViewController ()

@end

@implementation DrawerHistoryViewController
@synthesize tableViewHistory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"history", nil)];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"clear", nil)
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(pushClearButton:)];
        [self.navigationItem setRightBarButtonItem:btn];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    NSArray *rawList = [[HistoryStore defaultStore] allHistorys];
    list = [[rawList reverseObjectEnumerator] allObjects]; // 降順表示
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


#pragma mark - Button
- (void)pushClearButton:(id)sender
{
    [[HistoryStore defaultStore] removeAllHistory]; // 全件削除
    // 再取得
    NSArray *rawList = [[HistoryStore defaultStore] allHistorys];
    list = [[rawList reverseObjectEnumerator] allObjects]; // 降順表示（一応）
    [tableViewHistory reloadData];
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
    
    
    cell = [self.tableViewHistory dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    History *history = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = history.historyTitle;
    return cell;
    
}

// セル選択
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    History *history = [list objectAtIndex:indexPath.row];
    [APP_DELEGATE switchCenterView:kExtCenterViewTypeBrowser params:@{@"ParamUrl":history.historyUrl}];
    [self.mm_drawerController closeDrawerAnimated:YES
                                       completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
                                       }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
