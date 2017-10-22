//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelMenu.h"


@interface SidebarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSFileManager *fileManager;
    NSString *documentsDirectory;
    ModelMenu *selectedMenu;
}

@property (weak, nonatomic) IBOutlet UITableView *tvMenuList;
@property (strong, nonatomic) NSMutableArray *menuList;
@property (strong, nonatomic) NSMutableArray *parentAr;


@end
