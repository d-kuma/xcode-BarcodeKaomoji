//
//  SodateAAViewController.m
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/05/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SodateAAViewController.h"

@implementation SodateAAViewController

- (void)dealloc
{
    //TODO 画面コンポーネントのrelease書く
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * AAアニメスレッド処理
 */
-(void)onTimerLifeCycle: (NSTimer *) timer
{    
    CGRect rect = mainAALabel.frame;
    if (aaAnimeSwitch) {
        rect.origin.y += aaAnimeDiff;
        aaAnimeSwitch = NO;
    } else {
        rect.origin.y -= aaAnimeDiff;
        aaAnimeSwitch = YES;
    }
    mainAALabel.frame = rect;
}

/**
 * タイマー処理スタート
 */
-(void)timerStart {
    // AAアニメスレッド動作
    aaAnimeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.00
                                                    target: self
                                                  selector: @selector(onTimerLifeCycle:)
                                                  userInfo: nil
                                                   repeats: YES];
}

/**
 * バーコード読み込み画面を閉じる
 */
- (IBAction) zBarViewClose
{
    [self dismissModalViewControllerAnimated:YES];
}

/**
 * バーコード読み込み実行
 */
- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.showsZBarControls = NO;
    reader.cameraOverlayView = zbarOverlayView;
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

/**
 * バーコード読み取り完了処理
 */
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // 値をバーコードから取得
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results) {
        break;
    }
    
    // 値に合わせてAAを生成
    [logic createAAfromAAParameter:symbol.data];
    mainAALabel.text = logic._result._aaString;
    mainStatusTextView.text = itemSearching;
    
    // HTTPコネクションから値を取得
    httpConnection = [[HttpConnectionWrapper alloc]init];
    httpConnection.delegate = self;
    // YahooAPIへリクエスト送信
    NSString *requestURL = [NSString stringWithFormat:@"http://shopping.yahooapis.jp/ShoppingWebService/V1/itemSearch?appid=dkumagai&hits=1&jan=%@",logic._result._aaStringParameter];
    [httpConnection startWithString:requestURL];
    // RakutenAPIへリクエスト送信
    NSString *requestURL2 = [NSString stringWithFormat:@"http://api.rakuten.co.jp/rws/3.0/rest?developerId=0c72a6188f7304f6705e306602ecf08f&operation=BooksTotalSearch&version=2011-07-07&isbnjan=%@&hits=1&page=1",logic._result._aaStringParameter];
    [httpConnection startWithString:requestURL2];
    
    [reader dismissModalViewControllerAnimated: YES];
}

/**
 * 商品名読み取り結果を受け取る
 */
-(void)didReceiveAllResponse:(HttpConnectionWrapper *)connection withString:(NSString *)string
{
    if ([itemConnectFail isEqualToString:mainStatusTextView.text] || 
        [itemUnknown isEqualToString:mainStatusTextView.text] ||
        [itemSearching isEqualToString:mainStatusTextView.text]) {
        // YahooAPI用探索処理
        NSString *match = [self setStatusTextFromAPI:string regex:@"<Name>(.+)</Name><Description>"];
        NSLog(@"YahooAPI match %@", match);
        
        if (match == nil) {
            // 楽天API用探索処理
            match = [self setStatusTextFromAPI:string regex:@"<title>(.+)</title>"];
            NSLog(@"RakutenAPI match %@", match);
        }
    }
}

/**
 * 商品読み取り結果を設定する
 */
-(NSString *) setStatusTextFromAPI:(NSString *)string regex:(NSString *)regex
{
    //NSLog(@"response %@", string);
    NSError *error   = nil;
    NSRegularExpression *regexp =
    [NSRegularExpression regularExpressionWithPattern:regex
                                              options:0
                                                error:&error];
    if (error != nil || string == nil) {
        mainStatusTextView.text = itemConnectFail;
        logic._result._barcodeString = mainStatusTextView.text;
        return nil;
    } else {
        NSTextCheckingResult *match =
        [regexp firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        
        NSInteger matchIndex = match.numberOfRanges;
        NSLog(@"match index:%d",matchIndex); // 2のはず
        if (matchIndex == 2) {
            NSString *matchString = [string substringWithRange:[match rangeAtIndex:1]];
            //NSLog(@"%@", [string substringWithRange:[match rangeAtIndex:0]]); // マッチした文字列全部
            NSLog(@"match string:%@", matchString); // "商品名"
            
            // まだ値が入っていない場合のみ設定する
            if ([itemConnectFail isEqualToString:mainStatusTextView.text] || 
                [itemUnknown isEqualToString:mainStatusTextView.text] ||
                [itemSearching isEqualToString:mainStatusTextView.text]) {
                mainStatusTextView.text = [NSString stringWithFormat:@"%@", matchString];
                logic._result._barcodeString = mainStatusTextView.text;
                return mainStatusTextView.text;
            } else {
                return nil;
            }
        } else {
            mainStatusTextView.text = itemUnknown;
            logic._result._barcodeString = mainStatusTextView.text;
            return nil;
        }
    }
}

/**
 * データをセーブする
 */
- (IBAction) saveAAData {
    // 保存されているデータリストを取得
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* dataArray = [defaults mutableArrayValueForKey:@"aaDataList"];
    if (dataArray == nil) {
        // データがない場合リストを新規生成
        dataArray = [NSMutableArray array];
    }
    
    // 保存データをDictionaryに変換
    NSLog(@"aastring : %@",logic._result._aaString);
    NSLog(@"aaStringParameter : %@", logic._result._aaStringParameter);
    NSLog(@"barcodeString : %@", logic._result._barcodeString);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         logic._result._aaString, @"aaString",
                         logic._result._aaStringParameter, @"aaStringParameter",
                         logic._result._barcodeString, @"barcodeString",nil];
    
    // リストに保存データを追加
    [dataArray addObject:dic];
    
//    for (id e in dataArray) {
//        NSLog(@"%@", e);
//    }
    
    // リストをNsUserDefaultsにセット
    [defaults setObject:dataArray forKey:@"aaDataList"];
    [defaults synchronize];
    
    // メッセージを表示
    [self showMessage:@"顔文字を保存しました。"];
}

/**
 * データをクリップボードにコピーする
 */
- (IBAction) copyToClipboard {
    // データをクリップボードにコピー
    UIPasteboard *pastebd = [UIPasteboard generalPasteboard];
    [pastebd setValue:logic._result._aaString 
    forPasteboardType: @"public.utf8-plain-text"];
    
    // メッセージを表示
    NSString *message = [NSString stringWithFormat:@"%@\r\nをコピーしました。", logic._result._aaString];
    [self showMessage:message];
}

/**
 * データをクリアする
 */
- (IBAction) clearAAData {
    // 確認メッセージ表示
    [self showConfirmMessage:@"現在表示している顔文字をクリアします。"];
}

/**
 * データをクリアする(確認後実行用)
 */
- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{	
    if (buttonIndex == 1)
    {
        // AAクリア
        [logic clearAAData];
        mainAALabel.text = logic._result._aaString;
        mainStatusTextView.text = logic._result._barcodeString;
    }
}

/**
 * 一覧表示画面へ遷移する
 */
- (IBAction) listButtonTapped
{
    SodateAAListViewController *list = [[SodateAAListViewController alloc]initWithNibName:@"SodateAAListViewController" 
                                                                                   bundle:nil];
    list.updateViewDelegate = self;
    [self presentModalViewController: list
                            animated: YES];
    [list release];
}


/**
 * 一覧画面で選択した顔文字データを表示する
 */
- (void) updateView:(NSDictionary *) dict
{
    logic._result._aaString = [dict objectForKey:@"aaString"];
    logic._result._aaStringParameter = [dict objectForKey:@"aaStringParameter"];
    logic._result._barcodeString = [dict objectForKey:@"barcodeString"];
    
    mainAALabel.text = logic._result._aaString;
    mainStatusTextView.text = logic._result._barcodeString;
    
    // 過去に接続失敗していた場合は商品名を再取得する
    if ([itemConnectFail isEqualToString:mainStatusTextView.text]) {
        // 画面表示を「検索中」に変更
        mainStatusTextView.text = itemSearching;
        // HTTPコネクションから値を取得
        httpConnection = [[HttpConnectionWrapper alloc]init];
        httpConnection.delegate = self;
        // YahooAPIへリクエスト送信
        NSString *requestURL = [NSString stringWithFormat:@"http://shopping.yahooapis.jp/ShoppingWebService/V1/itemSearch?appid=dkumagai&hits=1&jan=%@",logic._result._aaStringParameter];
        [httpConnection startWithString:requestURL];
        // RakutenAPIへリクエスト送信
        NSString *requestURL2 = [NSString stringWithFormat:@"http://api.rakuten.co.jp/rws/3.0/rest?developerId=0c72a6188f7304f6705e306602ecf08f&operation=BooksTotalSearch&version=2011-07-07&isbnjan=%@&hits=1&page=1",logic._result._aaStringParameter];
        [httpConnection startWithString:requestURL2];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


/**
 * 情報画面へ遷移する
 */
- (IBAction) InfoButtonTapped
{
    SodateAAInfoViewController *info = [[SodateAAInfoViewController alloc]initWithNibName:@"SodateAAInfoViewController" 
                                                                                   bundle:nil];
    [self presentModalViewController: info
                            animated: YES];
    [info release];
}

/**
 * ヘルプ画面へ遷移する
 */
- (IBAction) HelpButtonTapped
{
    SodateAAHelpViewController *help = [[SodateAAHelpViewController alloc]initWithNibName:@"SodateAAHelpViewController" 
                                                                                   bundle:nil];
    [self presentModalViewController: help
                            animated: YES];
    [help release];
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

/**
 *確認メッセージを表示する(はい/いいえボタン付き)
 */
-(void)showConfirmMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: nil
                          message: message
                          delegate: self
                          cancelButtonTitle: @"Cancel"
                          otherButtonTitles: @"OK", nil];
    
    [alert show];
    [alert release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ロジック初期化
    logic = [[SodateAALogic alloc] init];
    
    // UIView背景画像設定
    UIImage *mainImage = [UIImage imageNamed: @"background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: mainImage];
    
    // 画面の値セット
    mainAALabel.text = logic._result._aaString;
    
    // タイマー処理実行開始
    aaAnimeSwitch = YES;
    [self timerStart];
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
