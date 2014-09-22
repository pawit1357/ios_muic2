//
//  NewsDetailController.h
//  muic_v2
//
//  Created by pawit on 9/22/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelContent.h"

@interface NewsDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *wvMain;
@property (strong, nonatomic) ModelContent *contentItem;

@end
