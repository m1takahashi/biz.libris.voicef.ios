//
//  LocalFeed.m
//  ローカルRSS記事更新クラス
//

#import "LocalFeed.h"
#import "MWFeedParser.h"
#import "MWFeedItem.h"
#import "MWFeedInfo.h"

@implementation LocalFeed

- (id)init
{
    if (self = [super init]) {
        daoChannel  = [[DaoChannel alloc] init];
        daoEntry    = [[DaoEntry alloc] init];
        parsedItems = [NSMutableArray array];
        channelId   = 0;
    }
    return self;
}

// チャンネル追加
- (BOOL)addChannel:(Channel *)channelData
{
    Channel *channel = [daoChannel add:channelData];
    if (channel.channelId <= 0) {
        return NO;
    }
    channelId = channel.channelId;
    
    // フィード取得
    NSURL *url = [[NSURL alloc] initWithString:channel.rssUrl];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeSynchronously; // 同期処理
    if([feedParser parse]) {
        NSLog(@"Parse : YES");
    } else {
        NSLog(@"Parse : NO");
        return NO;
    }
    return YES;
}

// チャンネル削除
// 記事データ＆チャンネルデータも削除
- (BOOL)removeChannel:(NSUInteger)cid
{
    // 記事削除
    if ([daoEntry removeByChannelId:cid] == NO) {
        return NO;
    }
    
    // チャンネル削除
    if([daoChannel remove:cid] == NO) {
        return NO;
    }
    
    return YES;
}

// 個別チャンネルの記事更新
- (BOOL)updateChannel:(Channel*)params
{
    // 一旦削除
    [daoEntry removeByChannelId:params.channelId];
    // 記事再取得
    NSURL *url = [[NSURL alloc] initWithString:params.rssUrl];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeSynchronously; // 同期処理
    if([feedParser parse]) {
        NSLog(@"Parse : YES");
    } else {
        NSLog(@"Parse : NO");
    }
    return YES;
}

// 全更新
- (BOOL)update
{
    // 全削除（中途半端に残ったものがないように）
    [daoEntry removeAll];
    
    // フィード一覧取得
    NSArray *channelList = [daoChannel channels];

    for (int i = 0; i < [channelList count]; i++) {
        Channel *channel = [channelList objectAtIndex:i];
        channelId = channel.channelId;
        
        // 最新の記事を取得
        NSURL *url = [[NSURL alloc] initWithString:channel.rssUrl];
        feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
        feedParser.delegate = self;
        feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
        feedParser.connectionType = ConnectionTypeSynchronously; // 同期処理
        if([feedParser parse]) {
            NSLog(@"Parse : YES");
        } else {
            NSLog(@"Parse : NO");
        }
    }
    return YES;
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
    // データ配列初期化
    parsedItems = [NSMutableArray array];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
//	NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"didParseFeedItem");
	if (item) [parsedItems addObject:item];
}


- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    NSLog(@"feedParserDidFinish");
    for (int i = 0; i < [parsedItems count]; i++) {
        MWFeedItem *item = [parsedItems objectAtIndex:i];
        
        // 広告記事の除去
        if ([item.title hasPrefix:@"PR"]) {
            NSLog(@"除去対象記事(PR) : %@", item.title);
            continue;
        }
        if ([item.title hasPrefix:@"AD"]) {
            NSLog(@"除去対象記事(AD) : %@", item.title);
            continue;
        }

        // 画像URL抽出
        NSString *pattern = @"(https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+)";
        NSRange match = [
                         item.summary rangeOfString:pattern
                         options:NSRegularExpressionSearch
                         ];
        NSString *imgSrc;
        if (match.location != NSNotFound) {
            imgSrc = [item.summary substringWithRange:match];
        } else {
            imgSrc = @"";
        }

        // 現在の時間をセット（記事の日時がとれないときのため）
        NSDate *date = [NSDate date];
        NSUInteger timestamp = [date timeIntervalSince1970];
        if (item.date != nil) {
            timestamp = [item.date timeIntervalSince1970];
        }

        Entry *entry = [[Entry alloc] init];
        [entry setChannelId:channelId];
        [entry setTitle:item.title];
        [entry setLink:item.link];
        [entry setImageUrl:imgSrc];
        [entry setDateTimestamp:timestamp];
        NSLog(@"＊＊＊ : %@", [entry description]);
        
        [daoEntry add:entry];
    }
}

@end
