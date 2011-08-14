//
//  HttpConnectionWrapper.h
//
//  Created by Hiroki Yagita on 11/04/09.
//  Copyright 2011 Hiroki Yagita. All rights reserved.
//

#import "HttpConnectionWrapper.h"


@implementation HttpConnectionWrapper
@synthesize payload, delegate;


-(void)startWithString:(NSString *)urlStr {
	NSLog(@"%s %@", __FUNCTION__, urlStr);

	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:10.0];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	if (conn) {
		NSLog(@"%s connection started.", __FUNCTION__);
		self.payload = [[[NSMutableString alloc] initWithCapacity:65536] autorelease];
	} else {
		NSLog(@"%s connection failed.", __FUNCTION__);
	}
    [conn release];
}

#pragma mark -
#pragma mark NSURLConnection delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
	NSLog(@"%s connection:%@ response:%@", __FUNCTION__, connection, [httpResponse allHeaderFields]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"%s connection:%@", __FUNCTION__, connection);

	// TODO: encoding must be decide response header.
	//NSJapaneseEUCStringEncoding
	NSString *s = [[NSString alloc] initWithData:data
										encoding:NSUTF8StringEncoding];
	if (s) [self.payload appendString:s];
    [s release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"%s connection:%@", __FUNCTION__, connection);
	
	[self.delegate didReceiveAllResponse:self withString:self.payload];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
	NSLog(@"%s connection failture:%@", __FUNCTION__, error);
	
	[self.delegate didReceiveAllResponse:self withString:nil];
}


@end
