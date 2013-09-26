//
//  NewFeed.h
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NewFeed : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *tagField;

@property (strong, nonatomic) IBOutlet UITextField *urlField;



- (IBAction)confirmNewFeed:(id)sender;




@end


