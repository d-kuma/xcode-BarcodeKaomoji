//
//  SodateAALogic.m
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/05/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SodateAALogic.h"


@implementation SodateAALogic

@synthesize _result;

/**
 クラスを初期化する
 */
-(id)init {
	self = [super init];
	if (self != nil) {
        _result = [[SodateAAResult alloc] init];
	}
	return self;
}

/**
 * AAパラメータから顔文字を生成する
 */
-(void)createAAfromAAParameter:(NSString*)barcodeParameter {
    
    NSLog(@"aaString %@", barcodeParameter);
    
    NSString* aaInlineParameter;
    NSString* aaOutlineParameter;

    if(![SodateAALogic isNumerical:barcodeParameter]){
        // 数字以外の文字列の場合、文字列のAsciiから強制的に数値文字列に変換する
        int aaConvParam = 10000;
        for(int i=0; i<[barcodeParameter length]; ++i)
        {
            unichar c = [barcodeParameter characterAtIndex:i];
            aaConvParam += c;
        }
        NSLog(@"non numerical parameter");
        _result._aaStringParameter = [NSString stringWithFormat:@"%d", aaConvParam];
    } else {
        // 数字のみの文字列の場合はそのまま使用する
        NSLog(@"numerical parameter");
        _result._aaStringParameter = barcodeParameter;
    }
    NSLog(@"aa param : %@", _result._aaStringParameter);
    
    // パラメータ取得用の文字列をとる
    if (_result._aaStringParameter.length < 13) {
        // 桁数が足りない場合、先頭の数値を使用
        aaInlineParameter = [_result._aaStringParameter substringWithRange:NSMakeRange(0, 3)];
        aaOutlineParameter = [NSString stringWithFormat:@"0%@",[_result._aaStringParameter substringWithRange:NSMakeRange(3, 2)]]; 
    } else {
        // 桁数が十分の場合、後半の数値を使用
        aaInlineParameter = [_result._aaStringParameter substringWithRange:NSMakeRange(8, 3)];
        aaOutlineParameter = [NSString stringWithFormat:@"0%@",[_result._aaStringParameter substringWithRange:NSMakeRange(11, 2)]];
    }
    
    NSLog(@"inlineParam:%@, outlineParam:%@", aaInlineParameter, aaOutlineParameter);
    
    // Plistから部品を取得
    NSString* inlinePath = [[NSBundle mainBundle] pathForResource:@"aaInline" ofType:@"plist"];  
    NSDictionary* inlineDict = [NSDictionary dictionaryWithContentsOfFile:inlinePath];
    NSString* inlineAA = [inlineDict objectForKey:aaInlineParameter];
    
    NSString* outlinePath = [[NSBundle mainBundle] pathForResource:@"aaOutline" ofType:@"plist"];  
    NSDictionary* outlineDict = [NSDictionary dictionaryWithContentsOfFile:outlinePath];
    NSString* outlineAA = [outlineDict objectForKey:aaOutlineParameter];
    
    NSLog(@"inlineAA:%@, outlineAA:%@", inlineAA, outlineAA);

    // 部品を合成して顔文字を作成
    NSString* newAA = [outlineAA stringByReplacingOccurrencesOfString:@"*inline*" withString:inlineAA];
    
    NSLog(@"newAA:%@", newAA);
    
    _result._aaString = newAA;
}

/**
 * データを初期状態に戻す
 */
-(void)clearAAData {
    [_result dealloc];
    _result = [[SodateAAResult alloc] init];
}

- (void)dealloc
{
    [_result dealloc];
    [super dealloc];
}

/**
 * 引数の文字列がすべて数字で構成されているかを判定する
 */
+ (BOOL)isNumerical:(NSString *) string
{
    int l = [string length];
    
    BOOL b = FALSE;
    for (int i = 0; i < l; i++) {
        NSString *str = 
        [[string substringFromIndex:i] 
         substringToIndex:1];
        
        const char *c = 
        [str cStringUsingEncoding:
         NSASCIIStringEncoding];
        
        if ( c == NULL ) {
            b = FALSE;
            break;
        }
		
        if ((c[0] >= 0x30) && (c[0] <= 0x39))
        {
            b = TRUE;
        } else {
            b = FALSE;
            break;
        }
    }
    
    if (b)
		return TRUE;  // 数値文字列である
    else
		return FALSE;
}

@end
