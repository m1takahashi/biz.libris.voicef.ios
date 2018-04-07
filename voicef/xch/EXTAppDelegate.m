//
//  EXTAppDelegate.m
//

#import "EXTAppDelegate.h"
#import "MMDrawerController.h"
#import "SettingViewController.h"
#import "FeedViewController.h"
#import "BrowserViewController.h"
#import "DrawerViewController.h"
#import "MMDrawerController.h"
#import "MMNavigationController.h"
#import "SearchSyllabaryTopViewController.h"
#import "SearchKeywordViewController.h"


@interface EXTAppDelegate ()
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, strong) UINavigationController *navFeedViewController;
@property (nonatomic, strong) UINavigationController *navSettingViewController;
@property (nonatomic, strong) UINavigationController *navBrowserViewController;
@property (nonatomic, strong) UINavigationController *navSearchSyllabaryViewController;
@property (nonatomic, strong) UINavigationController *navSearchKeywordViewController;
@end

@implementation EXTAppDelegate
@synthesize navFeedViewController;
@synthesize navSettingViewController;
@synthesize navSearchSyllabaryViewController;
@synthesize navSearchKeywordViewController;
@synthesize navBrowserViewController;
@synthesize inReview;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 内部フィード
    FeedViewController *feedViewController = [[FeedViewController alloc] init];
    navFeedViewController = [[MMNavigationController alloc] initWithRootViewController:feedViewController];

    // 設定
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    navSettingViewController = [[MMNavigationController alloc] initWithRootViewController:settingViewController];
    
    // 五十音順
    SearchSyllabaryTopViewController *searchSyllabaryViewController  = [[SearchSyllabaryTopViewController alloc] init];
    navSearchSyllabaryViewController = [[MMNavigationController alloc] initWithRootViewController:searchSyllabaryViewController];

    // キーワード検索
    SearchKeywordViewController *searchKeywordViewController  = [[SearchKeywordViewController alloc] init];
    navSearchKeywordViewController = [[MMNavigationController alloc] initWithRootViewController:searchKeywordViewController];
    
    // メニューは入れ替わらない
    DrawerViewController *leftSideDrawerViewController = [[DrawerViewController alloc] init];
    UINavigationController * leftSideNavController = [[MMNavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navFeedViewController
                                                            leftDrawerViewController:leftSideNavController];
    [self.drawerController setShowsShadow:YES];

    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:240.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
    [self.window makeKeyAndVisible];
    
    // レビュー中（初期化）
    inReview = NO;
    
    // ネットワーク確認
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    if (status != NotReachable) {
        [self getServerSetting];
    }

    return YES;
}

// センター入れ替え
-(void)switchCenterView:(NSUInteger)type params:(NSDictionary*)value
{
    if (type == kExtCenterViewTypeSetting) {
        // 設定
        [self.drawerController setCenterViewController:navSettingViewController];
        
    } else if (type == kExtCenterViewTypeSearchSyllabary) {
        // 五十音
        [self.drawerController setCenterViewController:navSearchSyllabaryViewController];
        
    } else if (type == kExtCenterViewTypeSearchKeyword) {
        // キーワード検索
        [self.drawerController setCenterViewController:navSearchKeywordViewController];
        
    } else if (type == kExtCenterViewTypeFeed) {
        [self.drawerController setCenterViewController:navFeedViewController];
    } else if (type == kExtCenterViewTypeBrowser) {
        BrowserViewController *browserViewController  = [[BrowserViewController alloc] init];
        [browserViewController setParamUrl:[value objectForKey:@"ParamUrl"]];
        navBrowserViewController = [[MMNavigationController alloc] initWithRootViewController:browserViewController];
        [self.drawerController setCenterViewController:navBrowserViewController];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 履歴保存
    if ([[HistoryStore defaultStore] saveChanges]) {
        NSLog(@"History save Success.");
    } else {
        NSLog(@"History save Failed.");
    }
    
    // ブックマーク保存
    if ([[BookmarkStore defaultStore] saveChanges]) {
        NSLog(@"Bookmark save Success.");
    } else {
        NSLog(@"Bookmark save Failed.");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self getServerSetting];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

// サーバーから、グローバル設定を取得する
- (void)getServerSetting
{
    NSURL *url = [NSURL URLWithString:EXT_SETTING_URL_FORMAT];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                // TODO: エラー処理
                                                if (error) {
                                                    [NSException raise:@"Exception downloading data"
                                                                format:@"%@", error.localizedDescription];
                                                }
                                                
                                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                NSDictionary *dic = [json objectForKey:@"data"];
                                                NSLog(@"%@", dic);
                                                NSInteger currentBuild = [[dic objectForKey:@"current_build"] integerValue];
                                                NSInteger build = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];

                                                NSLog(@"---- App Build : %ld, Server(Current) Build : %ld ----", build, currentBuild);

                                                
                                                //
                                                if (build > currentBuild) {
                                                    NSLog(@"審査中");
                                                    inReview = YES;
                                                    
                                                }
                                                
                                            }];
    [dataTask resume];

}

@end
