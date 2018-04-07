//
//  EntryCellViewController.m
//

#import "EntryCellViewController.h"

@implementation EntryCell
@synthesize title;
@synthesize author;
@synthesize modified;
@synthesize twitterCount;
@synthesize thumb;

- (UIImageView *)thumb
{
    return _imageViewThumb;
}
- (void)setThumb:(UIImageView *)value
{
    _imageViewThumb = value;
}

- (NSString *)title
{
    return _labelTitle.text;
}
- (void)setTitle:(NSString *)value
{
    _labelTitle.text = value;
}

- (NSString *)author
{
    return _labelAuthor.text;
}
- (void)setAuthor:(NSString *)value
{
    _labelAuthor.text = value;
}

- (NSString *)modified
{
    return _labelModified.text;
}
- (void)setModified:(NSString *)value
{
    _labelModified.text = value;
}

- (NSString *)twitterCount
{
    return _labelTwitterCount.text;
}
- (void)setTwitterCount:(NSString *)value
{
    _labelTwitterCount.text = value;
}

- (BOOL)twitterIconHidden
{
    return _imageViewTwitterIcon.hidden;
}
- (void)setTwitterIconHidden:(BOOL)flag
{
    _imageViewTwitterIcon.hidden = flag;
}

@end

@implementation EntryCellViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
