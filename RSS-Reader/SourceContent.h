//
//  SourceContent.h
//  RSS-Reader
//
//  Created by Super Student on 9/26/13.
//  Copyright (c) 2013 CS-360_Students. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceContent : UIViewController

@property (copy, nonatomic) NSString *url;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
