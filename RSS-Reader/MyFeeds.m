//
//  MyFeeds_Tab1.m
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import "MyFeeds.h"

#import "FeedItems.h"

@interface MyFeeds ()

@end



@implementation MyFeeds



- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self createOrOpenDB];
    
    [self.tableView reloadData];
    
    NSLog(@"View did appear.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createOrOpenDB
{
    NSString *docPath = PROJECT_DIR;
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRows = 0;
    
    if (sqlite3_open([dbPathString UTF8String], &feedsDB)==SQLITE_OK)
    {
        const char *findStmt = "SELECT COUNT(*) FROM FEEDS";
        sqlite3_stmt *compiledStatement;
        
        if (sqlite3_prepare_v2(feedsDB, findStmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            //Step through to count rows.
            if (sqlite3_step(compiledStatement) != SQLITE_ERROR)
            {
                NSLog(@"db entries:%d", sqlite3_column_int(compiledStatement, 0));
                
                numRows = sqlite3_column_int(compiledStatement, 0);
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
        sqlite3_close(feedsDB);
    }
    else
    {
        NSLog(@"There was an error opening the db for getting the number of rows.");
    }
    
    // Return the number of rows in the section.
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(sqlite3_open([dbPathString UTF8String], &feedsDB) == SQLITE_OK)
    {
        //NSLog(@"The sql query is, %@",[NSString stringWithFormat:@"SELECT * FROM TASKS WHERE ID=%d",(int)indexPath.row+1]);
        
        // Setup the SQL Statement and compile it for faster access
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM FEEDS WHERE ID=%d",(int)indexPath.row+1] UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare(feedsDB, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            if(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                [cell.textLabel setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]];
                [cell.detailTextLabel setText:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)]];
            }
            else
            {
                NSLog(@"Something went wrong stepping through the SELECT query for populating cell at %d.", indexPath.row);
            }
        }
        else
        {
            NSLog(@"Something went wrong in populating the row, %d", indexPath.row + 1);
            [cell.textLabel setText:@"DB couldn't find the task"];
            [cell.detailTextLabel setText:@"DB couldn't find the date"];
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        sqlite3_close(feedsDB);
    }
    else
    {
        NSLog(@"There was a problem opening the db when populating cells.");
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *urlString = @"";
        
        if(sqlite3_open([dbPathString UTF8String], &feedsDB) == SQLITE_OK)
        {
            //NSLog(@"The sql query is, %@",[NSString stringWithFormat:@"SELECT * FROM TASKS WHERE ID=%d",(int)indexPath.row+1]);
            
            // Setup the SQL Statement and compile it for faster access
            const char *sqlStatement = [[NSString stringWithFormat:@"SELECT URL FROM FEEDS WHERE ID=%d",(int)indexPath.row+1] UTF8String];
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare(feedsDB, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                // Loop through the results and add them to the feeds array
                if(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    urlString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                else
                {
                    NSLog(@"Something went wrong stepping through the SELECT query for seguing at row %d.", indexPath.row);
                }
            }
            else
            {
                NSLog(@"Something went wrong in seguing from the row, %d", indexPath.row + 1);
            }
            // Release the compiled statement from memory
            sqlite3_finalize(compiledStatement);
            sqlite3_close(feedsDB);
        }
        else
        {
            NSLog(@"There was a problem opening the db when seguing from cells.");
        }

        [[segue destinationViewController] setUrl:urlString];
        
        NSLog(@"The url for the segue:%@",urlString);
    }
}



@end
