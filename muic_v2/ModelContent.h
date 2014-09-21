//
//  ModelContent.h
//  muic_v2
//
//  Created by pawit on 9/19/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelContent : NSObject{

NSInteger id;
NSInteger app_id;
NSInteger menu_id;
NSString *title;
NSString *sub_title;
NSString *description;
NSString *image_url;
NSString *status;
}

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger app_id;
@property (nonatomic, assign) NSInteger menu_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *sub_title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *image_url;
@property (nonatomic, retain) NSString *status;

@end
