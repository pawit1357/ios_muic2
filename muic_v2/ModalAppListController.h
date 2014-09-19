//
//  MenuController.h
//  muic_v2
//
//  Created by pawit on 8/31/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalAppListController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UITableView *vApp;

@property (strong, nonatomic) NSMutableArray *appList;
@end
