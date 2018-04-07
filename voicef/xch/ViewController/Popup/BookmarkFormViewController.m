//
//  BookmarkFormViewController.m
//

#import "BookmarkFormViewController.h"

@interface BookmarkFormViewController ()

@end

@implementation BookmarkFormViewController
@synthesize paramBookmark;
@synthesize paramEditType;
@synthesize textFieldTitle;
@synthesize textFieldUrl;
@synthesize navigationBar;
@synthesize navigationItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 背景色
//    [self.view setBackgroundColor:[ColorUtil getUIColorFromHex:EXT_NAVIGATION_BAR_COLOR]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [navigationItem setTitle:paramBookmark.bookmarkTitle];
    [textFieldTitle setText:paramBookmark.bookmarkTitle];
    [textFieldUrl setText:paramBookmark.bookmarkUrl];

    if (paramEditType == BookmarkFormEditTypeAdd) {
        UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"form_cancel", nil)
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(pushLeftButton:)];
        UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"form_add", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(pushRightButton:)];
        [navigationItem setLeftBarButtonItem:btnLeft];
        [navigationItem setRightBarButtonItem:btnRight];
    } else {
        UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                  target:self
                                                                                  action:@selector(pushRightButton:)];
        [navigationItem setRightBarButtonItem:btnRight];
    }
    
}


#pragma mark - Button
- (void)pushLeftButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushRightButton:(id)sender
{
    NSString *title = textFieldTitle.text;
    NSString *url   = textFieldUrl.text;

    if (paramEditType == BookmarkFormEditTypeAdd) {
        // 追加
        Bookmark *bookmark = [[Bookmark alloc] initWithBookmarkTitle:title bookmarkUrl:url];
        NSLog(@"追加しました。 : %@", [bookmark description]);

        [[BookmarkStore defaultStore] addBookmark:bookmark];
        [self dismissViewControllerAnimated:YES completion:nil];

    } else {
        // 編集
        NSLog(@"編集しました。");
        [paramBookmark setBookmarkTitle:title];
        [paramBookmark setBookmarkUrl:url];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
