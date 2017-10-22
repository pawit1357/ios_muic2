//
//  MyUtils.h
//  muic_v2
//
//  Created by pawit on 10/6/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtils : NSObject

+(id)MyUtils;

-(NSString*) cleanSpecialChar:(NSString*)str;

-(NSString*) cleanSQLInjectionChar:(NSString*)str;

-(UIColor *)colorFromHexString:(NSString *)hexString;

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
