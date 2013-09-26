//
//  NewFeed.m
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import "NewFeed.h"



@interface NewFeed ()

@end



@implementation NewFeed

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createOrOpenDB];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)createOrOpenDB
{
    NSString *docPath = PROJECT_DIR;
    
    dbPathString = [docPath stringByAppendingPathComponent:@"feedsDB.db"];
    
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        //creat db here
        if (sqlite3_open(dbPath, &feedsDB)==SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FEEDS (ID INTEGER PRIMARY KEY, TAG CHAR(30), URL CHAR(255))";
            sqlite3_exec(feedsDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(feedsDB);
        }
    }
}






- (IBAction)confirmNewFeed:(id)sender
{
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &feedsDB) == SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO FEEDS(TAG,URL) values ('%s', '%s')", [self.tagField.text UTF8String], [self.urlField.text UTF8String]];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(feedsDB, insert_stmt, NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"confirmNewFeed pressed.");
            
            //[self showAll:(id)sender];
        }
        
        sqlite3_close(feedsDB);
    }
}



@end


