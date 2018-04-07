//
//  History.m
//

#import "History.h"

@implementation History

- (id)initWithHistoryTitle:(NSString *)title historyUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        [self setHistoryTitle:title];
        [self setHistoryUrl:url];
    }
    return self;
}

- (void)setHistoryTitle:(NSString *)str
{
    historyTitle = str;
}
- (NSString *)historyTitle
{
    return historyTitle;
}

- (void)setHistoryUrl:(NSString *)str
{
    historyUrl = str;
}

- (NSString *)historyUrl
{
    return historyUrl;
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc]initWithFormat:@"Title : %@, URL : %@",
                                   historyTitle,
                                   historyUrl];
    return descriptionString;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:historyTitle forKey:@"historyTitle"];
    [encoder encodeObject:historyUrl forKey:@"historyUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setHistoryTitle:[decoder decodeObjectForKey:@"historyTitle"]];
        [self setHistoryUrl:[decoder decodeObjectForKey:@"historyUrl"]];
    }
    return self;
}

@end
