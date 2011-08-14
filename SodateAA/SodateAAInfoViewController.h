//
//  SodateAAInfoViewController.h
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/08/06.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SodateAAInfoViewController : UIViewController {


}

/**
 * ライセンスリンク1へ遷移する
 */
-(IBAction) openLicenseLink1: (UIButton *) sender;

/**
 * ライセンスリンク2へ遷移する
 */
-(IBAction) openLicenseLink2: (UIButton *) sender;

/**
 * ライセンスリンク2(cc)へ遷移する
 */
-(IBAction) openLicenseLink2cc: (UIButton *) sender;

/**
 * ライセンスリンク3へ遷移する
 */
-(IBAction) openLicenseLink3: (UIButton *) sender;

/**
 * ライセンスリンク3(cc)へ遷移する
 */
-(IBAction) openLicenseLink3cc: (UIButton *) sender;

/**
 * 開発サイトへ遷移する
 */
-(IBAction) openURL: (UIButton *) sender;

/**
 * Twitterサイトへ遷移する
 */
-(IBAction) openTwitterURL: (UIButton *) sender;

/**
 * 前画面に戻る
 */
- (IBAction) backButtonTapped;

@end
