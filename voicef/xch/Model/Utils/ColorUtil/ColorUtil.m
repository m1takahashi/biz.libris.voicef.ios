//
//  ColorUtil.m
//

#import "ColorUtil.h"

@implementation ColorUtil

+ (UIColor*)getUIColorFromHex:(NSString*)hex{
    return
    [UIColor
     colorWithRed:[self getNumberFromHex:hex rangeFrom:0]/255.0
     green:[self getNumberFromHex:hex rangeFrom:2]/255.0
     blue:[self getNumberFromHex:hex rangeFrom:4]/255.0
     alpha:1.0f];
}

+ (unsigned int)getNumberFromHex:(NSString*)hex rangeFrom:(int)from{
    NSString *hexString = [hex substringWithRange:NSMakeRange(from, 2)];
    NSScanner* hexScanner = [NSScanner scannerWithString:hexString];
    unsigned int intColor;
    [hexScanner scanHexInt:&intColor];
    return intColor;
}

@end
