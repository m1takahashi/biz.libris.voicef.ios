//
//  FeedViewController.m
//  xch
//
//  Created by Masahiro TAKAHASHI(EXT) on 2014/07/27.
//  Copyright (c) 2014年 Extrade,Inc. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize tableViewEntry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"favorite", nil)];
        
        // TODO: リスト編集ボタン
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    
    // iOS7対応 罫線
    [UITableViewCell appearance].separatorInset = UIEdgeInsetsZero;
    
//    float screenSizeHeight = (STATUS_BAR_FRAME.size.height == 40) ? SCREEN.size.height - 20 : SCREEN.size.height;

    // UIRefreshControl の初期化
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(refresh)
              forControlEvents:UIControlEventValueChanged];
    [tableViewEntry addSubview:_refreshControl];
    
    // DAO初期化
    daoChannel  = [[DaoChannel alloc] init];
    daoEntry    = [[DaoEntry alloc] init];
    
    // ネットワーク確認
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    networkStatus = [reachablity currentReachabilityStatus];
    
    [self showCoachMarks];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ContentViewController#viewDidAppear");
    page = 1; // ページ初期化
    
    [self loadTaskLocal];
    [tableViewEntry reloadData];
    
    // EULA
    if (![UserInfo eula]) {
        EulaNewViewController *eula = [[EulaNewViewController alloc] init];
        [self presentViewController:eula animated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - Initialize
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                      action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton
                                     animated:YES];
}
-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"News"]
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:self
                                                                                      action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton
                                     animated:YES];
}


#pragma mark - Button
- (void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft
                                      animated:YES
                                    completion:nil];
}
- (void)rightDrawerButtonPress:(id)sender
{
    FeedListViewController *view = [[FeedListViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}


// リフレッシュ
- (void)refresh
{
    // ネットワーク確認
    // ネットワークに繋がらない状態で更新するとデータが消えたようにみえる
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    networkStatus = [reachablity currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [_refreshControl endRefreshing];　// ローディング解除
        [self.view makeToast:NSLocalizedString(@"error_msg_not_reachable", nil)
                    duration:3.0
                    position:@"center"];
        return;
    }
    
    [_refreshControl beginRefreshing];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"loading", nil)];
    
    // ローカルデータを最新にする
    LocalFeed *localFeed = [[LocalFeed alloc] init];
    [localFeed update];
    
    // 表示
    [self loadTaskLocal];
    [tableViewEntry reloadData];
    [_refreshControl endRefreshing];
}


// 内部記事更新
- (void)loadTaskLocal
{
    newsList = [NSMutableArray array];
    
    // チャンネル名一覧取得
    NSArray *channels = [daoChannel channels];
    // キー：値
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *vals = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [channels count]; i++) {
        Channel *channel = [channels objectAtIndex:i];
        [keys addObject:[NSNumber numberWithUnsignedInteger:channel.channelId]]; // NSNumber Wrap
        [vals addObject:channel.title];
    }
    
    NSDictionary *channelDic = [NSDictionary dictionaryWithObjects:vals forKeys:keys];

    // 日付フォーマット
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSArray *list = [daoEntry entries];
    for (int i = 0; i < list.count; i++) {
        Entry *tmp = [list objectAtIndex:i];
        // TimeStamp -> 文字列
        NSTimeInterval interval = tmp.dateTimestamp;
        NSDate* expiresDate = [NSDate dateWithTimeIntervalSince1970:interval];
        NSString *dateStr = [formatter stringFromDate:expiresDate];
        
        // サーバー側のデータフォーマットにあわせる
        FeedEntry *entry = [[FeedEntry alloc] init];
        [entry setEntryId:tmp.entryId];
        [entry setChannelId:tmp.channelId];
        [entry setTitle:tmp.title];
        [entry setLink:tmp.link];
        [entry setImageUrl:tmp.imageUrl];
        [entry setDateModified:dateStr];
        [entry setSiteTitle:[channelDic objectForKey:[NSNumber numberWithUnsignedInteger:tmp.channelId]]]; // チャンネルタイトル
        [newsList addObject:entry];
    }
}

#pragma mark - TableView
// 行の高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedEntry *entry = [newsList objectAtIndex:indexPath.row];
    if ([entry.imageUrl isEqualToString:@""]) {
        return 90.0;
    } else {
        return 105.0;
    }
}

/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsList count];
}

// セル作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedEntry *entry = [newsList objectAtIndex:indexPath.row];
//    NSLog(@"Entry Desc : %@", [entry description]);
    NSString *imageUrl = [EXT_IMAGE_PROXY_URL stringByAppendingString:entry.imageUrl];
//    NSLog(@"Proxy Url : %@", imageUrl);
    
    
    if ([entry.imageUrl isEqualToString:@""]) {
        // 文字のみ
        static NSString* CellIdentifier = @"EntryCellText";
        EntryCellText* cell = (EntryCellText *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            EntryCellTextViewController *controllerText = [[EntryCellTextViewController alloc] initWithNibName:@"EntryCellTextViewController" bundle:nil];
            cell = (EntryCellText*)controllerText.view;
        }
        
        // 文字数が少ない場合には改行を入れて上揃えにする TODO:
        NSString *title = entry.title;
        if ([title length] <= 18) {
            title = [title stringByAppendingString:@"\n　"];
        }
        
        if (title != nil && entry.siteTitle != nil) {
            [cell setTitle:title];
            [cell setAuthor:entry.siteTitle];
            [cell setModified:entry.dateModified];
        }
        // ツィート数非表示
        [cell setTwitterCount:@""];
        [cell setTwitterIconHidden:YES];
        return cell;
    } else {
        // 画像あり
        static NSString* CellIdentifier = @"EntryCell";
        EntryCell* cell = (EntryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            EntryCellViewController *controller = [[EntryCellViewController alloc] initWithNibName:@"EntryCellViewController" bundle:nil];
            cell = (EntryCell*)controller.view;
        }
        if (entry.title != nil && entry.siteTitle != nil) {
            [cell setTitle:entry.title];
            [cell setAuthor:entry.siteTitle];
            [cell setModified:entry.dateModified];
        }
        
        // 切り抜き方法指定
        cell.thumb.contentMode = UIViewContentModeScaleAspectFill;
        cell.thumb.clipsToBounds = YES;
        
        [cell.thumb setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholderImage:[UIImage imageNamed:@"Loading"]];

        // ツィート数非表示
        [cell setTwitterCount:@""];
        [cell setTwitterIconHidden:YES];
        
        return cell;
    }
}

// 選択（ナビゲーションコントローラでブラウザへ遷移）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedEntry *entry = [newsList objectAtIndex:indexPath.row];
    BrowserViewController *view = [[BrowserViewController alloc] init];
    [view setParamUrl:entry.link];
    [view setParamFeedEntry:entry]; // 違反報告用
    [self.navigationController pushViewController:view
                                         animated:YES];
}

-(void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの色(交互にする)
    if ((indexPath.row % 2) == 0) {
        cell.backgroundColor = [UIColor colorWithHue:0.61 saturation:0.09 brightness:0.99 alpha:0.2];
    }
}


#pragma mark - ScrollView Delegate
// スクロール開始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollBeginingPoint = [scrollView contentOffset];
    scrollType          = ContentsScrollTypeDefault;
}

// スクロール中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentPoint = [scrollView contentOffset];
    float move = currentPoint.y - scrollBeforePoint.y;
    scrollBeforePoint = currentPoint;
    
    // 上下スクロール判断
    if (scrollBeginingPoint.y > currentPoint.y) {
        if (scrollType != ContentsScrollTypeDown) {
            NSLog(@"Scroll : Down");
            scrollType = ContentsScrollTypeDown;
        }
    } else if (scrollBeginingPoint.y < currentPoint.y) {
        if (scrollType != ContentsScrollTypeUp) {
            NSLog(@"Scroll : UP");
            scrollType = ContentsScrollTypeUp;
        }
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)){
            NSLog(@"Scroll : End of Page");
        }
    }
    NSLog(@"Move : %f", move);
    
    NSNumber *nMove = [NSNumber numberWithFloat:move];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:nMove
                                                    forKey:@"move"];
    NSNotification *n = [NSNotification notificationWithName:@"NCScroll"
                                                      object:self
                                                    userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

// スクロール終了（フリック）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSNumber *type = [NSNumber numberWithUnsignedInteger:scrollType];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:type
                                                    forKey:@"scroll_type"];
    NSNotification *n = [NSNotification notificationWithName:@"NCScrollEnd"
                                                      object:self
                                                    userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

// スクロール終了（加速なし）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSNumber *type = [NSNumber numberWithUnsignedInteger:scrollType];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:type
                                                    forKey:@"scroll_type"];
    NSNotification *n = [NSNotification notificationWithName:@"NCScrollEnd"
                                                      object:self
                                                    userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

// CoachMarks
- (void)showCoachMarks {
    if ([UserInfo coachmarksFavorite]) {
        return;
    } else {
        [UserInfo setCoachmarksFavorite:YES];
    }
    
    // Setup coach marks
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{0, 60.0f},{320.0f,4.0f}}],
                                @"caption": NSLocalizedString(@"coachmarks_caption", nil)
                                }
                            ];
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    [self.view addSubview:coachMarksView];
    [coachMarksView start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
