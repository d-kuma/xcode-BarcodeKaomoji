//
//  SodateAAViewController.h
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/05/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/CAGradientLayer.h>
#import "SodateAALogic.h"
#import "ZBarSDK.h"
#import "SodateAAListViewController.h"
#import "SodateAAInfoViewController.h"
#import "SodateAAHelpViewController.h"
#import "HttpConnectionWrapper.h"

// AAアニメ差分
#define aaAnimeDiff 10
// 商品名表示
#define itemSearching @"検索中。。。"
#define itemUnknown @"不明"
#define itemConnectFail @"接続失敗"

@interface SodateAAViewController : UIViewController<UIApplicationDelegate, UIAlertViewDelegate, ZBarReaderDelegate, ModalViewDelegate,HttpConnectionWrapperDelegate> {
    
    // 以下、ロジッククラス
    // ロジッククラス
    SodateAALogic *logic;
    
    // HTTPコネクション用ラッパー
    HttpConnectionWrapper *httpConnection;
    
    // 以下、zbar用view
    IBOutlet UIView *zbarOverlayView;
    
    // 以下、メイン画面コンポーネント
    // 表示AA
    IBOutlet UILabel *mainAALabel;
    
    // ステータス表示
    IBOutlet UITextView *mainStatusTextView;
    
    // 「info」ボタン
    IBOutlet UIButton *infoButton;
    
    // 「barcode」ボタン
    IBOutlet UIButton *barcodeButton;
    
    // 「save」ボタン
    IBOutlet UIButton *saveButton;
    
    // 「copy」ボタン
    IBOutlet UIButton *copyButton;
    
    // 「clear」ボタン
    IBOutlet UIButton *clearButton;
    
    // 「一覧」ボタン
    IBOutlet UIButton *aaListButton;
    
    // 「info」ボタン
    IBOutlet UIButton *mainInfoButton;
    
    // ライフ動作差分管理用
	BOOL aaAnimeSwitch;
    
    // AAアニメタイマー
    NSTimer *aaAnimeTimer;
}

/**
 * タイマー処理スタート
 */
-(void)timerStart;

/**
 * バーコード読み込み画面を閉じる
 */
- (IBAction) zBarViewClose;

/**
 * バーコード読み込み実行
 */
- (IBAction) scanButtonTapped;

/**
 * データをセーブする
 */
- (IBAction) saveAAData;

/**
 * データをクリップボードにコピーする
 */
- (IBAction) copyToClipboard;

/**
 * データをクリアする
 */
- (IBAction) clearAAData;

/**
 * 一覧表示画面へ遷移する
 */
- (IBAction) listButtonTapped;

/**
 * 一覧画面で選択した顔文字データを表示する
 */
- (void) updateView:(NSDictionary *) dict;

/**
 * 情報画面へ遷移する
 */
- (IBAction) InfoButtonTapped;

/**
 * ヘルプ画面へ遷移する
 */
- (IBAction) HelpButtonTapped;

/**
 * 商品読み取り結果を設定する
 */
-(NSString *) setStatusTextFromAPI:(NSString *)string regex:(NSString *)regex;

/**
 メッセージを表示する
 */
- (void) showMessage:(NSString*)message;

/**
 確認メッセージを表示する(はい/いいえボタン付き)
 */
- (void) showConfirmMessage:(NSString*)message;

@end
