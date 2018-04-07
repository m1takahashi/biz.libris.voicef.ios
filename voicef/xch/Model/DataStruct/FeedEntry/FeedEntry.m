//
//  FeedEntry.m
//

#import "FeedEntry.h"

@implementation FeedEntry

// Entry
@synthesize entryId;
@synthesize channelId;
@synthesize title;
@synthesize link;
@synthesize imageUrl;
@synthesize twCount;
@synthesize dateModified;
// Channel
@synthesize siteTitle;

- (id)initWithObject:(NSDictionary *)obj
{
    if (self = [super init]) {
        entryId         = [[obj objectForKey:@"id"] intValue];
        channelId       = [[obj objectForKey:@"channel_id"] intValue];
        title           = [obj objectForKey:@"title"];
        link            = [obj objectForKey:@"link"];
        imageUrl        = [obj objectForKey:@"image_url"];
        twCount         = [obj objectForKey:@"tw_count"];
        dateModified    = [obj objectForKey:@"date_modified"];
        siteTitle    = [obj objectForKey:@"site_title"];
    }
    return self;
}

- (NSString *)description
{
    NSString *str =  [NSString stringWithFormat:@"EntryID : %ld, ChannelID : %ld, Title : %@, Link : %@, ImageUrl : %@, ModifiedDate : %@, TWCount : %@",
                      entryId,
                      channelId,
                      title,
                      link,
                      imageUrl,
                      dateModified,
                      twCount
                      ];
    return str;
}
@end