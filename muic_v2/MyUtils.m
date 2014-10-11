//
//  MyUtils.m
//  muic_v2
//
//  Created by pawit on 10/6/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "MyUtils.h"

@implementation MyUtils

static MyUtils *_myUtils = nil;

+(id)MyUtils{
    @synchronized(self) {
        
        if (_myUtils == nil)
            _myUtils = [[self alloc] init];
    }
    return _myUtils;
}

-(NSString*) cleanSpecialChar:(NSString*)str{
    if (str != nil){
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"[@#$.',!\\d]" options:0 error:nil];
    
    NSString *output = [re stringByReplacingMatchesInString:str
                                                    options:0
                                                      range:NSMakeRange(0, [str length])
                                               withTemplate:@""];
    return output;
    }
    return @" ";
}

@end
