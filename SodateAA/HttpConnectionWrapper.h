//
//  HttpConnectionWrapper.h
//
//  Created by Hiroki Yagita on 11/04/09.
//  Copyright 2011 Hiroki Yagita. All rights reserved.
//

/*! @file */

#import <Foundation/Foundation.h>

@class HttpConnectionWrapper;


/*!
	HttpConnectionWrapper クラスのユーザーがリクエストの結果を受け取りたい時に実装してください。
 */
@protocol HttpConnectionWrapperDelegate

-(void)didReceiveAllResponse:(HttpConnectionWrapper *)connection withString:(NSString *)string;

@end

/*!
	HTTP 通信を簡単に扱えるようにするためのラッパークラスです。
 
	@see HttpConnectionWrapperDelegate
 */
@interface HttpConnectionWrapper : NSObject {
	NSMutableString *payload;
	id<HttpConnectionWrapperDelegate> delegate;
}
@property (nonatomic, retain) NSMutableString *payload;
@property (nonatomic, assign) id<HttpConnectionWrapperDelegate> delegate;

/*!
	HTTP 通信を開始します。結果を受け取る場合は HttpConnectionWrapperDelegate デリゲートを実装してください。
 
	@param	urlStr	URL文字列を指定してください。
	@see HttpConnectionWrapperDelegate
 */
-(void)startWithString:(NSString *)urlStr;

@end

