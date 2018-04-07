//
//  SettingViewController.m
//

#import "SettingViewController.h"

@interface SettingViewController ()
{
    UISwitch *swAdBlock;
}
@end

@implementation SettingViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"setting", nil) ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLeftMenuButton];

    // アドブロック用スイッチ
    swAdBlock = [[UISwitch alloc] initWithFrame:CGRectZero];
    [swAdBlock setTag:0];
    [swAdBlock addTarget:self
                  action:@selector(changeSwitch:)
        forControlEvents:UIControlEventTouchUpInside];
    if ([UserInfo adBlock]) {
        NSLog(@"スイッチの状態 : ON");
    } else {
        NSLog(@"スイッチの状態 : OFF");
    }
    
    [swAdBlock setOn:[UserInfo adBlock]]; // スイッチの状態セット
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self appearAd];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self disappearAd];
}

#pragma mark - Initialize
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}


#pragma mark - Button
- (void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - TableView
// グループ数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//セクションあたりの行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
		case 1:
            return 5;
            break;
		default:
            return 0;
            break;
	}
}

//セクションタイトル
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
            return NSLocalizedString(@"browser", nil);
            break;
		case 1:
            return NSLocalizedString(@"others", nil);
        default:
            return @"";
            break;
	}
}

//セルを生成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	UITableViewCell *cell;
	NSString *CellIdentifier = @"Cell";
    
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = [ColorManager getTableCellText];
    cell.textLabel.font = [FontManager getTableCellText];
    
    // バージョン名
    NSString *version    = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build      = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *versionStr = [NSString stringWithFormat:@"%@ (%@)", version, build];
    
	switch (section) {
		case 0:
			switch (row) {
				case 0:
                    cell.textLabel.text = NSLocalizedString(@"fast_loading", nil);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryView = swAdBlock;
                    break;
                default:
					break;
			}
			return cell;
		case 1:
			switch (row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"review", nil);
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"invite_friend", nil);
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"ourapps", nil);
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                    break;
				case 3:
					cell.textLabel.text = NSLocalizedString(@"open_source", nil);
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case 4:
					cell.textLabel.text = NSLocalizedString(@"version", nil);
					cell.detailTextLabel.text = versionStr;
					break;
				default:
					break;
			}
			return cell;
    }
    return cell;
    
}

// セル選択
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row     = [indexPath row];
    switch (section) {
        case 1:
            if (row == 0) {
                // Review
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:EXT_REVIEW_URL]];
            } else if (row == 1) {
                // Invite Friend
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[EXT_INVITE_MAIL_CONTENTS stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            } else if (row == 2) {
                // Our Apps
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:EXT_OURAPPS_URL]];
            } else if (row == 3) {
                // オープンソースライセンス表示
                LicenseViewController *view = [[LicenseViewController alloc] init];
                [self.navigationController pushViewController:view animated:YES];
            }
            break;
        default:
            break;
    }
}


#pragma mark - UISwitch
- (void)changeSwitch:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    if (sw.tag == 0) {
        if (sw.on) {
            [UserInfo setAdBlock:YES];
        } else {
            [UserInfo setAdBlock:NO];
        }
    }
}

#pragma mark - AdStir
- (void)appearAd
{
    float posY = SCREEN.size.height;
    // Wifi|録音中
    if (STATUS_BAR_FRAME.size.height == 40) {
        posY -= 20;
    }
    posY -= kExtBannerHeight;
    
}

- (void)disappearAd
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
