//
//  SodateAAHelpViewController.m
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/08/13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SodateAAHelpViewController.h"

@implementation SodateAAHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * 前画面に戻る
 */
- (IBAction) backButtonTapped
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // UIView背景画像設定
    UIImage *mainImage = [UIImage imageNamed: @"background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: mainImage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
