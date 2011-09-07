//
//  SodateAATwitterViewController.m
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/08/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SodateAATwitterViewController.h"

@implementation SodateAATwitterViewController

@synthesize aaText;
@synthesize itemText;

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
 * キーボードクローズ処理
 */
-(IBAction) hideKeyBoard: (id) sender
{
    [txtId endEditing: YES];
    [txtPass endEditing: YES];
}

/**
 * 前画面に戻る
 */
- (IBAction) backButtonTapped
{
    [self dismissModalViewControllerAnimated:YES];
}

/**
 * TwitterへPOSTする
 */
-(IBAction) postTwitter: (UIButton *) sender
{
    // キーボードクローズ
    [self hideKeyBoard:sender];
    
    // POST内容チェック
    NSString *username = txtId.text;
    NSString *password = txtPass.text;
    NSString *twit     = txtTwit.text;
    
    username = [username stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    password = [password stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    twit     = [twit stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0)
    {
        [self showMessage: @"ID／パスワードを入力してください"];
        return;
    }
    if ([twit length] == 0)
    {
        [self showMessage: @"本文を入力してください"];
        return;
    }
    
    // POSTする
    hideView.hidden = NO;
    [self.view addSubview: indicatorView];
    [indicatorView startAnimating];
    
    [self performSelectorInBackground: @selector(authenticateAndTweet)
                           withObject: nil];
}

/**
 * TwitterAPI認証
 */
-(void)authenticateAndTweet
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString          *username = txtId.text;
    NSString          *password = txtPass.text;
    NSString          *status   = txtTwit.text;
    
    // xAuth
    NSData *xauth_response = [SodateAATwitterViewController request: [NSURL URLWithString: @"https://api.twitter.com/oauth/access_token"]
                                                    method: @"POST"
                                                      body: [[NSString stringWithFormat: @"x_auth_username=%@&x_auth_password=%@&x_auth_mode=client_auth", username, password] dataUsingEncoding: NSUTF8StringEncoding]
                                               oauth_token: @""
                                        oauth_token_secret: @""];
    
    if (xauth_response == nil)
    {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        hideView.hidden = YES;
        [self showMessage: @"TwiterへのPOSTに失敗しました。時間をおいてもう一度実行してください"];
        [pool release];
        return;
    }
    
    NSDictionary *dict               = [NSURL ab_parseURLQueryString: [[[NSString alloc] initWithData: xauth_response encoding: NSUTF8StringEncoding] autorelease]];
    NSString     *oauth_token        = [dict objectForKey: @"oauth_token"];
    NSString     *oauth_token_secret = [dict objectForKey: @"oauth_token_secret"];
    
    // トークンがとれない場合IDかパスが間違っている
    if (oauth_token == nil || oauth_token_secret == nil)
    {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        hideView.hidden = YES;
        [self showMessage: @"ID／パスワードが間違っています"];
        [pool release];
        return;
    }
    
    status = [((NSString *)
               CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                       (CFStringRef)status,
                                                       NULL,
                                                       CFSTR(":/?#[]@!$&’()*+,;="),
                                                       kCFStringEncodingUTF8))autorelease];
    
    // xAuthで得たtokenを利用してTweet
    NSData *tweet_response = [SodateAATwitterViewController request: [NSURL URLWithString: @"http://api.twitter.com/1/statuses/update.json"]
                                                    method: @"POST"
                                                      body: [[NSString stringWithFormat: @"status=%@", status] dataUsingEncoding: NSUTF8StringEncoding]
                                               oauth_token: oauth_token
                                        oauth_token_secret: oauth_token_secret];
    
    if (tweet_response == nil)
    {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        hideView.hidden = YES;
        [self showMessage: @"TwiterへのPOSTに失敗しました。時間をおいてもう一度実行してください"];
        [pool release];
        return;
    }
    
    NSLog(@"response: %@", [[[NSString alloc] initWithData: tweet_response encoding: NSUTF8StringEncoding] autorelease]);
    
    // post正常終了
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
    hideView.hidden = YES;
    [self showMessage: @"TwitterへのPOSTに成功しました"];
    [pool release];
}

/**
 * TwitterAPIリクエスト
 */
+(NSData *)request: (NSURL *) url method: (NSString *) method
              body: (NSData *) body
       oauth_token: (NSString *) oauth_token
oauth_token_secret: (NSString *) oauth_token_secret
{
    NSString            *header  = OAuthorizationHeader(url, method, body, CONSUMER_KEY, CONSUMER_KEY_SECRET, oauth_token, oauth_token_secret);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    [request setHTTPMethod: method];
    [request setValue: header forHTTPHeaderField: @"Authorization"];
    [request setHTTPBody: body];
    NSURLResponse *response    = nil;
    NSError       *error       = nil;
    NSData        *contentData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    
    if (error)
    {
        NSLog(@"failture error: %@", error);
        return(nil);
    }
    
    if ([response isKindOfClass: [NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = ( NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] != 200)
        {
            NSLog(@"failture response: %d", [httpResponse statusCode]);
            return(nil);
        }
    }
    
    return(contentData);
}

/**
 * メッセージを表示する
 */
-(void)showMessage: (NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: nil
                          message: message
                          delegate: self
                          cancelButtonTitle: @"OK"
                          otherButtonTitles: nil];
    
    [alert show];
    [alert release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UIView背景画像設定
    UIImage *mainImage = [UIImage imageNamed: @"background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: mainImage];
    
    // Twitter投稿用文字列作成
    if (itemText.length + aaText.length > 85) {
        int length = itemText.length + aaText.length;
        itemText = [itemText substringToIndex:itemText.length - (length - 85)];
    }
    
    NSString *postMessage;
    if ([itemConnectFail isEqualToString:itemText] || 
        [itemUnknown isEqualToString:itemText] ||
        [itemSearching isEqualToString:itemText]) {
        
        postMessage = [NSString stringWithFormat:
                       @"謎の商品Xのバーコードから、顔文字「%@」が作成されたよ！ #バーコード顔文字 http://bit.ly/n47L1y",aaText];
    } else {
        postMessage = [NSString stringWithFormat:
                       @"%@のバーコードから、顔文字「%@」が作成されたよ！ #バーコード顔文字 http://bit.ly/n47L1y",itemText,aaText];
    }
    
    txtTwit.text = postMessage;
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
