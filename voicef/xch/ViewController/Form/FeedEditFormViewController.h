//
//  FeedEditFormViewController.h
//

#import <UIKit/UIKit.h>
#import "DaoChannel.h"
#import "Channel.h"
#import "LocalFeed.h"

@interface FeedEditFormViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property NSNumber *paramChannelId; // ChannelID持ち回し用
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBlogUrl;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRssUrl;

@end
