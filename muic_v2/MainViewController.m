//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "ModalAppListController.h"
#import "ModelApp.h"
#import "BannerDao.h"
#import "AppDelegate.h"
#import "ModelContent.h"
#import "ContentDao.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize vMain,svBanner,bannerList,contentList,appInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.title = @"News";

    // Change button color
   // _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self prepareContent];
    [self setupScrollView:svBanner];

    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 120, 280, 36)];
    [pgCtr setTag:101];
    pgCtr.numberOfPages=3;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:pgCtr];
    
    
    /*
    UIBarButtonItem * popbutt = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(apopbuttonPressed:)];
    
    self.navigationItem.rightBarButtonItem = popbutt;
     */
    
}

-(void)prepareContent{
    self.bannerList = (NSMutableArray*)[[BannerDao BannerDao] getAll];
    
    AppDelegate *a = DELEGATE;
    //ModelContent *content = [[ModelContent alloc] init];
    //content.app_id = a.selectedApp;
    
    //148,159,176,183
    //self.contentList = (NSMutableArray*)[[ContentDao ContentDao] getMenuContent:content];
}
/*
- (void) apopbuttonPressed:(id) sender
{
    NSLog(@"pressed");
}
 */
/*
-(void) setAppInfo:(id)newAppInfo{
    
    self.appInfo = newAppInfo;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupScrollView:(UIScrollView*)svMain {
    // we have 3 images here.
    // we will add all images into a scrollView & set the appropriate size.
    
    for (int i=1; i<=self.bannerList.count; i++) {
        
        // create image
        // create imageView
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*svMain.frame.size.width, 0, svMain.frame.size.width, svMain.frame.size.height)];
        // set scale to fill
        imgV.contentMode=UIViewContentModeScaleToFill;
        // set image
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            ModelBanner *banner= (ModelBanner *)[self.bannerList objectAtIndex:i-1];
            
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:banner.image_url]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // assign cell image on main thread
                [imgV setImage:img];
            });
        });
        // apply tag to access in future
        imgV.tag=i+1;
        // add to scrollView
        [svMain addSubview:imgV];
    }
    
    // set the content size to 3 image width
    [svMain setContentSize:CGSizeMake(svMain.frame.size.width*self.bannerList.count, svMain.frame.size.height)];
    
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.vMain viewWithTag:100];
    // same way, access pagecontroll access
    UIPageControl *pgCtr = (UIPageControl*) [self.vMain viewWithTag:101];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrMain.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    // if page is not 3, display it
    if( nextPage!=self.bannerList.count )  {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=0;
    }
    
    //AppDelegate *a = DELEGATE;
    //NSLog(@"value of variable str : %d",a.selectedApp );
    
    
    //ModelApp *app = (ModelApp*)self.appInfo;
    //self.lbInfo.text =[NSString stringWithFormat:@"Selected %d",a.selectedApp];
    //NSLog(@"----->%@", app.name);
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
	ModelContent *app= (ModelContent *)[self.contentList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = app.title;
    cell.detailTextLabel.text = app.description;
    //cell.imageView.image = [UIImage imageNamed:app.image_url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selectedRow = indexPath.row;
}
 
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
   // MainViewController *transferViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"appListSegue"]){
        
        
        //[viewControllerDelegate updateLabel];
        
        //NSIndexPath *indexPath = [self.appListView indexPathForSelectedRow];
        //NSArray *info = self.appList[indexPath.row];
        
        //[transferViewController setAppInfo:info];
    }
}


@end
