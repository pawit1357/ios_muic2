//
//  BookSubDetailController.h
//  muic_v2
//
//  Created by pawit on 10/11/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelBook.h"

@interface BookSubDetailController : UIViewController

@property (strong, nonatomic) ModelBook *bookItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
