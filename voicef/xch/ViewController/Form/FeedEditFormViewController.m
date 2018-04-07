//
//  FeedListFormViewController.m
//

#import "FeedEditFormViewController.h"
#import "ColorUtil.h"

@interface FeedEditFormViewController ()
{
    DaoChannel *_daoChannel;
    Channel *_channel;
}
@end

@implementation FeedEditFormViewController
@synthesize navigationItem;
@synthesize paramChannelId;
@synthesize textFieldTitle;
@synthesize textFieldBlogUrl;
@synthesize textFieldRssUrl;

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
    // 背景色
//    [self.view setBackgroundColor:[ColorUtil getUIColorFromHex:EXT_NAVIGATION_BAR_COLOR]];
    // ボタン類
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(pushCancelButton:)];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(pushDoneButton:)];
    
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    [[self navigationItem] setRightBarButtonItem:doneButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO
                                       animated:NO];
    
    NSLog(@"ChannelID : %@", paramChannelId);
    NSUInteger channelId = [paramChannelId unsignedIntegerValue];
    _daoChannel = [[DaoChannel alloc] init];
    _channel = [_daoChannel getByChannelId:channelId];
    
    [navigationItem setTitle:_channel.title];
    
    [textFieldTitle setText:_channel.title];
    [textFieldBlogUrl setText:_channel.blogUrl];
    [textFieldRssUrl setText:_channel.rssUrl];
}


- (void)pushCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)pushDoneButton:(id)sender
{
    // Validate
    NSString *title     = textFieldTitle.text;
    NSString *blogUrl   = textFieldBlogUrl.text;
    NSString *rssUrl    = textFieldRssUrl.text;
    
    if ([title isEqualToString:@""]) {
        [self.view makeToast:@"タイトルを入力して下さい。"
                    duration:3.0
                    position:@"center"];
        return;
    }
    if (![blogUrl hasPrefix:@"http://"] && ![blogUrl hasPrefix:@"https://"] ) {
        [self.view makeToast:@"ブログURLが正しくありません。"
                    duration:3.0
                    position:@"center"];
        return;
    }
    if (![rssUrl hasPrefix:@"http://"] && ![rssUrl hasPrefix:@"https://"] ) {
        [self.view makeToast:@"フィードURLが正しくありません。"
                    duration:3.0
                    position:@"center"];
        return;
    }
    
    
    NSLog(@"更新前 : %@", [_channel description]);
    // チャンネル情報更新
    [_channel setTitle:title];
    [_channel setBlogUrl:blogUrl];
    [_channel setRssUrl:rssUrl];
    NSLog(@"更新後 : %@", [_channel description]);
    
    if ([_daoChannel update:_channel]) {
        NSLog(@"チャンネル情報を更新しました。");
    } else {
        NSLog(@"チャンネル情報の更新に失敗しました。");
    }
    
    // 記事更新 TODO: ここで更新するとおかしくなる
    /*
    LocalFeed *localFeed = [[LocalFeed alloc] init];
    [localFeed updateChannel:_channel];
     */

    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
