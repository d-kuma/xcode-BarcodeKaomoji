//
//  SodateAAInfoViewController.m
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/08/06.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SodateAAInfoViewController.h"

@implementation SodateAAInfoViewController

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
 * ライセンスリンク1へ遷移する
 */
-(IBAction) openLicenseLink1: (UIButton *) sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://zbar.sourceforge.net/"]];
}

/**
 * ライセンスリンク2へ遷移する
 */
-(IBAction) openLicenseLink2: (UIButton *) sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://blog.twg.ca/2009/09/free-iphone-toolbar-icons/"]];
}

/**
 * ライセンスリンク2(cc)へ遷移する
 */
-(IBAction) openLicenseLink2cc: (UIButton *) sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://creativecommons.org/licenses/by-sa/3.0/"]];
}

/**
 * ライセンスリンク3へ遷移する
 */
-(IBAction) openLicenseLink3: (UIButton *) sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://glyphish.com"]];
}

/**
 * ライセンスリンク3(cc)へ遷移する
 */
-(IBAction) openLicenseLink3cc: (UIButton *) sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://creativecommons.org/licenses/by/3.0/us/"]];
}

/**
 * 開発サイトへ遷移する
 */
-(IBAction) openURL: (UIButton *) sender
{
    // 開発サイトへ遷移
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://d.hatena.ne.jp/mocolo/"]];
}

/**
 * Twitterサイトへ遷移する
 */
-(IBAction) openTwitterURL: (UIButton *) sender
{
    // Twitterへ遷移
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://twitter.com/mocolosupport"]];
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
