//
//  BookSubDetailController.h
//  muic_v2
//
//  Created by pawit on 10/11/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelBook.h"

@interface BookSubDetailController : UIViewController<UIWebViewDelegate>{
    NSFileManager *fileManager;
    NSString *documentsDirectory;
}

@property (strong, nonatomic) ModelBook *bookItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIWebView *wvTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgBook;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lbCallNo;
@property (weak, nonatomic) IBOutlet UILabel *lbDivision;
@property (weak, nonatomic) IBOutlet UILabel *lbProgram;

@end
