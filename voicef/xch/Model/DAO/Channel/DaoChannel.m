//
//  DaoChannel.m
//

#import "DaoChannel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Channel.h"

#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS channel (id INTEGER PRIMARY KEY AUTOINCREMENT, author TEXT, title TEXT, blogUrl TEXT, rssUrl TEXT);"
#define SQL_INSERT @"INSERT INTO channel (author, title, blogUrl, rssUrl) VALUES (?, ?, ?, ?);"
#define SQL_UPDATE @"UPDATE channel SET author = ?, title = ?, blogurl = ?, rssurl = ? WHERE id = ?;"
#define SQL_SELECT @"SELECT id, author, title, blogUrl, rssUrl FROM channel;"
#define SQL_SELECT_BY_CHANNELID @"SELECT id, author, title, blogUrl, rssUrl FROM channel WHERE id = ?;"
#define SQL_DELETE @"DELETE FROM channel WHERE id = ?;"
#define SQL_IS_RSSURL @"SELECT id, author, title, blogUrl, rssUrl FROM channel WHERE rssUrl = ?;"


@interface DaoChannel()
@property (nonatomic, copy) NSString* dbPath; //! データベース　ファイルへのパス

- (FMDatabase*)getConnection;
+ (NSString*)getDbFilePath;
@end

@implementation DaoChannel

@synthesize dbPath;

#pragma mark - Lifecycle methods

// 初期化
- (id)init
{
	self = [super init];
	if( self )
	{
		FMDatabase* db = [self getConnection];
		[db open];
		[db executeUpdate:SQL_CREATE];
		[db close];
	}

	return self;
}

#pragma mark - Public methods

// 追加
- (Channel*)add:(Channel*)channel
{
	FMDatabase* db = [self getConnection];
	[db open];

	[db setShouldCacheStatements:YES];
	if ([db executeUpdate:SQL_INSERT, channel.author, channel.title, channel.blogUrl, channel.rssUrl]){
		channel.channelId = [db lastInsertRowId];
	} else {
		channel = nil;
	}
	[db close];
	return channel;
}

// 編集
- (BOOL)update:(Channel*)channel
{
	FMDatabase* db = [self getConnection];
	[db open];
	BOOL isSucceeded = [db executeUpdate:SQL_UPDATE,
                        channel.author,
                        channel.title,
                        channel.blogUrl,
                        channel.rssUrl,
                        [NSNumber numberWithUnsignedInteger:channel.channelId]
                        ];
	[db close];
	return isSucceeded;
}

// 削除
- (BOOL)remove:(NSUInteger)channelId
{
	FMDatabase* db = [self getConnection];
	[db open];
	BOOL isSucceeded = [db executeUpdate:SQL_DELETE, [NSNumber numberWithUnsignedInteger:channelId]];
	[db close];
	return isSucceeded;
}

// 一覧取得
- (NSArray*)channels
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	FMResultSet *results     = [db executeQuery:SQL_SELECT];
	NSMutableArray *channels = [[NSMutableArray alloc] initWithCapacity:0];
	
	while ([results next]){
		Channel *channel = [[Channel alloc] init];
		channel.channelId   = [results intForColumnIndex:0];
		channel.author      = [results stringForColumnIndex:1];
		channel.title       = [results stringForColumnIndex:2];
		channel.blogUrl     = [results stringForColumnIndex:3];
		channel.rssUrl      = [results stringForColumnIndex:4];
		[channels addObject:channel];
	}
	[db close];
	return channels;
}

// 一件取得
- (Channel*)getByChannelId:(NSUInteger)channelId
{
    Channel *channel = [[Channel alloc] init];
	FMDatabase* db = [self getConnection];
	[db open];
	FMResultSet *results = [db executeQuery:SQL_SELECT_BY_CHANNELID, [NSNumber numberWithUnsignedInteger:channelId]];

    while ([results next]){
		channel.channelId   = [results intForColumnIndex:0];
		channel.author      = [results stringForColumnIndex:1];
		channel.title       = [results stringForColumnIndex:2];
		channel.blogUrl     = [results stringForColumnIndex:3];
		channel.rssUrl      = [results stringForColumnIndex:4];
        break;
    }
    [db close];
    return channel;
}

// フィードURL存在確認
- (BOOL)isRssUrl:(NSString *)rssURL
{
    BOOL flag;
	FMDatabase* db = [self getConnection];
	[db open];
	
	FMResultSet *results     = [db executeQuery:SQL_IS_RSSURL, rssURL];
    if ([results next] == NO) {
        flag = NO;
    } else {
        flag = YES;
    }
	return flag;
}


#pragma mark - Private methods

// コネクション取得
- (FMDatabase *)getConnection
{
	if (self.dbPath == nil) {
		self.dbPath =  [DaoChannel getDbFilePath];
	}
	return [FMDatabase databaseWithPath:self.dbPath];
}

// ファイルパス取得
+ (NSString*)getDbFilePath
{
	NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* dir   = [paths objectAtIndex:0];
	return [dir stringByAppendingPathComponent:DB_FILE_NAME];
}

@end
