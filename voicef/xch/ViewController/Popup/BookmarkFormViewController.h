//
//  BookmarkFormViewController.h
//

#import <UIKit/UIKit.h>
#import "Bookmark.h"
#import "BookmarkStore.h"

// 編集モード
typedef NS_ENUM(NSUInteger, BookmarkFormEditType) {
    BookmarkFormEditTypeAdd,
    BookmarkFormEditTypeEdit
};

@interface BookmarkFormViewController : UIViewController
@property (nonatomic, retain) Bookmark *paramBookmark;
@property (nonatomic, assign) NSUInteger *paramEditType;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUrl;
@end
