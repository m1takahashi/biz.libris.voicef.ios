//
//  Entry.h
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject

@property (nonatomic, assign) NSInteger entryId;
@property (nonatomic, assign) NSInteger channelId;
@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *link;
@property (nonatomic,   copy) NSString *imageUrl;
@property (nonatomic, assign) NSUInteger dateTimestamp;

- (NSString *)description;

@end
