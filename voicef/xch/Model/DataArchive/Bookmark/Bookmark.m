//
//  Bookmark.m
//

#import "Bookmark.h"

@implementation Bookmark

- (id)initWithBookmarkTitle:(NSString *)title bookmarkUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        [self setBookmarkTitle:title];
        [self setBookmarkUrl:url];
    }
    return self;
}

- (void)setBookmarkTitle:(NSString *)str
{
    bookmarkTitle = str;
}
- (NSString *)bookmarkTitle
{
    return bookmarkTitle;
}

- (void)setBookmarkUrl:(NSString *)str
{
    bookmarkUrl = str;
}

- (NSString *)bookmarkUrl
{
    return bookmarkUrl;
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc]initWithFormat:@"Title : %@, URL : %@",
                                   bookmarkTitle,
                                   bookmarkUrl];
    return descriptionString;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:bookmarkTitle forKey:@"bookmarkTitle"];
    [encoder encodeObject:bookmarkUrl forKey:@"bookmarkUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setBookmarkTitle:[decoder decodeObjectForKey:@"bookmarkTitle"]];
        [self setBookmarkUrl:[decoder decodeObjectForKey:@"bookmarkUrl"]];
    }
    return self;
}

@end
