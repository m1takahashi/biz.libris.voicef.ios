//
//  Actor.h
//  サーバー側のm_actorの構造を定義
//

#import <Foundation/Foundation.h>

@interface Actor : NSObject

@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nameKana;
@property (nonatomic, copy) NSString *syllabaryCategory;
@property (nonatomic, copy) NSString *syllabary;
@property (nonatomic, assign) NSInteger officeId;
@property (nonatomic, copy) NSString *officeName;
@property (nonatomic, copy) NSString *officialUrl;
@property (nonatomic, copy) NSString *blogTitle;
@property (nonatomic, copy) NSString *blogUrl;
@property (nonatomic, copy) NSString *rssUrl;
@property (nonatomic, copy) NSString *twitterUrl;
@property (nonatomic, copy) NSString *birthdayRaw;
@property (nonatomic, copy) NSString *birthplaceRaw;
@property (nonatomic, copy) NSString *bloodtype;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *filmographies;

- (id)initWithObject:(NSDictionary *)obj;
- (NSString *)description;

@end
