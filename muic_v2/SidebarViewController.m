//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "Webservice.h"
#import "ModelMenu.h"
#import "Menudao.h"
#import "AppDelegate.h"

#import "Modelcontent.h"
#import "ContentDao.h"
#import "Bookdao.h"
#import "FaqDao.h"
#import "AppConfigDao.h"

#import "MenuDetailController.h"
#import "SidebarViewController.h"
#import "MainViewController.h"
#import "PromotionDetailController.h"
#import "GalleryDetailController.h"
#import "LibraryDetailController.h"
#import "FaqDetailControllerViewController.h"

#import "MyUtils.h"
#import "InternetStatus.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

@synthesize menuList,tvMenuList,parentAr;




- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"XX Sidebar XX");


    
    
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    
    self.view.backgroundColor =[[MyUtils MyUtils] colorFromHexString:@"#0b162b"];


    UIRefreshControl *refreshControl=[[UIRefreshControl alloc] initWithFrame:CGRectMake(15, 50, 290, 30)];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl setBackgroundColor:[[MyUtils MyUtils] colorFromHexString:@"#0b162b"]];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tvMenuList addSubview:refreshControl];

    
    self.parentAr =  [NSMutableArray array];
    [self prepareContent];
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    
    NSLog(@"Begin update menu..");
    
    if(refreshControl){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
    }
    
    //Syncronize download update menu
    InternetStatus *internet  = [[InternetStatus alloc]init];
    if([internet checkWiFiConnection]){
        [[Webservice Webservice] getMenu];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareContent];
                [self.parentAr removeAllObjects];
                [self.tvMenuList reloadData];
            });
        });
    }

    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void) prepareContent{
    self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getAllMainMenu];
    NSLog(@" menu size: %lu",(unsigned long)menuList.count);
}

-(void) getNextMenu:(ModelMenu*)selectedMenu{
    
    self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getChildMenu:selectedMenu];

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
    if ([segue.identifier isEqualToString:@"faqDetail"]) {
        
         //FaqDetailControllerViewController *transferViewController = segue.destinationViewController;
        //NSMutableArray *faq = (NSMutableArray*)[[FaqDao FaqDao] getAllQuestion];
        //[transferViewController setFaqList:faq];
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
    
    if( indexPath.row < self.menuList.count){
        
        ModelMenu *menu= (ModelMenu *)[self.menuList objectAtIndex:indexPath.row];
        
        if(indexPath.row == 0){
            
            //------------ Set home detail ------------
            ModelMenu *childMenu= (ModelMenu *)[self.menuList objectAtIndex:1];
            if(childMenu != nil){
             ModelMenu *modifyMenu = [[ModelMenu alloc] init];
            if (childMenu.parent != -1) {
                ModelMenu *parentMenu= (ModelMenu*)[[MenuDao MenuDao] getSingleMenu:childMenu.parent];
                modifyMenu.name   = [NSString stringWithFormat: @" :: Pevios menu[%@] ::",parentMenu.name ];
                modifyMenu.description = @"";//parentMenu.name;
            }else{
                modifyMenu.name   = @"Home";
                modifyMenu.description =@" ";
            }
            //----------------- END -------------------

            cell.textLabel.text =modifyMenu.name;
            cell.detailTextLabel.text = modifyMenu.description;
            cell.imageView.image =[UIImage imageNamed:@"home_menu.png"];
            }else{
                cell.textLabel.text =menu.name;
                cell.detailTextLabel.text = menu.description;
                cell.imageView.image =[UIImage imageNamed:menu.icon];
            }
    
        }else{

    
            cell.textLabel.text = menu.name;
            if(menu.parent == -1){
                cell.detailTextLabel.text = menu.description;
            }else{
                cell.detailTextLabel.text = @" ";
            }
            //cell.imageView.image = [UIImage imageNamed:menu.icon];
            
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
                    [self performSegueWithIdentifier:@"faqDetail" sender:@" "];
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
