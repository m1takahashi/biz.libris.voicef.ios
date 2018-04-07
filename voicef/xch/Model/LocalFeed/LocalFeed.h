//
//  LocalFeed.h
//

#import <Foundation/Foundation.h>
#import "Const.h"
#import "FeedEntry.h"
#import "Channel.h"
#import "DaoChannel.h"
#import "Entry.h"
#import "DaoEntry.h"
#import "MWFeedParser.h"

@interface LocalFeed : NSObject  <MWFeedParserDelegate> {
	
	// Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;

    DaoChannel *daoChannel;
    DaoEntry *daoEntry;
    
    NSUInteger channelId;
}


- (BOOL)addChannel:(Channel *)channelData;
- (BOOL)removeChannel:(NSUInteger)channelId;
- (BOOL)update;
- (BOOL)updateChannel:(Channel*)params;


@end
