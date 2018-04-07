//
//  SearchSyllabaryTopViewController.m
//

#import "SearchSyllabaryTopViewController.h"

@interface SearchSyllabaryTopViewController (){
    NSArray *list;
}
@end

@implementation SearchSyllabaryTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"search_syllabary", nil) ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    // あかさたなはまやらわ
    NSString* path = [[NSBundle mainBundle] pathForResource:@"SyllabaryCategory" ofType:@"plist"];
    list = [NSArray arrayWithContentsOfFile:path];
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


#pragma mark - Table view data source
// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

// セル表示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *CellIdentifier = @"Cell";
    cell = [self.tableViewSyllabary dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dic = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"label"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

// 選択
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [list objectAtIndex:indexPath.row];
    SearchSyllabaryListViewController *view = [[SearchSyllabaryListViewController alloc] init];
    [view setParamSyllabary:[dic objectForKey:@"prefix"]];
    [self.navigationController pushViewController:view animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
