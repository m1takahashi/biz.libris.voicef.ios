//
//  HistoryStore.m
//

#import "FileHelpers.h"
#import "HistoryStore.h"
#import "History.h"

static HistoryStore *defaultStore = nil;

@implementation HistoryStore

+ (HistoryStore *)defaultStore
{
    if (!defaultStore) {
        // シングルトンを生成
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// 別のインスタンス生成を防ぐ
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init
{
    if (defaultStore) {
        return defaultStore;
    }
    self = [super init];
    return self;
}

- (NSArray *)allHistorys
{
    // allHistorysが必ず生成されるようにする
    [self fetchHistoryIfNecessary];
    return allHistorys;
}

- (void)addHistory:(History *)bkm
{
    // allHistorysが必ず生成されるようにする
    [self fetchHistoryIfNecessary];
    [allHistorys addObject:bkm];
}

- (void)removeHistory:(History *)b
{
    [allHistorys removeObjectIdenticalTo:b];
}

// 全件削除
- (void)removeAllHistory
{
    [allHistorys removeAllObjects];
}

- (void)moveHistoryAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // 移動するオブジェクトへのポインタを取得する
    History *b = [allHistorys objectAtIndex:from];
    // 配列から、bを削除、
    [allHistorys removeObjectAtIndex:from];
    // 新しい位置にbを再挿入
    [allHistorys insertObject:b atIndex:to];
}

- (NSString *)historyArchivePath
{
    // Sandbox/Documents/history.data
    return pathInDocumentDirectory(@"history.data");
}

- (BOOL)saveChanges
{
    NSString *path = [self historyArchivePath];
    return [NSKeyedArchiver archiveRootObject:allHistorys
                                       toFile:path];
}

- (void)fetchHistoryIfNecessary
{
    // allHistorys配列を持っていなければファイルシステムから読み込みを試みる
    if (!allHistorys) {
        NSString *path = [self historyArchivePath];
        allHistorys = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    // ファイルシステムから読み込んでみて、まだ配列がなければ新規に作成する
    if (!allHistorys) {
        allHistorys = [[NSMutableArray alloc] init];
    }
}
@end
