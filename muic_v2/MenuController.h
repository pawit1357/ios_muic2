//
//  MenuController.h
//  muic_v2
//
//  Created by pawit on 8/31/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    UIScrollView* src;
	
}

@property (retain, nonatomic) IBOutlet UIScrollView *src;
@property (strong, nonatomic) IBOutlet UITableView *appListView;

@property (strong, nonatomic) NSMutableArray *appList;
@property (strong, nonatomic) NSMutableArray *bannerList;

- (void)setupScrollView:(UIScrollView*)scrMain ;

@end
