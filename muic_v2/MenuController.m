//
//  MenuController.m
//  muic_v2
//
//  Created by pawit on 8/31/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "MenuController.h"
#import "AppDao.h"
#import "BannerDao.h"
#import "Menudao.h"
#import "Modelapp.h"
#import "ModelBanner.h"
#import "ModelMenu.h"
#import "MainViewController.h"

@interface MenuController ()

@end

@implementation MenuController

@synthesize appList,src,bannerList;

int selectedRow;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    */
    
    [self prepareContents];
    [self setupScrollView:src];
    
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 120, 280, 36)];
    [pgCtr setTag:101];
    pgCtr.numberOfPages=3;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:pgCtr];
}

-(void)prepareContents{
    self.appList  = (NSMutableArray*)[[AppDao AppDao] getAll];
    self.bannerList = (NSMutableArray*)[[BannerDao BannerDao] getAll];
    
    
    //ModelMenu *menu = [[ModelMenu alloc] init];
    //menu.app_id =1;

    //NSMutableArray *tmp = (NSMutableArray*)[[MenuDao MenuDao] getMenu:menu];
    //NSLog(@"");
}

- (void)setupScrollView:(UIScrollView*)scrMain {
    // we have 3 images here.
    // we will add all images into a scrollView & set the appropriate size.

    for (int i=1; i<=self.bannerList.count; i++) {
        
        // create image
        // create imageView
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height)];
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
        [scrMain addSubview:imgV];
    }
    
    // set the content size to 3 image width
    [scrMain setContentSize:CGSizeMake(scrMain.frame.size.width*self.bannerList.count, scrMain.frame.size.height)];
    
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.appListView viewWithTag:100];
    // same way, access pagecontroll access
    UIPageControl *pgCtr = (UIPageControl*) [self.appListView viewWithTag:101];
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.appList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
	ModelApp *app= (ModelApp *)[self.appList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.description;
    cell.imageView.image = [UIImage imageNamed:app.image_url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    NSLog(@"selected row %d",selectedRow);
    
    
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"modalListApp"]){
        //NSIndexPath *indexPath = [ self.tableView indexPathForSelectedRow];
        //ModelApp *app= (ModelApp *)[self.appList objectAtIndex[indexPath]];
        //ModelApp *app = self.appList[indexPath.row];
        //[segue.destinationViewController setDetailApp:app];
    }
}

@end
