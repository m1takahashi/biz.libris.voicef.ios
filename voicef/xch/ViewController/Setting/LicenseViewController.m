//
//  LicenseViewController.m
//

#import "LicenseViewController.h"

@interface LicenseViewController ()
{
    NSArray* _labelList;
    NSArray* _urlList;
}

@end

@implementation LicenseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[self navigationItem] setTitle:NSLocalizedString(@"open_source", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS7対応 罫線
    [UITableViewCell appearance].separatorInset = UIEdgeInsetsZero;
    
    _labelList = [NSArray arrayWithObjects:@"MMDrawerController",
                  @"Toast",
                  @"SDWebImage",
                  @"WSCoachMarksView",
                  nil];
    _urlList = [NSArray arrayWithObjects:@"http://cocoadocs.org/docsets/MMDrawerController/0.5.6/",
                @"http://cocoadocs.org/docsets/Toast/2.2/",
                @"http://cocoadocs.org/docsets/SDWebImage/3.6/",
                @"https://cocoapods.org/pods/WSCoachMarksView",
                nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_labelList count];
}

// セル表示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	NSString *CellIdentifier = @"Cell";
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = [ColorManager getTableCellText];
    cell.textLabel.font = [FontManager getTableCellText];
    cell.textLabel.text = [_labelList objectAtIndex:indexPath.row];
    return cell;
}

// 選択
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrowserViewController *view = [[BrowserViewController alloc] init];
    [view setParamUrl:[_urlList objectAtIndex:indexPath.row]];
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:NO];
    [navController pushViewController:view animated:YES];
}

@end
