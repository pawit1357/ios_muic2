//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController: UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIScrollView *svBanner;
@property (strong, nonatomic) IBOutlet UIView *vMain;
@property (weak, nonatomic) IBOutlet UITableView *tvContent;

@property (strong, nonatomic) NSMutableArray *bannerList;
@property (strong, nonatomic) NSMutableArray *contentList;
@property (strong, nonatomic) NSArray *appInfo;

- (void)setupScrollView:(UIScrollView*)svMain ;

@end
