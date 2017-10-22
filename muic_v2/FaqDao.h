//
//  FaqDao.h
//  muic_v2
//
//  Created by pawit on 9/29/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelFaq.h"

@interface FaqDao : NSObject{
    sqlite3 *db;
    
    NSString *databaseName;
    NSString *databasePath;
}

+(id)FaqDao;

- (void) initDatabase;


- (BOOL) saveQuestion:(ModelFaq*)model;
- (BOOL) updateQuestion:(ModelFaq*)model;
- (BOOL) deleteQuestion:(ModelFaq*)model;
- (BOOL) deleteAllQuestion;
- (NSMutableArray *) getAllQuestion;
- (ModelFaq *) getSingleQuestion:(NSInteger) id;

@end
