//
//  MenuDao.h
//  muic_v2
//
//  Created by pawit on 8/30/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "ModelMenu.h"

@interface MenuDao : NSObject{
    sqlite3 *db;
    
    NSString *databaseName;
    NSString *databasePath;
}

+(id)MenuDao;

- (void) initDatabase;
- (BOOL) saveMenu:(ModelMenu*)model;
- (BOOL) updateMenu:(ModelMenu*)model;
- (BOOL) deleteMenu:(ModelMenu*)model;
- (BOOL) deleteAllMenu;

- (NSMutableArray *) getChildMenu:(ModelMenu*)model;
- (NSMutableArray *) getParentMenu:(ModelMenu *)model;
- (NSMutableArray *) getAllMainMenu;
- (NSMutableArray *) getAllMenu;
- (NSArray *) getSingleMenu:(NSInteger) id;
@end