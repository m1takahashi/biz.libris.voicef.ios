//
//  Channel.m
//

#import "Channel.h"

@implementation Channel

@synthesize channelId;
@synthesize author;
@synthesize title;
@synthesize blogUrl;
@synthesize rssUrl;

- (NSString *)description
{
    NSString *str =  [NSString stringWithFormat:@"ChannelID : %ld, Author : %@, Title : %@, BlogURL : %@, RssURL : %@",
                      channelId,
                      author,
                      title,
                      blogUrl,
                      rssUrl
                      ];
    return str;
}

@end
