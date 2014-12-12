//
//  ModelPopup.h
//  muic_v2
//
//  Created by pawit on 10/15/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPopup : NSObject{
    NSInteger id;
    NSString *url;
    NSString *message;
}
@property (nonatomic) NSInteger id;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *message;
@end
