//
//  LibraryDetailController.h
//  muic_v2
//
//  Created by pawit on 9/23/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    NSString *bookType;
    NSFileManager *fileManager;
    NSString *documentsDirectory;
    UIBarButtonItem *backButton;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentFilter;
- (IBAction)segmentFilter:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tvMain;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *bookList;
@property (strong, nonatomic) NSMutableArray *filteredBookList;
@property (nonatomic, assign) bool isFiltered;


- (IBAction)displaySearchBar:(id)sender;

@end
