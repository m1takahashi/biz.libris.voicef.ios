//
//  EulaNewViewController.m
//

#import "EulaNewViewController.h"

@interface EulaNewViewController ()

@end

@implementation EulaNewViewController
@synthesize navigationItem;
@synthesize textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景色
//    [self.view setBackgroundColor:[ColorUtil getUIColorFromHex:EXT_NAVIGATION_BAR_COLOR]];
    
    [navigationItem setTitle:NSLocalizedString(@"eula_title", nil)];

    UIBarButtonItem *agree = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"eula_agree", nil)
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(pushAgreeButton:)];
    [navigationItem setRightBarButtonItem:agree];

    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"eula" ofType:@"txt"];
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    [textView setText:text];
}

- (void)pushAgreeButton:(id)sender
{
    [UserInfo setEula:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
