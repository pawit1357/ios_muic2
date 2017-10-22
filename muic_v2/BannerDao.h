//
//  BannerDao.h
//  muic_v2
//
//  Created by pawit on 9/17/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelBanner.h"

@interface BannerDao : NSObject{
sqlite3 *db;

NSString *databaseName;
NSString *databasePath;
}

+(id)BannerDao;

- (void) initDatabase;
- (BOOL) saveModel:(ModelBanner*)model;
- (BOOL) updateModel:(ModelBanner*)model;
- (BOOL) deleteModel:(ModelBanner*)model;
- (BOOL) deleteAllBook;
- (NSMutableArray *) getAll;
- (NSArray *) getSingle:(NSInteger) id;
@end
