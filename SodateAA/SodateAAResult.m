//
//  SodateAAResult.m
//  SodateAA
//
//  Created by 熊谷 大樹 on 11/07/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SodateAAResult.h"

@implementation SodateAAResult

@synthesize _aaString;

@synthesize _aaStringParameter;

@synthesize _barcodeString;

- (id)init
{
    self = [super init];
    if (self) {
        _aaString = @"(´・ω・`)";
        _aaStringParameter = @"";
        _barcodeString = @"不明";
    }
    
    return self;
}

- (void)dealloc
{
    [_aaString release]; _aaString = nil;
    [_aaStringParameter release]; _aaStringParameter = nil;
    [_barcodeString release]; _barcodeString = nil;
    [super dealloc];
}

@end
