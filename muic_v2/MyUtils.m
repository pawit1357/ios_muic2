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

-(NSString*) cleanSQLInjectionChar:(NSString*)str{
    if (str != nil){
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"'" options:0 error:nil];
        
        NSString *output = [re stringByReplacingMatchesInString:str
                                                        options:0
                                                          range:NSMakeRange(0, [str length])
                                                   withTemplate:@""];
        return output;
    }
    return @" ";
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
