//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"

@interface MainViewController: UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITabBarDelegate,CustomIOS7AlertViewDelegate>{
    
    UILabel *lbTitle;
    UILabel *lbDesc;
    UILabel *lbCreateDate;
    UIImageView *newImg;
    NSFileManager *fileManager;
    NSString *documentsDirectory;
    
    NSTimer *timer;
}

/*
@property (weak, nonatomic) IBOutlet UITabBarItem *btnNews;
@property (weak, nonatomic) IBOutlet UITabBarItem *btnAnnounce;
*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spiner;

@property (weak, nonatomic) IBOutlet UITableView *tvContent;


@property (weak, nonatomic) IBOutlet UIScrollView *svBanner;


@property (strong, nonatomic) NSMutableArray *bannerList;
@property (strong, nonatomic) NSMutableArray *contentList;
@property (strong, nonatomic) NSArray *appInfo;



@property (nonatomic,retain) NSMutableDictionary *sections;


- (void)setupScrollView:(UIScrollView*)svMain ;

@end
