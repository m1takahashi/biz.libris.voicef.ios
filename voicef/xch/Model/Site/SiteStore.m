//
//  SiteStore.m
//

#import "SiteStore.h"

@implementation SiteStore
{
    NSMutableDictionary *selectedDic;
}


- (id)init
{
    self = [super init];
    
    selectedDic = [NSMutableDictionary dictionary];
    NSArray *array;
    
    if (![UserInfo siteListInit]) {
        NSLog(@"サイト選択リストを初期化します。");
        NSString *p = [[NSBundle mainBundle] pathForResource:@"SiteList" ofType:@"plist"];
        array = [NSArray arrayWithContentsOfFile:p]; // NSNumber
        NSString *str = [array componentsJoinedByString:@","];
        // 保存
        [UserInfo setSiteList:str];
        [UserInfo setSiteListInit:YES]; // 初期化済み
    } else {
        NSLog(@"ユーザーデフォルトから初期化します。");
        NSString *str = [UserInfo siteList];
        array = [str componentsSeparatedByString:@","];
    }
    // メンバ変数に展開
    for (int i = 0; i < array.count; i++) {
        NSLog(@"SiteID : %@", [array objectAtIndex:i]);
        // Key:SiteID, Value:SiteID
        NSString *number = [array objectAtIndex:i];
        [selectedDic setObject:number forKey:number];
    }
    return self;
}

// カンマ区切りの文字列として取得
- (NSString*)getString
{
    NSArray *array = [selectedDic allKeys];
    return [array componentsJoinedByString:@","];
}

// 指定のサイトIDが選択状態か
- (BOOL)on:(NSUInteger)siteId
{
    NSLog(@"siteId : %d", siteId);
    NSLog(@"%@", [selectedDic objectForKey:[[NSString alloc] initWithFormat:@"%d", siteId]]);
    
    
    if ([selectedDic objectForKey:[[NSString alloc] initWithFormat:@"%d", siteId]] == NULL) {
        NSLog(@"-- : NO");

        return NO;
    } else {
        NSLog(@"-- : YES");
        
        return YES;
    }
}

- (void)changeStatus:(NSUInteger)siteId status:(BOOL)on
{
    NSString *number = [[NSString alloc] initWithFormat:@"%d", siteId];
    if (on) {
        // 指定のサイトIDを追加する
        [selectedDic setObject:number forKey:number];
    } else {
        // 指定のサイトIDを取り除く
        [selectedDic removeObjectForKey:number];
    }
    
    NSLog(@"保存用 : %@", [self getString]);
    // 保存
    [UserInfo setSiteList:[self getString]];
    [UserInfo synchronize];
    
    
    
    
    
}

@end
