//
//  DaoEntry.m
//

#import "DaoEntry.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Entry.h"

#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS entry (id INTEGER PRIMARY KEY AUTOINCREMENT, channel_id INTEGER, title TEXT, description TEXT, link TEXT, image_url TEXT, date_timestamp INTEGER);"
#define SQL_INSERT @"INSERT INTO entry (channel_id, title, description, link, image_url, date_timestamp) VALUES (?, ?, ?, ?, ?, ?);"
#define SQL_SELECT @"SELECT id, channel_id, title, description, link, image_url, date_timestamp FROM entry ORDER BY date_timestamp DESC;" // TODO: ORDER
#define SQL_DELETE_ALL @"DELETE FROM entry;"
#define SQL_DELETE_BY_CHANNEL @"DELETE FROM entry WHERE channel_id = ?;"

//#define SQL_DELETE @"DELETE FROM entry WHERE id = ?;"


@interface DaoEntry()
@property (nonatomic, copy) NSString* dbPath; //! データベース　ファイルへのパス

- (FMDatabase*)getConnection;
+ (NSString*)getDbFilePath;
@end

@implementation DaoEntry

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
- (Entry*)add:(Entry*)entry
{
	FMDatabase* db = [self getConnection];
	[db open];

	[db setShouldCacheStatements:YES];
	if ([db executeUpdate:SQL_INSERT,
         [NSNumber numberWithInteger:entry.channelId],
         entry.title,
         entry.description,
         entry.link,
         entry.imageUrl,
         [NSNumber numberWithUnsignedInteger:entry.dateTimestamp]
         ]){
		entry.entryId = [db lastInsertRowId];
	} else {
		entry = nil;
	}
	[db close];
	return entry;
}

// 取得
- (NSArray*)entries
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	FMResultSet *results     = [db executeQuery:SQL_SELECT];
	NSMutableArray *entries = [[NSMutableArray alloc] initWithCapacity:0];
	
	while ([results next]){
		Entry *entry        = [[Entry alloc] init];
		entry.entryId       = [results intForColumnIndex:0];
		entry.channelId     = [results intForColumnIndex:1];
		entry.title         = [results stringForColumnIndex:2];
		entry.link          = [results stringForColumnIndex:4];
		entry.imageUrl      = [results stringForColumnIndex:5];
		entry.dateTimestamp = [results intForColumnIndex:6];
		[entries addObject:entry];
	}
	[db close];
	return entries;
}

// 全削除
- (BOOL)removeAll
{
	FMDatabase* db = [self getConnection];
	[db open];
	BOOL isSucceeded = [db executeUpdate:SQL_DELETE_ALL];
	[db close];
	return isSucceeded;
}

// 削除（カテゴリ指定）
- (BOOL)removeByChannelId:(NSUInteger)channelId
{
	FMDatabase* db = [self getConnection];
	[db open];
	BOOL isSucceeded = [db executeUpdate:SQL_DELETE_BY_CHANNEL, [NSNumber numberWithInteger:channelId]];
	[db close];
	return isSucceeded;
}

// 編集
/*
- (BOOL)update:(Entry*)entry
{
	FMDatabase* db = [self getConnection];
	[db open];
	BOOL isSucceeded = [db executeUpdate:SQL_UPDATE,
                        entry.channelId,
                        entry.title,
                        entry.description,
                        entry.link,
                        entry.imageUrl,
                        [NSNumber numberWithInteger:entry.entryId]
                        ];
	[db close];
	return isSucceeded;
}
 */

#pragma mark - Private methods

// コネクション取得
- (FMDatabase *)getConnection
{
	if (self.dbPath == nil) {
		self.dbPath =  [DaoEntry getDbFilePath];
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
