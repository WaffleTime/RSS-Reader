//
//  AvailableFeeds.h
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FeedItems : UITableViewController <NSXMLParserDelegate>

@property (copy, nonatomic, getter = getUrl, setter = setUrl:) NSString *url;

@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end


