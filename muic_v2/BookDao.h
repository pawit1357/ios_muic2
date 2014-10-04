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
- (BOOL) saveBook:(ModelBook*)model;
- (BOOL) updateBook:(ModelBook*)model;
- (BOOL) deleteBook:(ModelBook*)model;
- (BOOL) deleteAllBook;
- (NSMutableArray *) getAllBook;
- (NSMutableArray *) getBookByType:(NSString*) type;
- (NSMutableArray *) getBookRecommted:(NSString*) type;
- (NSMutableArray *) getBookRelease:(NSString*) type;
- (NSMutableArray *) getSingleBook:(NSInteger) id;
@end

