//
//  ColorUtil.h
//

#import <Foundation/Foundation.h>

@interface ColorUtil : NSObject

+(UIColor*)getUIColorFromHex:(NSString*)hex;
+(unsigned int)getNumberFromHex:(NSString*)hex rangeFrom:(int)from;

@end
