//
//  EntryCellTextViewController.h
//  @see http://akabeko.me/blog/2011/09/uitableviewcell-customize/
//

#import <UIKit/UIKit.h>

@interface EntryCellText : UITableViewCell
{
@private
    IBOutlet UILabel *_labelTitle;
    IBOutlet UILabel *_labelAuthor;
    IBOutlet UILabel *_labelModified;
    IBOutlet UILabel *_labelTwitterCount;
    IBOutlet UIImageView *_imageViewTwitterIcon;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *modified;
@property (nonatomic, copy) NSString *twitterCount;

- (BOOL)twitterIconHidden;
- (void)setTwitterIconHidden:(BOOL)flag;

@end

@interface EntryCellTextViewController : UIViewController
{
@private
    IBOutlet EntryCellText* _cell;
}
@end
