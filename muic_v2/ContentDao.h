//
//  ContentDao.h
//  muic_v2
//
//  Created by pawit on 9/19/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelContent.h"

@interface ContentDao : NSObject{
    sqlite3 *db;
    
    NSString *databaseName;
    NSString *databasePath;
}

+(id)ContentDao;

- (void) initDatabase;
- (BOOL) saveModel:(ModelContent*)model;
- (BOOL) updateModel:(ModelContent*)model;
- (BOOL) deleteModel:(ModelContent*)model;
- (NSMutableArray *) getAll;
- (NSArray *) getSingle:(NSInteger) id;

- (NSMutableArray *) getMenuContent:(int) menu_id;
@end