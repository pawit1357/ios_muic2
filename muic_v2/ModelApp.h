//
//  ModelApp.h
//  muic_v2
//
//  Created by pawit on 8/31/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelApp : NSObject{
    NSInteger id;
    NSString * name;
    NSString * description;
    NSString * image_url;
    NSString * status;
    NSString * remark;
}
@property (nonatomic) NSInteger id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *image_url;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *remark;

@end


