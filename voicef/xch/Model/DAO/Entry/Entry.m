//
//  Entry.m
//

#import "Entry.h"

@implementation Entry

@synthesize entryId;
@synthesize channelId;
@synthesize title;
@synthesize link;
@synthesize imageUrl;
@synthesize dateTimestamp;

- (NSString *)description
{
    NSString *str =  [NSString stringWithFormat:@"EntryID : %ld, ChannelID : %ld, Title : %@, Link : %@, ImageUrl : %@, DateTimestamp : %ld",
                      entryId,
                      channelId,
                      title,
                      link,
                      imageUrl,
                      dateTimestamp
                      ];
    return str;
}

@end
