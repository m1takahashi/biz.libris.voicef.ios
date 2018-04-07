//
//  BookmarkStore.m
//  bookmark
//

#import "FileHelpers.h"
#import "BookmarkStore.h"
#import "Bookmark.h"

static BookmarkStore *defaultStore = nil;

@implementation BookmarkStore

+ (BookmarkStore *)defaultStore
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

- (NSArray *)allBookmarks
{
    // allBookmarksが必ず生成されるようにする
    [self fetchBookmarkIfNecessary];
    return allBookmarks;
}

- (void)addBookmark:(Bookmark *)bkm
{
    // allBookmarksが必ず生成されるようにする
    [self fetchBookmarkIfNecessary];
    [allBookmarks addObject:bkm];
}

- (void)removeBookmark:(Bookmark *)b
{
    [allBookmarks removeObjectIdenticalTo:b];
}

- (void)moveBookmarkAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // 移動するオブジェクトへのポインタを取得する
    Bookmark *b = [allBookmarks objectAtIndex:from];
    // 配列から、bを削除、
    [allBookmarks removeObjectAtIndex:from];
    // 新しい位置にbを再挿入
    [allBookmarks insertObject:b atIndex:to];
}

- (NSString *)bookmarkArchivePath
{
    // Sandbox/Documents/bookmark.data
    return pathInDocumentDirectory(@"bookmark.data");
}

- (BOOL)saveChanges
{
    NSString *path = [self bookmarkArchivePath];
    return [NSKeyedArchiver archiveRootObject:allBookmarks
                                       toFile:path];
}

- (void)fetchBookmarkIfNecessary
{
    // allBookmarks配列を持っていなければファイルシステムから読み込みを試みる
    if (!allBookmarks) {
        NSString *path = [self bookmarkArchivePath];
        allBookmarks = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    // ファイルシステムから読み込んでみて、まだ配列がなければ新規に作成する
    if (!allBookmarks) {
        allBookmarks = [[NSMutableArray alloc] init];
    }
}
@end
