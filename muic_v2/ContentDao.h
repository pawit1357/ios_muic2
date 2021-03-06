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
- (BOOL) saveContent:(ModelContent*)model;
- (BOOL) updateContent:(ModelContent*)model;
- (BOOL) deleteContent:(ModelContent*)model;
- (BOOL) deleteAllContent;

-(ModelContent*) getContentById:(ModelContent*)modelContent;

- (NSMutableArray *) getAllContent;
- (NSMutableArray *) getNews;
- (NSMutableArray *) getAnnounce;
- (ModelContent *) getSingleContent:(NSInteger) id;

- (BOOL) updateReadContent:(ModelContent*)model;

- (NSMutableArray *) getMenuContent:(NSInteger) menu_id;
@end