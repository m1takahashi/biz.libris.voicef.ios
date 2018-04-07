//
//  FeedEntry.h
//  サーバー側のd_feed_entryの構造を定義
//

#import <Foundation/Foundation.h>

@interface FeedEntry : NSObject

// Entry
@property (nonatomic, assign) NSInteger entryId;
@property (nonatomic, assign) NSInteger channelId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *twCount;
@property (nonatomic, copy) NSString *dateModified;
@property (nonatomic, copy) NSString *siteTitle;

- (id)initWithObject:(NSDictionary *)obj;
- (NSString *)description;

@end
