//
//  Bookmark.h
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject <NSCoding>
{
    NSString *bookmarkTitle;
    NSString *bookmarkUrl;
}

- (id)initWithBookmarkTitle:(NSString *)title bookmarkUrl:(NSString *)url;
- (void)setBookmarkTitle:(NSString *)str;
- (NSString *)bookmarkTitle;
- (void)setBookmarkUrl:(NSString *)str;
- (NSString *)bookmarkUrl;
- (NSString *)description;


@end
