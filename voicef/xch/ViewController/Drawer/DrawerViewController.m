//
//  DrawerViewController.m
//

#import "DrawerViewController.h"
#import "SettingViewController.h"

@interface DrawerViewController ()
@end

@implementation DrawerViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem]setTitle:NSLocalizedString(@"menu", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


#pragma mark - TableView
// グループ数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//セクションあたりの行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

//セクションタイトル
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
            return NSLocalizedString(@"contents", nil);
            break;
        case 1:
            return NSLocalizedString(@"search", nil);
            break;
		case 2:
            return NSLocalizedString(@"setting", nil);
            break;
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
    cell.textLabel.textColor = [ColorManager getDrawerText];
    cell.textLabel.font = [FontManager getDrawerText];

	switch (section) {
		case 0:
			switch (row) {
				case 0:
					cell.textLabel.text = NSLocalizedString(@"favorite", nil);
					break;
				case 1:
					cell.textLabel.text = NSLocalizedString(@"bookmark", nil);
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case 2:
					cell.textLabel.text = NSLocalizedString(@"history", nil);
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;                    
					break;
                default:
                    break;
			}
			return cell;
        case 1:
            switch (row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"search_syllabary", nil);
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"search_keyword", nil);
                    break;
                default:
                    break;
            }
            return cell;
		case 2:
            // 現状『設定』は一つのみ
            cell.textLabel.text = NSLocalizedString(@"others", nil);
			return cell;
    }
    return cell;
    
}

// セル選択
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = (int)indexPath.section;
    int row     = (int)indexPath.row;

    if (section == 0) {
        // コンテンツ
        if (row == 0) {
            // お気に入り
            [APP_DELEGATE switchCenterView:kExtCenterViewTypeFeed params:nil];
        } else if (row == 1) {
            // ブックマーク
            DrawerBookmarkViewController *view = [[DrawerBookmarkViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        } else if (row == 2) {
            // 履歴
            DrawerHistoryViewController *view = [[DrawerHistoryViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
    } else if (section == 1) {
        // さくいん・キーワード検索
        if (row == 0) {
            [APP_DELEGATE switchCenterView:kExtCenterViewTypeSearchSyllabary params:nil]; // 五十音
        } else if (row == 1) {
            [APP_DELEGATE switchCenterView:kExtCenterViewTypeSearchKeyword params:nil]; // キーワード検索
        }
    } else if (section == 2) {
        [APP_DELEGATE switchCenterView:kExtCenterViewTypeSetting params:nil]; // その他設定
    }
    
    if (section == 0 && ((row == 1) || (row == 2))) {
        // ブックマーク, 履歴の場合には、メニューを閉じない
        return;
    } else {
        // メニュー閉じる
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
