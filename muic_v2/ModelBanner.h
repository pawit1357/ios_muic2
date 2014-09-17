//
//  ModelBanner.h
//  muic_v2
//
//  Created by pawit on 9/17/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBanner : NSObject{
    NSInteger id;
    NSInteger app_id;
    NSString * image_url;
    NSString * status;
}

@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger app_id;
@property (nonatomic, retain) NSString *image_url;
@property (nonatomic, retain) NSString *status;

@end
