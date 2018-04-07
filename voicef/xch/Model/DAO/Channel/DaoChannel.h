//
//  DaoChannel.h
//

#import <Foundation/Foundation.h>
#import "Const.h"

@class Channel;

@interface DaoChannel : NSObject

- (Channel*)add:(Channel*)channel;
- (NSArray*)channels;
- (BOOL)remove:(NSUInteger)channelId;
- (BOOL)update:(Channel*)channel;
- (Channel*)getByChannelId:(NSUInteger)channelId;
- (BOOL)isRssUrl:(NSString *)rssURL;


@end
