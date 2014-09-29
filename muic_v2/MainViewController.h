//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController: UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    UILabel *lbTitle;
    UILabel *lbDesc;
    UILabel *lbCreateDate;
    UIImageView *newImg;
    NSFileManager *fileManager;
    NSString *documentsDirectory;
    
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@property (strong, nonatomic) IBOutlet UIView *vMain;

@property (weak, nonatomic) IBOutlet UITableView *tvContent;


@property (weak, nonatomic) IBOutlet UIScrollView *svBanner;


@property (strong, nonatomic) NSMutableArray *bannerList;
@property (strong, nonatomic) NSMutableArray *contentList;
@property (strong, nonatomic) NSArray *appInfo;

- (void)setupScrollView:(UIScrollView*)svMain ;

- (void)setCustomProgress;
@end
