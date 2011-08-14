//
//  SodateAAListViewController.h
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/07/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate
- (void) updateView:(NSDictionary *) dict; 
@end

@interface SodateAAListViewController : UIViewController {
    
    id<ModalViewDelegate> updateViewDelegate;
    
    // 一覧用データ
    NSMutableArray *_dataArray;
    
    // 一覧表示テーブルビュー
    IBOutlet UITableView *resultTableView;

    // backボタン
    IBOutlet UIBarButtonItem *backButton;
}

@property (nonatomic, assign) id<ModalViewDelegate> updateViewDelegate;

@property(nonatomic, retain) NSMutableArray *_dataArray;

/**
 * データをロードする
 */
- (void)loadData;

/**
 * 前画面に戻る
 */
- (IBAction) backButtonTapped;

@end

