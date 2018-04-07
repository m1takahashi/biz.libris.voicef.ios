//
//  BookmarkStore.h
//

#import <Foundation/Foundation.h>

@class Bookmark;

@interface BookmarkStore : NSObject
{
    NSMutableArray *allBookmarks;
}

+ (BookmarkStore *)defaultStore;
- (NSArray *)allBookmarks;
- (void)addBookmark:(Bookmark *)b;
- (void)removeBookmark:(Bookmark *)b;
- (void)moveBookmarkAtIndex:(int)from toIndex:(int)to;
- (NSString *)bookmarkArchivePath;
- (BOOL)saveChanges;
- (void)fetchBookmarkIfNecessary;

@end
