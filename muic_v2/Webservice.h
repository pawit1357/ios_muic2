//
//  Webservice.h
//  muic_v2
//
//  Created by pawit on 9/29/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelPopup.h"

@interface Webservice : NSObject{

}
+(id)Webservice;

- (void) syncronizeData;

- (BOOL) getBanner;
- (BOOL) getMenu;
- (BOOL) getContent;
//- (BOOL) getNewsEvent;
- (BOOL) GetBook;
- (BOOL) GetQuestion;
- (BOOL) registerDevice:(NSString*) udid andPhoneType:(NSString*)phone_type;
- (NSInteger) isUpdateApp;
- (ModelPopup*) GetPopup;
@end
