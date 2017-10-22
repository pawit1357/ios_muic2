//
//  ModelFaq.h
//  muic_v2
//
//  Created by pawit on 9/29/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelFaq : NSObject{
    
    NSInteger id;
    NSInteger app_id;
    NSString *question;
    NSString *status;
    NSString *create_date;
    NSString *isRead;
    NSString *answer;
}

@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger app_id;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *create_date;
@property (nonatomic, retain) NSString *isRead;
@property (nonatomic, retain) NSString *answer;


@end
