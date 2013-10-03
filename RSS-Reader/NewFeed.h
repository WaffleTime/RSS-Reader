//
//  NewFeed.h
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "sqlite3.h"



@interface NewFeed : UIViewController
{
    NSString *dbPathString;
    
    sqlite3 *feedsDB;
}


@property (strong, nonatomic) IBOutlet UITextField *tagField;

@property (strong, nonatomic) IBOutlet UITextField *urlField;



- (IBAction)confirmNewFeed:(id)sender;

- (IBAction)taskEntered:(UITextField *)textField;

- (IBAction)textFieldTagLimiter:(UITextField *)textField;

- (IBAction)textFieldURLLimiter:(UITextField *)textField;

- (void)textFieldShouldReturn:(UITextField *)textField;

@end


