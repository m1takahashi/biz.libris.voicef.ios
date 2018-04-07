//
//  StringEditor.m
//  @see http://stackoverflow.com/questions/277055/remove-html-tags-from-an-nsstring-on-the-iphone
//

#import "StringEditor.h"

@implementation StringEditor


// HTMLタグ除去
+ (NSString *)stringByStrippingHTML:(NSString *)str
{
    NSRange r;
//    NSString *s = [self copy];
    NSString *s = str;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
