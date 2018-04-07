//
//  SiteStore.h
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface SiteStore : NSObject
- (id)init;
- (NSString*)getString;
- (BOOL)on:(NSUInteger)siteId;
- (void)changeStatus:(NSUInteger)siteId status:(BOOL)on;
@end
