//
//  MenuDao.m
//  muic_v2
//
//  Created by pawit on 8/30/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "MenuDao.h"
#import <CoreData/CoreData.h>
#import "ModelMenu.h"

@implementation MenuDao

static MenuDao *_menuDao = nil;

+(id)MenuDao{
    @synchronized(self) {
        
        if (_menuDao == nil)
            _menuDao = [[self alloc] init];
    }
    return _menuDao;
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


- (BOOL) saveMenu:(ModelMenu *)model
{
    BOOL success = false;
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        //NSLog(@"New data, Insert Please");
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO tb_menu (id,app_id,parent,menu_item,menu_icon,menu_type,menu_order,status,menu_item_src) VALUES (%ld, %ld, %ld, '%@', '%@', %ld,%ld,'%@','%@')",
                               (long)model.id,
                               (long)model.app_id,
                               (long)model.parent,
                               model.name,
                               model.icon,
                               (long)model.type,
                               (long)model.order,
                               model.status,
                               model.description
                               ];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(db, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }else{
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(db));
        }    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return success;
}

- (BOOL) updateMenu:(ModelMenu *)model
{
    
    BOOL success = false;
    
     sqlite3_stmt *statement = NULL;
     const char *dbpath = [databasePath UTF8String];
     
     if (sqlite3_open(dbpath, &db) == SQLITE_OK)
     {
         NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tb_menu set app_id='%ld',parent='%ld',menu_item='%@',menu_icon='%@',menu_type='%ld',menu_order='%ld',status='%@',menu_item_src='%@' WHERE id = %ld",
                                (long)model.app_id,
                                (long)model.parent,model.name,model.icon,(long)model.type,(long)model.order,model.status,model.description,(long)model.id];
     
         const char *update_stmt = [updateSQL UTF8String];
         if (sqlite3_prepare_v2(db, update_stmt, -1, &statement, NULL)==SQLITE_OK) {
             if(sqlite3_step(statement) != SQLITE_DONE){
                 NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(db));
             }else{
                 success = true;
                 //NSLog(@"Executed");
             }
         }
     }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return success;
}
//get a list of all our employees

- (NSMutableArray *) getAllMenu
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = @"select id,app_id,parent,menu_item,menu_icon,menu_type,menu_item_src from tb_menu where status='A' and menu_type not in(1,11,2,21,31,41,61,71) order by menu_order asc";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //Add back
            ModelMenu *tmp = [[ModelMenu alloc] init];
            tmp.id= 0;
            tmp.app_id= 0;
            tmp.parent= -1;
            tmp.name= @"Home";
            tmp.icon= @"home_menu.png";
            tmp.type= -1;
            tmp.description = @" ";
            [resultList addObject:tmp];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelMenu *model = [[ModelMenu alloc] init];
                model.id= sqlite3_column_int(statement, 0);
                model.app_id= sqlite3_column_int(statement, 1);
                model.parent= sqlite3_column_int(statement, 2);
                model.name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.icon= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.type= sqlite3_column_int(statement,5);
                                model.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                [resultList addObject:model];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
    
    return resultList;
}

- (NSMutableArray *) getAllMainMenu
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = @"select id,app_id,parent,menu_item,menu_icon,menu_type,menu_item_src from tb_menu where status='A' and menu_type not in(1,11,2,21,31,41,61,71) and parent = -1 order by menu_order asc";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //Add back
            ModelMenu *tmp = [[ModelMenu alloc] init];
            tmp.id= 0;
            tmp.app_id= 0;
            tmp.parent= -1;
            tmp.name= @"Home";
            tmp.icon= @"home_menu.png";
            tmp.type= 0;
            tmp.description = @" ";
            [resultList addObject:tmp];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelMenu *model = [[ModelMenu alloc] init];
                model.id= sqlite3_column_int(statement, 0);
                model.app_id= sqlite3_column_int(statement, 1);
                model.parent= sqlite3_column_int(statement, 2);
                model.name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.icon= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.type= sqlite3_column_int(statement,5);
                                model.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                [resultList addObject:model];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
    
    return resultList;
}
- (NSMutableArray *) getParentMenu:(ModelMenu *)model
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select id,app_id,parent,menu_item,menu_icon,menu_type,menu_item_src from tb_menu where status='A' and menu_type not in(1,11,2,21,31,41,61,71)  and parent=(select parent from tb_menu where id  =%ld) order by menu_order asc",(long)model.parent];
        //NSLog(@"Get menu sql = %@",querySQL);
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //Add back
            ModelMenu *tmp = [[ModelMenu alloc] init];
            tmp.id= 0;
            tmp.app_id= 0;
            tmp.parent= -1;
            tmp.name= @"Home";
            tmp.icon= @"home";
            tmp.type= -1;
            tmp.description = @" ";
            [resultList addObject:tmp];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelMenu *model = [[ModelMenu alloc] init];
                model.id= sqlite3_column_int(statement, 0);
                model.app_id= sqlite3_column_int(statement, 1);
                model.parent= sqlite3_column_int(statement, 2);
                model.name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.icon= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.type= sqlite3_column_int(statement,5);
                model.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
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

- (NSMutableArray *) getChildMenu:(ModelMenu *)model
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select id,app_id,parent,menu_item,menu_icon,menu_type,menu_item_src from tb_menu where status='A' and menu_type not in(1,11,2,21,31,41,61,71)  and parent=%ld order by menu_order asc",(long)model.id];
        //NSLog(@"Get menu sql = %@",querySQL);
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //Add back
            ModelMenu *tmp = [[ModelMenu alloc] init];
            tmp.id= 0;
            tmp.app_id= 0;
            tmp.parent= -1;
            tmp.name= @"Home";
            tmp.icon= @"home_menu.png";
            tmp.type= -1;
            tmp.description = @" ";
            [resultList addObject:tmp];
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelMenu *model = [[ModelMenu alloc] init];
                model.id= sqlite3_column_int(statement, 0);
                model.app_id= sqlite3_column_int(statement, 1);
                model.parent= sqlite3_column_int(statement, 2);
                model.name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.icon= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.type= sqlite3_column_int(statement,5);
                model.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
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

- (NSArray *) getSingleMenu:(NSInteger)id
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL =[NSString stringWithFormat: @"select id,app_id,parent,menu_item,menu_icon,menu_type,menu_item_src from tb_menu where id=%ld",(long)id];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ModelMenu *model = [[ModelMenu alloc] init];
                model.id= sqlite3_column_int(statement, 0);
                model.app_id= sqlite3_column_int(statement, 1);
                model.parent= sqlite3_column_int(statement, 2);
                model.name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.icon= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.type= sqlite3_column_int(statement,5);
                model.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                [resultList addObject:model];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
    
    return resultList;
}

- (ModelMenu *) getAppInfo:(NSInteger)id;
{
    ModelMenu *model = nil;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL =[NSString stringWithFormat: @"select id,app_id,parent,menu_item,menu_icon,menu_type,menu_item_src from tb_menu where app_id=%ld and parent=-1",(long)id];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                model = [[ModelMenu alloc] init];
                model.id= sqlite3_column_int(statement, 0);
                model.app_id= sqlite3_column_int(statement, 1);
                model.parent= sqlite3_column_int(statement, 2);
                model.name= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                model.icon= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                model.type= sqlite3_column_int(statement,5);
                model.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }

    
    return model;
}

//delete the employee from the database
- (BOOL) deleteMenu:(ModelMenu *)model
{
    BOOL success = false;

     sqlite3_stmt *statement = NULL;
     const char *dbpath = [databasePath UTF8String];
     
     if (sqlite3_open(dbpath, &db) == SQLITE_OK)
     {


     NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from tb_menu WHERE id = %ld",(long)model.id];
     
     const char *delete_stmt = [deleteSQL UTF8String];
     sqlite3_prepare_v2(db, delete_stmt, -1, &statement, NULL );

     if (sqlite3_step(statement) == SQLITE_DONE)
     {
         success = true;
     }
     }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return success;
}

- (BOOL) deleteAllMenu{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSLog(@"Exitsing data, Delete Please");
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from tb_menu"];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(db, delete_stmt, -1, &statement, NULL );
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return success;
}

@end

