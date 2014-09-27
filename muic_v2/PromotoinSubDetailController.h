//
//  PromotoinSubDetailController.h
//  muic_v2
//
//  Created by pawit on 9/23/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelContent.h"

@interface PromotoinSubDetailController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *wvMain;
@property (strong, nonatomic) ModelContent *contentItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
