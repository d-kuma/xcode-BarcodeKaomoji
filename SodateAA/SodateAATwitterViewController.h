//
//  SodateAATwitterViewController.h
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/08/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthCore.h"
#import "OAuth+Additions.h"

#define CONSUMER_KEY        @"nPRJPqsbueXfL6OU61nMgg"
#define CONSUMER_KEY_SECRET @"wulSrQukFX4uEXJ7Y2hAVhPZyGj5IoHgepf2CCHCZCo"

// 商品名表示
#define itemSearching @"検索中。。。"
#define itemUnknown @"不明"
#define itemConnectFail @"接続失敗"

@interface SodateAATwitterViewController : UIViewController {
    
    IBOutlet UITextField *txtId;
    
    IBOutlet UITextField *txtPass;
    
    IBOutlet UITextView  *txtTwit;
    
    IBOutlet UIButton *submitButton;
    
	IBOutlet UIActivityIndicatorView *indicatorView;
    
    IBOutlet UIView *hideView;
    
    NSString *aaText;
    
    NSString *itemText;
}

@property(nonatomic, retain) NSString *aaText;
@property(nonatomic, retain) NSString *itemText;

/**
 * キーボードクローズ処理
 */
-(IBAction) hideKeyBoard: (id) sender;

/**
 * 前画面に戻る
 */
- (IBAction) backButtonTapped;

/**
 TwitterへPOSTする
 */
-(IBAction) postTwitter:(UIButton*) sender;

/**
 TwitterAPI認証
 */
-(void)authenticateAndTweet;

/**
 TwitterAPIリクエスト
 */
+(NSData *)request:(NSURL *)url method:(NSString *)method 
              body:(NSData *)body 
       oauth_token:(NSString *)oauth_token 
oauth_token_secret:(NSString *)oauth_token_secret;

/**
 メッセージを表示する
 */
- (void) showMessage:(NSString*)message;

@end
