//
//  AppConfigDao.m
//  muic_v2
//
//  Created by pawit on 9/29/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "AppConfigDao.h"

@implementation AppConfigDao

static AppConfigDao *_appConfigDao = nil;

+(id)AppConfigDao{
    @synchronized(self) {
        
        if (_appConfigDao == nil)
            _appConfigDao = [[self alloc] init];
    }
    return _appConfigDao;
}

- (id)init {
    
    if (self = [super init]) {
        
        // Setup some globals
        databaseName = @"muicv2.db";
        
        // Get the path to the documents directory and append the databaseName
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
        
        // Execute the "checkAndCreateDatabase" function
        [self initDatabase];
    }
    return self;
}

- (void) initDatabase {
    
    BOOL success;
    
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(success) return;
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    // Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
}

- (NSArray *) getSingle
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT id,app_version FROM tb_config where status='A'";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelConfig *model = [[ModelConfig alloc] init];
                model.id = sqlite3_column_int(statement, 0);
                model.app_version = sqlite3_column_int(statement, 1);

                [resultList addObject:model];
            }
            sqlite3_finalize(statement);
        }else{
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(db));
        }
        sqlite3_close(db);
    }
    
    return resultList;
}

- (BOOL) update:(ModelConfig*)model;
{
    
    BOOL success = false;
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSLog(@"Exitsing data, Update Please");
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tb_config set app_version = '%ld' WHERE id =1",(long)model.app_version];
        
        const char *update_stmt = [updateSQL UTF8String];
        //sqlite3_bind_int(statement, 1, config.id);
        if (sqlite3_prepare_v2(db, update_stmt, -1, &statement, NULL)==SQLITE_OK) {
            
            NSLog(@"Query Prepared to execute");
        }
        
        if(sqlite3_step(statement) != SQLITE_DONE){
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(db));
        }else{
            success = true;
            NSLog(@"Executed");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    
    return success;
}

@end
