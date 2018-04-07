//
//  SearchSyllabaryDetailViewController.m
//

#import "SearchSyllabaryDetailViewController.h"

@interface SearchSyllabaryDetailViewController ()
@end

@implementation SearchSyllabaryDetailViewController
@synthesize paramSyllabary;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SearchSyllabaryDetailViewController");
    NSLog(@"Param : %@", paramSyllabary);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

