//
//  BookDao.m
//  muic_v2
//
//  Created by pawit on 9/23/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "BookDao.h"
#import "ModelBook.h"

@implementation BookDao

static BookDao *_bookDao = nil;

+(id)BookDao{
    @synchronized(self) {
        
        if (_bookDao == nil)
            _bookDao = [[self alloc] init];
    }
    return _bookDao;
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


- (BOOL) saveModel:(ModelBook *)model
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

- (BOOL) updateModel:(ModelBook *)model
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
        NSString *querySQL = @"SELECT id,book_name,book_title,book_cover,book_author,callNo,division,program,type,status,flag,recommented,create_date FROM tb_book Where status='A'";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelBook *model = [[ModelBook alloc] init];
                
                model.id = sqlite3_column_int(statement, 0);
                model.book_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                model.book_title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                model.book_cover = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.book_author = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.callNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                model.division = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                model.program = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                model.type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                model.status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                model.flag = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                model.recommended = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                //model.create_date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                [resultList addObject:model];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
    
    return resultList;
}

- (NSMutableArray *) getBookByType:(NSString *)type
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {

        NSString *querySQL=[NSString stringWithFormat:@"SELECT id,book_name,book_title,book_cover,book_author,callNo,division,program,type,status,flag,recommented,create_date FROM tb_book Where status='A' and type='%@'" ,type];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelBook *model = [[ModelBook alloc] init];
                
                model.id = sqlite3_column_int(statement, 0);
                model.book_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                model.book_title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                model.book_cover = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.book_author = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.callNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                model.division = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                model.program = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                model.type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                model.status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                model.flag = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                model.recommended = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                //model.create_date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
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
- (BOOL) deleteModel:(ModelBook *)model
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
