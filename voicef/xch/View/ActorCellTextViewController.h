//
//  ActorCellTextViewController.h
//  @see http://akabeko.me/blog/2011/09/uitableviewcell-customize/
//

#import <UIKit/UIKit.h>

@interface ActorCellText : UITableViewCell
{
@private
    IBOutlet UILabel *_labelName;
    IBOutlet UILabel *_labelNameKana;
    IBOutlet UILabel *_labelBlogTitle;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nameKana;
@property (nonatomic, copy) NSString *blogTitle;

@property (weak, nonatomic) IBOutlet UIButton *buttonProf;
@property (weak, nonatomic) IBOutlet UIButton *buttonBlog;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwitter;

@end

@interface ActorCellTextViewController : UIViewController
{
@private
    IBOutlet ActorCellText* _cell;
}
@end
