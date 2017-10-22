//
//  FaqDetailControllerViewController.h
//  muic_v2
//
//  Created by pawit on 10/7/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaqDetailControllerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
        UIBarButtonItem *backButton;
    
    NSInteger expandedRowIndex;
}

@property (strong, nonatomic) NSMutableArray *faqList;
@property (weak, nonatomic) IBOutlet UITableView *tvFaqList;

@end
