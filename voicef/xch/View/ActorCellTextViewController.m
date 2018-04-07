//
//  ActorCellTextViewController.m
//

#import "ActorCellTextViewController.h"

@implementation ActorCellText
@synthesize name;
@synthesize nameKana;
@synthesize blogTitle;

- (NSString *)name
{
    return _labelName.text;
}
- (void)setName:(NSString *)value
{
    _labelName.text = value;
}

- (NSString *)nameKana
{
    return _labelNameKana.text;
}
- (void)setNameKana:(NSString *)value
{
    _labelNameKana.text = value;
}

- (NSString *)blogTitle
{
    return _labelBlogTitle.text;
}
- (void)setBlogTitle:(NSString *)value
{
    _labelBlogTitle.text = value;
}

@end

@implementation ActorCellTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
