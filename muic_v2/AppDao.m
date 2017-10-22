//
//  AppDao.m
//  muic_v2
//
//  Created by pawit on 8/31/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "AppDao.h"
#import "Modelapp.h"

@implementation AppDao

static AppDao *_appDao = nil;

+(id)AppDao{
    @synchronized(self) {
        
        if (_appDao == nil)
            _appDao = [[self alloc] init];
    }
    return _appDao;
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


- (BOOL) saveModel:(ModelApp *)model
{
    BOOL success = false;
    /*
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSLog(@"New data, Insert Please");
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO tb_app (id, stationId, lane) VALUES (\"%@\", \"%@\", \"%@\")",
                               [NSString stringWithFormat:@"%d", model.id],
                               config.stationId,
                               config.lane ];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(db, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    */
    
    return success;
}

- (BOOL) updateModel:(ModelApp *)model
{
    
    BOOL success = false;
/*
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSLog(@"Exitsing data, Update Please");
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TB_CONFIG set stationId = '%@', lane = '%@'  WHERE id = 1",
                               config.stationId,
                               config.lane];
        
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
    */
    return success;
}
//get a list of all our employees

- (NSMutableArray *) getAll
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT id,name,description,image_url FROM tb_app where status='A'";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelApp *model = [[ModelApp alloc] init];
                model.id = sqlite3_column_int(statement, 0);
                model.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                model.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                model.image_url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [resultList addObject:model];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
    
    return resultList;
}

- (NSArray *) getSingle:(NSInteger)id
{
    NSMutableArray *resultList = [self getAll];
    
    
    return [resultList objectAtIndex:0];
}

//delete the employee from the database
- (BOOL) deleteModel:(ModelApp *)model
{
    BOOL success = false;
    /*
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        if (config.id > 0) {
            NSLog(@"Exitsing data, Delete Please");
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from TB_CONFIG WHERE id = ?"];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(db, delete_stmt, -1, &statement, NULL );
            sqlite3_bind_int(statement, 1, config.id);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"New data, Nothing to delete");
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    */
    return success;
}

@end
