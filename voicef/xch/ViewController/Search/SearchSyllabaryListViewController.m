//
//  SearchSyllabaryListViewController.m
//

#import "SearchSyllabaryListViewController.h"

@interface SearchSyllabaryListViewController ()

@end

@implementation SearchSyllabaryListViewController
@synthesize tableViewActor;
@synthesize paramSyllabary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupLeftMenuButton];
    tableViewActor.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // ネットワーク確認
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    networkStatus = [reachablity currentReachabilityStatus];
    
    // 五十音（あいうえお）取得
    NSString *resourceName = [NSString stringWithFormat:@"Syllabary-%@", paramSyllabary];
    NSLog(@"ResourceName : %@", resourceName);
    NSString* path = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"plist"];
    syllabaryList = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"ResourceList : %@", syllabaryList);
}

- (void)viewDidAppear:(BOOL)animated
{
    // ネットワーク確認
    if (networkStatus != NotReachable) {
        list = [NSMutableArray array];  // リスト初期化
        [self loadTaskWithSyllabaryCategory:paramSyllabary];
    } else {
        [self.view makeToast:NSLocalizedString(@"error_msg_not_reachable", nil)
                    duration:3.0
                    position:@"center"];
        
    }
}

// 非同期読み込み
- (void)loadTaskWithSyllabaryCategory:(NSString*)syllabary
{
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     
     NSString *urlStr = [NSString stringWithFormat:EXT_ACTOR_URL_FORMAT, syllabary];
     NSLog(@"URL STR : %@", urlStr);
     
     // サイト一覧取得
     NSURL *url = [NSURL URLWithString:urlStr];
     NSURLSession *session = [NSURLSession sharedSession];
     NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     // TODO: エラー処理
     if (error) {
     [NSException raise:@"Exception downloading data"
     format:@"%@", error.localizedDescription];
     }
     
     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         //NSLog(@"%@", json);
         // リストに追加
         [self addList:[json objectForKey:@"data"]];
         dispatch_async(dispatch_get_main_queue(), ^{
             [tableViewActor reloadData];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         });
     }];
     [dataTask resume];
}


// FeedEntry型に変換して、リストに追加する
- (void)addList:(NSDictionary *)data
{
    // 単純な配列
    NSMutableArray *rawList = [NSMutableArray array];
    for (NSDictionary *obj in data) {
        Actor *actor = [[Actor alloc] initWithObject:obj];
        [rawList addObject:actor];
    }
    
    // グループ化された配列
    for (int j = 0; j < syllabaryList.count; j++) {
        NSDictionary *dic = [syllabaryList objectAtIndex:j];
        NSString *prefix = [dic objectForKey:@"prefix"];
        NSLog(@"Prefix : %@", prefix);
        
        NSMutableArray *tmp = [NSMutableArray array]; // 初期化
        for (int i = 0; i < rawList.count; i++) {
            Actor *actor = [rawList objectAtIndex:i];
            NSLog(@"Name : %@, Syllabary : %@", actor.name, actor.syllabary);
            if ([actor.syllabary isEqualToString:prefix]) {
                NSLog(@"Match");
                [tmp addObject:actor];
            } else {
                NSLog(@"Not Match");
            }
        }
        [list addObject:tmp];
    }
    
    [tableViewActor reloadData];
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
// 行の高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return syllabaryList.count;
}

// セクションタイトル
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [syllabaryList objectAtIndex:section];
    NSString *label = [dic objectForKey:@"label"];
    return label;
}


/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[list objectAtIndex:section] count];
    return count;
}

// セル作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Actor *actor = [[list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    static NSString* CellIdentifier = @"ActorCellText";
    ActorCellText* cell = (ActorCellText *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        ActorCellTextViewController *controllerText = [[ActorCellTextViewController alloc] initWithNibName:@"ActorCellTextViewController" bundle:nil];
        cell = (ActorCellText*)controllerText.view;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone; // タップ不可（ボタンで操作するので）

    // 基本情報
    [cell setName:actor.name];
    [cell setNameKana:actor.nameKana];
    [cell setBlogTitle:actor.blogTitle];

    // セル内のボタンをタグ付け
    [cell.buttonProf setTag:1];
    [cell.buttonBlog setTag:2];
    [cell.buttonTwitter setTag:3];
    
    // プロフボタン
    if ([actor.officialUrl isEqualToString:@""]) {
        [cell.buttonProf setEnabled:NO]; // 不可
    } else {
        [cell.buttonProf setEnabled:YES]; // 可
        // 画像設定
        UIImage *imageProf = [UIImage imageNamed:@"Prof"];
        [cell.buttonProf setImage:imageProf
                         forState:UIControlStateNormal];
        // イベント設定
        [cell.buttonProf addTarget:self
                            action:@selector(handleTouchButton:event:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    // ブログボタン
    if ([actor.blogUrl isEqualToString:@""]) {
        [cell.buttonBlog setEnabled:NO];
    } else {
        [cell.buttonBlog setEnabled:YES];
        // 画像設定
        UIImage *imageBlog = [UIImage imageNamed:@"Blog"];
        [cell.buttonBlog setImage:imageBlog
                         forState:UIControlStateNormal];
        // イベント設定
        [cell.buttonBlog addTarget:self
                            action:@selector(handleTouchButton:event:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Twitter
    if ([actor.twitterUrl isEqualToString:@""]) {
        [cell.buttonTwitter setEnabled:NO];
    } else {
        // 画像設定
        UIImage *imageTwitter = [UIImage imageNamed:@"Twitter"];
        [cell.buttonTwitter setImage:imageTwitter
                            forState:UIControlStateNormal];
        // イベント設定
        [cell.buttonTwitter addTarget:self
                               action:@selector(handleTouchButton:event:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

// 選択（ナビゲーションコントローラでブラウザへ遷移）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // なにもしない
}

/**
 * セル内のボタンを感知する
 * http://qiita.com/tomochang/items/8770c1963afd8157e56b
 */
#pragma mark - handleTouchEvent
- (void)handleTouchButton:(UIButton *)sender event:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    
    // タグ取得
    UITouch *touch = [[event allTouches] anyObject];
    int tag = (int)touch.view.tag;
    
    Actor *actor = [[list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *urlStr = @"";
    if (tag == 1) {
        // プロフ
        urlStr = actor.officialUrl;
    } else if (tag == 2) {
        // ブログ
        urlStr = actor.blogUrl;
    } else if (tag == 3) {
        // Twitter
        urlStr = actor.twitterUrl;
        
    }
    
    // 指定されたURLへ遷移する
    BrowserViewController *view = [[BrowserViewController alloc] init];
    [view setParamUrl:urlStr];
    [self.navigationController pushViewController:view
                                         animated:YES];
}

// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:tableViewActor];
    NSIndexPath *indexPath = [tableViewActor indexPathForRowAtPoint:p];
    return indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
