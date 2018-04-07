//
//  Channel.h
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property (nonatomic, assign) NSUInteger channelId;
@property (nonatomic,   copy) NSString *author;
@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *blogUrl;
@property (nonatomic,   copy) NSString *rssUrl;

- (NSString *)description;

@end
