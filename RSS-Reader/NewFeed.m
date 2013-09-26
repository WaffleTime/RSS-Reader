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
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)confirmNewFeed:(id)sender
{
    char *error;
    
    if (sqlite3_open([dBPathString UTF8String], &feedsDB) == SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO FEEDS(TAG,URL) values ('%s', '%s')", ];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(ingredientDB, insert_stmt, NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"addNewButton pressed.");
            
            ingredient *anIngredient = [[ingredient alloc] init];
            
            [anIngredient setName:self.nameField.text];
            [anIngredient setEffect1:self.effect1.text];
            [anIngredient setEffect2:self.effect2.text];
            [anIngredient setEffect3:self.effect3.text];
            [anIngredient setEffect4:self.effect4.text];
            
            [ingredientList addObject:anIngredient];
            
            //attempting to call showAll from within addNew
            [self showAll:(id)sender];
        }
        
        sqlite3_close(ingredientDB);
    }
}



@end


