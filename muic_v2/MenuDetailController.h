//
//  MenuDetailController.h
//  muic_v2
//
//  Created by pawit on 9/19/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelContent.h"

@interface MenuDetailController : UIViewController<UIWebViewDelegate>{
    

    
}

@property (weak, nonatomic) IBOutlet UIWebView *wvContent;

@property (strong, nonatomic) ModelContent *contentItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
