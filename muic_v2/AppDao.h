//
//  AppDao.h
//  muic_v2
//
//  Created by pawit on 8/31/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelApp.h"

@interface AppDao : NSObject{
    sqlite3 *db;
    
    NSString *databaseName;
    NSString *databasePath;
}
+(id)AppDao;

- (void) initDatabase;

- (BOOL) saveModel:(ModelApp*)model;
- (BOOL) updateModel:(ModelApp*)model;
- (BOOL) deleteModel:(ModelApp*)model;
- (NSMutableArray *) getAll;
- (NSArray *) getSingle:(NSInteger) id;

@end
