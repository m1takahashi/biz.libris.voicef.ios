//
//  FeedListViewController.m
//

#import "FeedListViewController.h"
#import "Channel.h"
#import "DaoChannel.h"

@interface FeedListViewController ()
{
    NSMutableArray *channelList;
    DaoChannel *daoChannel;
}

@end

@implementation FeedListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                   target:self
                                                                                   action:@selector(pushEditButton:)];
        [[self navigationItem] setRightBarButtonItem:itemRight];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing = YES; // 編集状態でのセルのタッチを可
    
    daoChannel = [[DaoChannel alloc] init];
    channelList = [daoChannel channels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// 編集
-(void)pushEditButton:(id)sender
{
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                   target:self
                                                                                   action:@selector(pushEditButton:)];
        [[self navigationItem] setRightBarButtonItem:itemRight];
    } else {
        [self.tableView setEditing:YES animated:YES];
        UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(pushEditButton:)];
        [[self navigationItem] setRightBarButtonItem:itemRight];
    }
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
    return [channelList count];
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
    Channel *channel = [channelList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [channel title];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/**
 * 選択 ブラウザを表示（pop -> push）
 * http://stackoverflow.com/questions/410471/how-can-i-pop-a-view-from-a-uinavigationcontroller-and-replace-it-with-another-i
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Channel *channel = [channelList objectAtIndex:[indexPath row]];
    NSLog(@"チャンネル情報 : %@", [channel description]);
    
    if (self.tableView.editing) {
        NSLog(@"編集状態で、セルが選択された。");
        FeedEditFormViewController *view = [[FeedEditFormViewController alloc] init];
        [view setParamChannelId:[NSNumber numberWithUnsignedInteger:channel.channelId]];
        [self presentViewController:view
                           animated:YES
                         completion:nil];
        
    } else {
        [APP_DELEGATE switchCenterView:kExtCenterViewTypeBrowser
                                params:@{@"ParamUrl":channel.blogUrl}];
    }
}

// 削除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Channel *channel = [channelList objectAtIndex:[indexPath row]];
        NSLog(@"削除対象ID : %ld", channel.channelId);

        // 読み込み済みリストから削除
        [channelList removeObjectAtIndex:[indexPath row]];

        // ローカルデータ削除
        LocalFeed *localFeed = [[LocalFeed alloc] init];
        [localFeed removeChannel:channel.channelId];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Nothing to do.
    }
}

@end
