//
//  MyFeeds_Tab1.h
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface MyFeeds : UITableViewController
{
    sqlite3 *feedsDB;
    NSString *dbPathString;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


