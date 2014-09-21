//
//  Menu.h
//  muic_v2
//
//  Created by pawit on 8/30/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ModelMenu : NSObject {
    
    NSInteger id;
    NSInteger app_id;
    NSInteger parent;
    NSString * name;
    NSString * icon;
    NSInteger type;
    NSInteger order;
    NSString * status;

}
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger app_id;
@property (nonatomic, assign) NSInteger parent;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, retain) NSString *status;


@end