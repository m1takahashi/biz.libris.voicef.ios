//
// UserInfo.m
//

#import "UserInfo.h"

@implementation UserInfo

static NSString *UI_AD_BLOCK        = @"ui_ad_block";
static NSString *UI_EULA            = @"ui_eula";
static NSString *UI_SITE_LIST_INIT  = @"ui_site_list_init";
static NSString *UI_SITE_LIST       = @"ui_site_list";
static NSString *UI_COACHMARKS_FAVORITE = @"ui_coachmarks_favorite";

// 広告ブロック
+(BOOL)adBlock
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:@{UI_AD_BLOCK : @(YES)}];
    return [ud boolForKey:UI_AD_BLOCK];
}
+(void)setAdBlock:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:UI_AD_BLOCK];
}

// 利用規約(EULA)
+(BOOL)eula
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:@{UI_EULA : @(NO)}];
    return [ud boolForKey:UI_EULA];
}
+(void)setEula:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:UI_EULA];
}

// サイト一覧初期化フラグ
+(BOOL)siteListInit
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:@{UI_SITE_LIST_INIT  : @(NO)}];
    return [ud boolForKey:UI_SITE_LIST_INIT ];
}
+(void)setSiteListInit:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:UI_SITE_LIST_INIT ];
}

// サイト一覧（カンマ区切りの文字列）
+(NSString*)siteList
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:UI_SITE_LIST];
}
+(void)setSiteList:(NSString*)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:UI_SITE_LIST];
}

// CoachMarks お気に入り
+(BOOL)coachmarksFavorite
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:@{UI_COACHMARKS_FAVORITE : @(NO)}];
    return [ud boolForKey:UI_COACHMARKS_FAVORITE];
}
+(void)setCoachmarksFavorite:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:UI_COACHMARKS_FAVORITE];
}

+(void)synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
