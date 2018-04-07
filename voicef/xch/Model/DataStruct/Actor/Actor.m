//
//  FeedEntry.m
//

#import "Actor.h"

@implementation Actor

@synthesize aid;
@synthesize name;
@synthesize nameKana;
@synthesize syllabaryCategory;
@synthesize syllabary;
@synthesize officeId;
@synthesize officeName;
@synthesize officialUrl;
@synthesize blogTitle;
@synthesize blogUrl;
@synthesize rssUrl;
@synthesize twitterUrl;
@synthesize birthdayRaw;
@synthesize birthplaceRaw;
@synthesize bloodtype;
@synthesize hobby;
@synthesize filmographies;

- (id)initWithObject:(NSDictionary *)obj
{
    if (self = [super init]) {
        aid                 = [[obj objectForKey:@"id"] intValue];
        name                = [obj objectForKey:@"name"];
        nameKana            = [obj objectForKey:@"name_kana"];
        syllabaryCategory   = [obj objectForKey:@"syllabary_category"];
        syllabary           = [obj objectForKey:@"syllabary"];
        officeId            = [[obj objectForKey:@"office_id"] intValue];
        officeName          = [obj objectForKey:@"office_name"];
        officialUrl         = [obj objectForKey:@"official_url"];
        blogTitle           = [obj objectForKey:@"blog_title"];
        blogUrl             = [obj objectForKey:@"blog_url"];
        rssUrl              = [obj objectForKey:@"rss_url"];
        twitterUrl          = [obj objectForKey:@"twitter_url"];
        birthdayRaw         = [obj objectForKey:@"birthday_raw"];
        birthplaceRaw       = [obj objectForKey:@"birthplace_raw"];
        bloodtype           = [obj objectForKey:@"bloodtype"];
        hobby               = [obj objectForKey:@"hobby"];
        filmographies       = [obj objectForKey:@"filmographies"];
    }
    return self;
}

- (NSString *)description
{
    NSString *str =  [NSString stringWithFormat:@"ID : %ld, Name : %@, NameKana : %@, SyCat : %@, Sy : %@, OfficeId : %ld, OfficeName : %@, OfficicalUrl : %@, BlogTitle : %@, BlogUrl : %@, RSSUrl : %@, Birthday : %@, BirthPlace : %@, BT : %@, Hobby : %@, FG : %@, TW : %@",
                      aid,
                      name,
                      nameKana,
                      syllabaryCategory,
                      syllabary,
                      officeId,
                      officeName,
                      officialUrl,
                      blogTitle,
                      blogUrl,
                      rssUrl,
                      birthdayRaw,
                      birthplaceRaw,
                      bloodtype,
                      hobby,
                      filmographies,
                      twitterUrl
                      ];
    return str;
}
@end