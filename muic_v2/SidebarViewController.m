//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "ModelMenu.h"
#import "Menudao.h"
#import "AppDelegate.h"
//#import "AppDao.h"
//#import "modelapp.h"
#import "Modelcontent.h"
#import "ContentDao.h"
#import "Bookdao.h"

#import "MenuDetailController.h"
#import "SidebarViewController.h"
#import "MainViewController.h"
#import "PromotionDetailController.h"
#import "GalleryDetailController.h"
#import "LibraryDetailController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

@synthesize menuList,tvMenuList,parentAr;


ModelMenu *selectedMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    //backButton.target = self.revealViewController;
    //backButton.action = @selector(revealToggle:);
    //self.navigationItem.leftBarButtonItem= backButton;
    
    self.parentAr =  [NSMutableArray array];
    
    [self prepareData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
    
    // create the button object
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:10];
    headerLabel.frame = CGRectMake(0.0, 0.0, 320.0, 22.0);
    

    headerLabel.text = @"  SELECT ORGANIZATIONS :"; // i.e. array element
    /*
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(0, 0, 18, 18); // x,y,width,height
    infoButton.enabled = YES;
    [infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     */
    [customView addSubview:headerLabel];
    //[customView addSubview:infoButton];
    
    return customView;
}
/*
- (void)infoButtonClicked:(id)sender {
    [self getPreviousMenu:selectedMenu];
    
}
*/
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void) prepareData{
    self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getAllMainMenu];
    [self.tvMenuList reloadData];
}

-(void) getNextMenu:(ModelMenu*)selectedMenu{
    
    self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getChildMenu:selectedMenu];
   // NSLog(@"menuList size: %d",menuList.count);

    if (![parentAr containsObject:[NSNumber numberWithInt:selectedMenu.parent]]) {
        // modify objectToSearchFor
        [self.parentAr addObject:[NSNumber numberWithInt:selectedMenu.parent]];
    }else{
        NSLog(@" Parent %ld alread exist.",(long)selectedMenu.parent);
    }
    [self.tvMenuList reloadData];

}

-(void) getPreviousMenu:(ModelMenu*)selectedMenu{
    
    ModelMenu *menu = [[ModelMenu alloc] init];
    menu.id = [[self.parentAr lastObject] integerValue];
    if(menu.id != 0){
        self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getChildMenu:menu];
        [self.tvMenuList reloadData];
        [self.parentAr removeLastObject];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"menuDetail"]) {
        // Cancel the popover segue
        return NO;
    }
    // Allow all other segues
    return YES;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{

    
    if ([segue.identifier isEqualToString:@"menuDetail"]) {
        
         MenuDetailController *transferViewController = segue.destinationViewController;
        
        NSMutableArray *contents = (NSMutableArray*)[[ContentDao ContentDao] getMenuContent:selectedMenu.id];
        if( contents.count>0){
            ModelContent *content = (ModelContent*)[contents objectAtIndex:0];
            [transferViewController setContentItem:content];
        }
    }
    if ([segue.identifier isEqualToString:@"galleryDetail"]) {
        
        GalleryDetailController *transferViewController = segue.destinationViewController;
        
        NSMutableArray *contents = (NSMutableArray*)[[ContentDao ContentDao] getMenuContent:selectedMenu.id];
        [transferViewController setContentList:contents];
        
    }
    if ([segue.identifier isEqualToString:@"promotionDetail"]) {
        
        PromotionDetailController *transferViewController = segue.destinationViewController;
        
        NSMutableArray *contents = (NSMutableArray*)[[ContentDao ContentDao] getMenuContent:selectedMenu.id];
        [transferViewController setContentList:contents];
    }
    if ([segue.identifier isEqualToString:@"bookDetail"]) {
        
        LibraryDetailController *transferViewController = segue.destinationViewController;
        

        NSMutableArray *books = (NSMutableArray*)[[BookDao BookDao] getBookByType:[NSString stringWithFormat:@"%ld",(long)selectedMenu.type]];
        
        [transferViewController setBookList:books];
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(indexPath.row == 0){
        cell.textLabel.text =@"Home";
        cell.detailTextLabel.text = @" ";
    }else{
        if( indexPath.row < self.menuList.count){
            ModelMenu *menu= (ModelMenu *)[self.menuList objectAtIndex:indexPath.row];
    
            cell.textLabel.text = menu.name;
            if(menu.parent == -1){
                cell.detailTextLabel.text = menu.description;
            }else{
                cell.detailTextLabel.text = @" ";
            }
            cell.imageView.image = [UIImage imageNamed:menu.icon];
            /*
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner setCenter:CGPointMake(CGRectGetWidth(cell.imageView.bounds)/2, CGRectGetHeight(cell.imageView.bounds)/2)];
            [spinner setColor:[UIColor grayColor]];
            
            [cell.imageView addSubview:spinner];
            
            [spinner startAnimating];
            
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[menu.icon lastPathComponent]];
            if ([fileManager fileExistsAtPath:filePath]){
                cell.imageView.image =[UIImage imageWithContentsOfFile:filePath];
                [spinner stopAnimating];
            }else{
                // download the image asynchronously
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"News & Events: Downloading Started");
                    NSURL  *url = [NSURL URLWithString:menu.icon];
                    NSData *urlData = [NSData dataWithContentsOfURL:url];
                    if ( urlData )
                    {
                        //saving is done on main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [urlData writeToFile:filePath atomically:YES];
                            NSLog(@"News & Events: File Saved !");
                            cell.imageView.image =[UIImage imageWithData:urlData];
                            [spinner stopAnimating];
                        });
                    }
                    
                });
            }
            
            
            //cell.imageView.image = [UIImage imageNamed:menu.icon];
             */
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 ){
        if(parentAr.count>0){
        [self getPreviousMenu:selectedMenu];
        }else{
            [self performSegueWithIdentifier:@"newsDetail" sender:@" "];
        }
    }else{
    if( indexPath.row < self.menuList.count){
        
       
        selectedMenu = (ModelMenu *)[self.menuList objectAtIndex:indexPath.row];

        [self getNextMenu:selectedMenu];
        if ([self.menuList count] == 1) {
            
            ModelMenu *menu = [[ModelMenu alloc] init];
            menu.id = [[self.parentAr lastObject] integerValue];
            self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getChildMenu:menu];
            [self.tvMenuList reloadData];
            
            /*
             -----------------
             menu_type
             -----------------
             0 = menu
             1 = news & event
             2 = announge
             3 = gallery
             4 = promotion
             5 = content(html)
             6 = book
             7 = thesis
             8 = ask
             
             add filter recommnted,new
             */
            [self.parentAr removeLastObject];
            switch (selectedMenu.type) {
                case 3:

                    [self performSegueWithIdentifier:@"galleryDetail" sender:@" "];
                    break;
                case 4:
                    [self performSegueWithIdentifier:@"promotionDetail" sender:@" "];
                    break;
                case 6:
                case 7:
                    [self performSegueWithIdentifier:@"bookDetail" sender:@" "];
                    break;
                case 8:
                    [self.parentAr removeLastObject];
                    NSLog(@"");
                    break;
                default:
                    [self performSegueWithIdentifier:@"menuDetail" sender:@" "];
                    break;
            }
        }
    }
    }
}

@end
