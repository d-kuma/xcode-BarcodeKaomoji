//
//  SodateAALogic.h
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/05/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SodateAAResult.h"

@interface SodateAALogic : NSObject {
    
    SodateAAResult *_result;
}

@property(nonatomic, retain) SodateAAResult *_result;

/**
 * クラスを初期化する
 */
-(id)init;

/**
 * AAパラメータから顔文字を生成する
 */
-(void)createAAfromAAParameter:(NSString*)barcodeParameter;

/**
 * データを初期状態に戻す
 */
-(void)clearAAData;


/**
 * 引数の文字列がすべて数字で構成されているかを判定する
 */
+ (BOOL)isNumerical:(NSString *) string;

@end
