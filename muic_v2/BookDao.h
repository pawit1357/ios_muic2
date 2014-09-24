//
//  BookDao.h
//  muic_v2
//
//  Created by pawit on 9/23/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Modelbook.h"

@interface BookDao : NSObject{
    sqlite3 *db;
    
    NSString *databaseName;
    NSString *databasePath;
}

+(id)BookDao;

- (void) initDatabase;
- (BOOL) saveModel:(ModelBook*)model;
- (BOOL) updateModel:(ModelBook*)model;
- (BOOL) deleteModel:(ModelBook*)model;
- (NSMutableArray *) getAll;
- (NSMutableArray *) getBookByType:(NSString*) type;
- (NSArray *) getSingle:(NSInteger) id;
@end

