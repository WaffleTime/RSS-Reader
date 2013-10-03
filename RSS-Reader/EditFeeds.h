//
//  MyFeeds_Tab2.h
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface EditFeeds: UITableViewController
{
    sqlite3 *feedsDB;
    NSString *dbPathString;
}

- (void)createOrOpenDB;

- (IBAction)deleteMode:(id)sender;

@end
