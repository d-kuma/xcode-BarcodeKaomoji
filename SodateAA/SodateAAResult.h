//
//  SodateAAResult.h
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/07/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SodateAAResult : NSObject {
    // 対象AAの文字列
    NSString *_aaString;
    
    // AA生成用パラメータ
    NSString *_aaStringParameter;
    
    // 読み込んだバーコードの商品名
    NSString *_barcodeString;
}

@property(nonatomic, copy) NSString *_aaString;

@property(nonatomic, copy) NSString *_aaStringParameter;

@property(nonatomic, copy) NSString *_barcodeString;

/**
 * クラスを初期化する
 */
-(id)init;

@end
