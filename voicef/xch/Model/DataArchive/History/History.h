//
//  History.h
//

#import <Foundation/Foundation.h>

@interface History : NSObject <NSCoding>
{
    NSString *historyTitle;
    NSString *historyUrl;
}

- (id)initWithHistoryTitle:(NSString *)title historyUrl:(NSString *)url;
- (void)setHistoryTitle:(NSString *)str;
- (NSString *)historyTitle;
- (void)setHistoryUrl:(NSString *)str;
- (NSString *)historyUrl;

@end
