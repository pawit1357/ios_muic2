//
//  Webservice.h
//  muic_v2
//
//  Created by pawit on 9/29/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Webservice : NSObject{

}
+(id)Webservice;

- (void) syncronizeData;

- (BOOL) getBanner;
- (BOOL) getMenu;
- (BOOL) getContent;
- (BOOL) GetBook;
- (BOOL) GetQuestion;
- (BOOL) registerDevice:(NSString*) udid;
- (BOOL) sendFAQ:(NSString*) question andUdid:(NSString*) udid;
@end
