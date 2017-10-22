//
//  PromotionDetailController.h
//  muic_v2
//
//  Created by pawit on 9/22/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionDetailController : UIViewController{
    UILabel *lbTitle;
    UILabel *lbDesc;
    UILabel *lbCreateDate;
    UIImageView *newImg;
    NSFileManager *fileManager;
    NSString *documentsDirectory;
}


@property (weak, nonatomic) IBOutlet UITableView *tvMain;

@property (strong, nonatomic) NSMutableArray *contentList;
@end
