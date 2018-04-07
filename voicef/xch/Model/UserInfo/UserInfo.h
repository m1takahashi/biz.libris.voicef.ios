//
//  ユーザー設定保持クラス
//  NSUserDefaultをWrap
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+(BOOL)adBlock;
+(void)setAdBlock:(BOOL)value;

+(BOOL)eula;
+(void)setEula:(BOOL)value;

+(BOOL)siteListInit;
+(void)setSiteListInit:(BOOL)value;

+(NSString*)siteList;
+(void)setSiteList:(NSString*)value;

+(BOOL)coachmarksFavorite;
+(void)setCoachmarksFavorite:(BOOL)value;

+ (void)synchronize;

@end
