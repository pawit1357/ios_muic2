//
//  AppConfigDao.h
//  muic_v2
//
//  Created by pawit on 9/29/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelConfig.h"

@interface AppConfigDao : NSObject{
    sqlite3 *db;
    
    NSString *databaseName;
    NSString *databasePath;
}

+(id)AppConfigDao;

- (void) initDatabase;

- (BOOL) updateVersion:(NSInteger)version;
- (BOOL) updateUdid:(NSString*)udid;

- (BOOL) updatePopupURLid:(NSInteger) popupid;

- (NSInteger) getCurrentVersion;
- (NSString*) getUdid;
- (NSInteger) getPopupId;

@end
