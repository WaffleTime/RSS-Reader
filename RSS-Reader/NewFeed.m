//
//  NewFeed.m
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import "NewFeed.h"



@interface NewFeed ()

-(void)createOrOpenDB;

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    dbPathString = [docPath stringByAppendingPathComponent:@"Feeds.db"];
    
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
    //Both textFields need to have text entered before they can be added into the feedDB.
    if (![_tagField.text isEqualToString:@""]
        && ![_urlField.text isEqualToString:@""])
    {
        char *error;
        
        if (sqlite3_open([dbPathString UTF8String], &feedsDB) == SQLITE_OK)
        {
            int feedID = -1;
            
            const char *findStmt = "SELECT COUNT(*) FROM FEEDS";
            sqlite3_stmt *compiledStatement;
            
            if (sqlite3_prepare_v2(feedsDB, findStmt, -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                //Step through to count rows.
                if (sqlite3_step(compiledStatement) != SQLITE_ERROR)
                {
                    NSLog(@"db id will be %d", sqlite3_column_int(compiledStatement, 0) + 1);
                    
                    feedID = sqlite3_column_int(compiledStatement, 0) + 1;
                }
                else
                {
                    NSLog(@"There was an error executing the COUNT(*) query for getting the number of rows.");
                }
            }
            else
            {
                NSLog(@"There was an error preparing the COUNT(*) query for getting the number of rows.");
            }
            sqlite3_finalize(compiledStatement);
            
            if (feedID != -1)
            {
                NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO FEEDS VALUES (%d,'%s','%s')", feedID, [self.tagField.text UTF8String], [self.urlField.text UTF8String]];
                
                const char *insert_stmt = [insertStmt UTF8String];
                
                if (sqlite3_exec(feedsDB, insert_stmt, NULL, NULL, &error) == SQLITE_OK)
                {
                    NSLog(@"confirmNewFeed pressed.");
                }
                else
                {
                    NSLog(@"INSERT query failed to execute.");
                }
            }
            else
            {
                NSLog(@"Item not added to db.");
            }
            
            sqlite3_close(feedsDB);
        }
        else
        {
            NSLog(@"DB failed to open when confirming a new feed.");
        }
    }
}


//This is called when the Task textfield is done entering text into it. The keyboard's return button and tapping outside of the
//  screen will trigger this.
- (IBAction)taskEntered:(UITextField *)textField
{
    [textField resignFirstResponder];
}


//This limits the TextField belonging to the feed's tag.
- (IBAction)textFieldTagLimiter:(UITextField *)textField
{
    //NSLog(@"Limiting tag text");
    
    int limit = 30;
    
    if ([textField.text length] > limit) {
        textField.text = [textField.text substringToIndex:limit];
    }
}


//This limits the TextField belonging to the feed's url.
- (IBAction)textFieldURLLimiter:(UITextField *)textField
{
    //NSLog(@"Limiting url text");
    
    int limit = 255;
    
    if ([textField.text length] > limit) {
        textField.text = [textField.text substringToIndex:limit];
    }
}


@end


