//
//  BrowserViewController.m
//  @see http://d.hatena.ne.jp/KishikawaKatsumi/20100505/1273016893
//  @see http://nk-z.net/blog/?p=41
//

#import "BrowserViewController.h"

@interface BrowserViewController ()
{
    NSString *_message;
}
@end

@implementation BrowserViewController
@synthesize paramUrl;
@synthesize paramFeedEntry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]]; // 背景色
    [self layoutNavigationBar];
    [self initContent];
    [self setContentHeightWithBottom:NO];
    [self initCustomToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self setContentHeightWithBottom:NO];
    
    // ネットワーク確認
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    networkStatus = [reachablity currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self.view makeToast:NSLocalizedString(@"error_msg_not_reachable", nil)
                    duration:3.0
                    position:@"center"];
//        return;
    }
    

    // フィードURL一時データ初期化
//    tmpChannel = [[Channel alloc] init];
    
    webViewLoads = 0;
    NSURL *url = [NSURL URLWithString:paramUrl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Content
- (void)initContent
{
    webView = [[UIWebView alloc] init];
    webView.scalesPageToFit     = YES;
    webView.delegate            = self;
    webView.scrollView.bounces  = NO;
    webView.scrollView.delegate = self;
    [self.view addSubview:webView];
}

/**
 * コンテンツ高さを変更する
 * 他社広告を画面外にずらして表示しているので、ページの最後にいったときは、高さを調節して、再表示する
 * TODO: ナビゲーションバーを表示・非表示する
 */
- (void)setContentHeightWithBottom:(BOOL)bottom
{
    float screenSizeHeight = (STATUS_BAR_FRAME.size.height == 40) ? SCREEN.size.height - 20 : SCREEN.size.height;
    float height = screenSizeHeight + kExtBannerHeight;
    if (bottom) {
        height = screenSizeHeight - kExtBannerHeight;
    }
    [webView setFrame:CGRectMake(0,
                                 STATUS_BAR_FRAME.size.height + kExtNavigationBarHeight,
                                 SCREEN.size.width,
                                 height)];
}


#pragma mark - Notification
// アップロード（違反通知）
- (void)notificationPopupUpload:(NSNotification *)notification
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}


#pragma mark - Push Button
// リロード（AdBlockの関係上、reloadメソッドは使えない）
- (void)pushRefreshButton:(id)sender
{
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
}

// 戻る
- (void)pushBackButton:(id)sender
{
    if ([webView canGoBack]){
        [webView goBack];
    } else {
        // ニュースへ戻る
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 進む
- (void)pushForwardButton:(id)sender
{
    if ([webView canGoForward]){
        [webView goForward];
    }
}

// Myニュース追加
- (void)pushBookmarksButton:(id)sender
{
    NSLog(@"一時データ : %@", tmpChannel);
    
    if ((tmpChannel.title == nil) ||
        (tmpChannel.blogUrl == nil) ||
        (tmpChannel.rssUrl == nil)) {
        [self.view makeToast:@"フィード情報が見つかりませんでした"
                    duration:3.0
                    position:@"center"];
        return;
    }
    
    if ([tmpChannel.title isEqualToString:@""] ||
        [tmpChannel.blogUrl isEqualToString:@""] ||
        [tmpChannel.rssUrl isEqualToString:@""]) {
        [self.view makeToast:@"フィード情報が見つかりませんでした。"
                    duration:3.0
                    position:@"center"];
        return;
    }
    
    // すでに登録されていないか確認する
    DaoChannel *daoChannel = [[DaoChannel alloc] init];
    if ([daoChannel isRssUrl:tmpChannel.rssUrl]){
        [self.view makeToast:@"登録済みです。"
                    duration:3.0
                    position:@"center"];
        return;
    }
    
    LocalFeed *localFeed = [[LocalFeed alloc] init];
    [localFeed addChannel:tmpChannel];

    [self.view makeToast:[NSString stringWithFormat:@"%@をお気に入りに登録しました。", tmpChannel.title]
                duration:3.0
                position:@"center"];
}

// アップロード（違反報告）
- (void)pushUploadButton:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    [as addButtonWithTitle:NSLocalizedString(@"action_sheet_bookmark", nil)];
    [as addButtonWithTitle:NSLocalizedString(@"action_sheet_report", nil)];
    [as addButtonWithTitle:NSLocalizedString(@"action_sheet_cancel", nil)];
    as.cancelButtonIndex = 2;
    [as showInView:self.view];
}


#pragma mark - ActionSheet
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *url   = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    if (buttonIndex == 0) {
        // ブックマーク
        Bookmark *bookmark = [[Bookmark alloc] initWithBookmarkTitle:title bookmarkUrl:url];
        BookmarkFormViewController *view = [[BookmarkFormViewController alloc] init];
        [view setParamBookmark:bookmark];
        [view setParamEditType:BookmarkFormEditTypeAdd];
        [self presentViewController:view animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        // 違反報告
        NSString *body = [NSString stringWithFormat:EXT_SUPPORT_MAIL_BODY, url];
        NSString *str = [EXT_SUPPORT_MAIL_CONTENTS stringByAppendingString:body];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


#pragma mark - UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 広告ブロック
    if ([UserInfo adBlock]) {
        NSURL *url = [request URL];
        AdBlock *ab = [[AdBlock alloc] init];
        if ([ab isBlackList:[url relativeString]]) {
            NSLog(@"Ad Block : %@", [url relativeString]);
            return NO;
        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 読み込み開始
    if (webViewLoads <= 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self changeBookmarkStatus:NO];
    }
    
    webViewLoads++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webViewLoads--;
    // 読み込み完全完了
    if (webViewLoads <= 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSString *blogUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];

        // 履歴
        History *lastHistory = [[[HistoryStore defaultStore] allHistorys] lastObject];
        NSLog(@"Last History : %@", [lastHistory description]);
        if (![lastHistory.historyUrl isEqualToString:blogUrl]) {
            History *history = [[History alloc] initWithHistoryTitle:title historyUrl:blogUrl];
            NSLog(@"Added History : %@", [history description]);
            [[HistoryStore defaultStore] addHistory:history];
        }
        
        
        // フィードURL取得
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:EXT_FEED_URL_FORMAT, blogUrl]];
        NSLog(@"webViewDidFinishLoad URL : %@", url);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    // TODO: エラー処理
                                                    if (error) {
                                                        [NSException raise:@"Exception downloading data"
                                                                    format:@"%@", error.localizedDescription];
                                                        
                                                    }
                                                    
                                                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:nil];
                                                    NSLog(@"JSON データ：%@", json);
                                                    if (json == nil) {
                                                        NSLog(@"JSONデータが空です。 : %@", [json objectForKey:@"data"]);
                                                        return;
                                                    }
                                                    // サーバーからのレスポンスステータスを確認する
                                                    if (json != nil) {
                                                        int status = [[json objectForKey:@"status"] intValue];
                                                        if (status > 0) {
                                                            // エラー
                                                            NSLog(@"Error Message : %@", [json objectForKey:@"msg"]);
                                                            return;
                                                        } else {
                                                            // 成功
                                                            NSString *blogUrl   = [[json objectForKey:@"data"] objectForKey:@"blog_url"];
                                                            NSString *rssUrl    = [[json objectForKey:@"data"] objectForKey:@"rss_url"];
                                                            NSString *title     = [[json objectForKey:@"data"] objectForKey:@"title"];
                                                            NSLog(@"Blog URL : %@", blogUrl);
                                                            NSLog(@"RSS URL  : %@", rssUrl);
                                                            NSLog(@"Title    : %@", title);
                                                            
                                                            if ([blogUrl isEqualToString:@""] || [rssUrl isEqualToString:@""] || [title isEqualToString:@""]) {
                                                                NSLog(@"No Feed Url");
                                                                return;
                                                            }
                                                            [tmpChannel setTitle:title];
                                                            [tmpChannel setBlogUrl:blogUrl];
                                                            [tmpChannel setRssUrl:rssUrl];
                                                            NSLog(@"Channel Data : %@", [tmpChannel description]);
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self changeBookmarkStatus:YES];
                                                            });
                                                        }
                                                    }
                                                }];
        [dataTask resume];
        
        
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    webViewLoads--;
}

#pragma mark - TextField
// アドレス or キーワード入力
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    NSString *str = textField.text;

    NSUInteger type = AddressBarInputTypeKeyword;
    if ([str hasPrefix:@"http://"]) {
        type = AddressBarInputTypeUrl;
    } else if ([str hasPrefix:@"https://"]) {
        type = AddressBarInputTypeUrl;
    }
    
    
    NSString *urlStr;
    if (type == AddressBarInputTypeUrl) {
        urlStr = str;
    } else if (type == AddressBarInputTypeKeyword) {
        // キーワードをエンコード
        NSString *encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // Google検索
        urlStr = [NSString stringWithFormat:@"https://www.google.co.jp/search?q=%@", encodedString];
    }
    NSLog(@"URL Str : %@", urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    return YES;
}



#pragma mark - Layout
- (void)layoutNavigationBar
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 210, 31)];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setTextColor:[UIColor blackColor]];
    [textField setFont:[UIFont systemFontOfSize:16]];
    [textField setPlaceholder:@"URL/Web検索"];
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setClearButtonMode:UITextFieldViewModeUnlessEditing];
    textField.autocorrectionType    = UITextAutocorrectionTypeNo;
    textField.keyboardType          = UIKeyboardTypeWebSearch;
    textField.returnKeyType         = UIReturnKeyDone;
    textField.delegate              = self;
    self.navigationItem.titleView   = textField;
}

// ツールバー配置
- (void)initCustomToolBar
{
    float screenSizeHeight = (STATUS_BAR_FRAME.size.height == 40) ? SCREEN.size.height - 20 : SCREEN.size.height;
    
    customToolBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             screenSizeHeight - kExtToolBarHeight,
                                                             SCREEN.size.width,
                                                             kExtToolBarHeight
                                                             )];
    [customToolBar setBackgroundColor:[UIColor clearColor]];
    
    UIToolbar *dummy = [[UIToolbar alloc] initWithFrame:customToolBar.bounds];
    [customToolBar insertSubview:dummy atIndex:0];

    float iconSize  = 44.0;
    float marginX   = (SCREEN.size.width - (iconSize * 5)) / 6;
    float posX      = marginX;
    float posY      = 0.0;
    
    // リロード
    UIButton *btnRefresh = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, iconSize, iconSize)];
    [btnRefresh setBackgroundImage:[[UIImage imageNamed:@"Refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                          forState:UIControlStateNormal];
    [btnRefresh addTarget:self
                   action:@selector(pushRefreshButton:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // 戻る
    posX = posX + iconSize + marginX;
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(posX , posY, iconSize, iconSize)];
    [btnBack setBackgroundImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                       forState:UIControlStateNormal];
    [btnBack addTarget:self
                action:@selector(pushBackButton:)
      forControlEvents:UIControlEventTouchUpInside];
    
    // 進む
    posX = posX + iconSize + marginX;
    UIButton *btnForward = [[UIButton alloc] initWithFrame:CGRectMake(posX , posY, iconSize, iconSize)];
    [btnForward setBackgroundImage:[[UIImage imageNamed:@"Forward"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                          forState:UIControlStateNormal];
    [btnForward addTarget:self
                   action:@selector(pushForwardButton:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // RSS登録（非アクティブ）
    posX = posX + iconSize + marginX;
    btnBookmark = [[UIButton alloc] initWithFrame:CGRectMake(posX , posY, iconSize, iconSize)];
    [self changeBookmarkStatus:NO];
    [btnBookmark addTarget:self
                    action:@selector(pushBookmarksButton:)
          forControlEvents:UIControlEventTouchUpInside];
    
    // アップロード（違反報告）
    posX = posX + iconSize + marginX;
    UIButton *btnUpload = [[UIButton alloc] initWithFrame:CGRectMake(posX , posY, iconSize, iconSize)];
    [btnUpload setBackgroundImage:[[UIImage imageNamed:@"Upload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                         forState:UIControlStateNormal];
    [self changeBookmarkStatus:NO];
    [btnUpload addTarget:self
                  action:@selector(pushUploadButton:)
        forControlEvents:UIControlEventTouchUpInside];

    [customToolBar addSubview:btnRefresh];
    [customToolBar addSubview:btnBack];
    [customToolBar addSubview:btnForward];
    [customToolBar addSubview:btnBookmark];
    [customToolBar addSubview:btnUpload];
    [self.view addSubview:customToolBar];
}

- (void)changeBookmarkStatus:(BOOL)active
{
    if (active) {
        [btnBookmark setBackgroundImage:[[UIImage imageNamed:@"RSS"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                               forState:UIControlStateNormal];
    } else {
        tmpChannel = [[Channel alloc] init]; // リセット
        [btnBookmark setBackgroundImage:[UIImage imageNamed:@"RSS"]
                               forState:UIControlStateNormal];
    }
}


#pragma mark - Scroll
// ツールバースクロール
- (void)toolBarDidScroll:(float)move
{
    float screenSizeHeight = (STATUS_BAR_FRAME.size.height == 40) ? SCREEN.size.height - 20 : SCREEN.size.height;
    CGRect frame = customToolBar.frame;
    frame.origin.y += move;
    float bottom = screenSizeHeight;
    float top = bottom - customToolBar.frame.size.height;
    if (frame.origin.y <= top) {
        frame.origin.y = top;
    } else if (frame.origin.y > bottom) {
        frame.origin.y = bottom;
    }
    customToolBar.frame = frame;
}


#pragma mark - Animation
// ツールバー上下アニメーション
- (void)animationToolBarUp
{
    float screenSizeHeight = (STATUS_BAR_FRAME.size.height == 40) ? SCREEN.size.height - 20 : SCREEN.size.height;
    CGRect frame = customToolBar.frame;
    [UIView animateWithDuration:kEXTBrowserAnimationDuration
                     animations:^{
                         [customToolBar setFrame:CGRectMake(0,
                                                            screenSizeHeight - frame.size.height,
                                                            frame.size.width,
                                                            frame.size.height
                                                            )];
                     }];
}
- (void)animationToolBarDown
{
    float screenSizeHeight = (STATUS_BAR_FRAME.size.height == 40) ? SCREEN.size.height - 20 : SCREEN.size.height;
    CGRect frame = customToolBar.frame;
    [UIView animateWithDuration:kEXTBrowserAnimationDuration
                     animations:^{
                         [customToolBar setFrame:CGRectMake(0,
                                                            screenSizeHeight,
                                                            frame.size.width,
                                                            frame.size.height
                                                            )];
                     }];
}


#pragma mark - ScrollView Delegate
// スクロール開始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollBeginingPoint = [scrollView contentOffset];
    scrollType          = BrowserScrollTypeDefault;
}

// スクロール中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentPoint = [scrollView contentOffset];
    float move = currentPoint.y - scrollBeforePoint.y;
    scrollBeforePoint = currentPoint;

    // 上下スクロール判断
    if (scrollBeginingPoint.y > currentPoint.y) {
        if (scrollType != BrowserScrollTypeDown) {
            NSLog(@"Scroll : Down");
            scrollType = BrowserScrollTypeDown;
            [self setContentHeightWithBottom:NO];
        }
    } else if (scrollBeginingPoint.y < currentPoint.y) {
        if (scrollType != BrowserScrollTypeUp) {
            NSLog(@"Scroll : UP");
            scrollType = BrowserScrollTypeUp;
        }
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)){
            NSLog(@"Scroll : End of Page");
            [self setContentHeightWithBottom:YES];
        }
    }

    // 手動スクロール
    [self toolBarDidScroll:move];
}

// スクロール終了（フリック）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    switch (scrollType) {
        case BrowserScrollTypeUp:
            [self animationToolBarDown];
            break;
        case BrowserScrollTypeDown:
            [self animationToolBarUp];
            break;
        default:
            break;
    }
}

// スクロール終了（加速なし）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    switch (scrollType) {
        case BrowserScrollTypeUp:
            [self animationToolBarDown];
            break;
        case BrowserScrollTypeDown:
            [self animationToolBarUp];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
