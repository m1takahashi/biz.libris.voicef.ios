//
//  DaoEntry.h
//

#import <Foundation/Foundation.h>
#import "Const.h"

@class Entry;

@interface DaoEntry : NSObject

- (Entry*)add:(Entry*)entry;
- (NSArray*)entries;
- (BOOL)removeAll;
- (BOOL)removeByChannelId:(NSUInteger)channelId;

//- (BOOL)remove:(NSInteger)entryId;
//- (BOOL)update:(Entry*)entry;

@end
