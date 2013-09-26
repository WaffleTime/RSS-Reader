//
//  MyFeeds_Tab2.m
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import "EditFeeds.h"

@interface EditFeeds ()

-(void)deleteData:(NSString *)deleteQuery :(NSString *) selectQuery;

@end

@implementation EditFeeds

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createOrOpenDB
{
    NSString *docPath = PROJECT_DIR;
    
    dbPathString = [docPath stringByAppendingPathComponent:@"ToDoList.db"];
    
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        //creat db here
        if (sqlite3_open(dbPath, &feedDB)==SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FEEDS (ID INTEGER PRIMARY KEY, TAG CHAR(30), URL CHAR(255))";
            sqlite3_exec(feedDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(feedDB);
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
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    return cell;
}

- (IBAction)deleteMode:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    NSLog(@"delete mode!");
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteData:[NSString stringWithFormat:@"DELETE FROM FEEDS WHERE ID=%d", indexPath.row+1] :[NSString stringWithFormat:@"UPDATE FEEDS SET ID=ID-1 WHERE ID>%d",indexPath.row+1]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)deleteData:(NSString *)deleteQuery :(NSString *) selectQuery
{
    
    // Open the database from the users filessytem
    if(sqlite3_open([dbPathString UTF8String], &feedDB) == SQLITE_OK)
    {
        char *error;
        
        if (sqlite3_exec(feedDB, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Task deleted");
            
            
            if (sqlite3_exec(feedDB, [selectQuery UTF8String], NULL, NULL, &error)==SQLITE_OK)
            {
                NSLog(@"Subsequent item's IDs have been updated.");
            }
            else
            {
                NSLog(@"Subsequent item's IDs have not been updated.");
            }
        }
        else
        {
            NSLog(@"Task wasn't deleted!");
        }
    }
}


@end
