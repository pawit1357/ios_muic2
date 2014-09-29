//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "BannerDao.h"
#import "ContentDao.h"
#import "ModelContent.h"
#import "NewsDetailController.h"
#import "Webservice.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize contentList,appInfo,svBanner,bannerList,progressView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"News & Events";
    
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    
    
    self.navigationItem.leftBarButtonItem = backButton;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self prepareContent];

    [self setupScrollView:svBanner];
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 120, 280, 36)];
    [pgCtr setTag:12];
    pgCtr.numberOfPages=self.bannerList.count;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:pgCtr];
    
    self.svBanner.userInteractionEnabled = false;
    
    //Download data
    [progressView setProgress:0.0];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(setCustomProgress) userInfo:nil repeats:YES];
}
- (void)setCustomProgress{
    
    NSMutableArray *banner = (NSMutableArray*)[[Webservice Webservice] getBanner];
    NSMutableArray *menu = (NSMutableArray*)[[Webservice Webservice] getMenu];
    //NSMutableArray *content = (NSMutableArray*)[[Webservice Webservice] getContent];
    NSMutableArray *book = (NSMutableArray*)[[Webservice Webservice] GetBook];
    NSMutableArray *faq = (NSMutableArray*)[[Webservice Webservice] GetQuestion];
    
    progressView.progress = progressView.progress + 0.01;

    NSString *newValue = [[NSString alloc] initWithFormat:@"%.2f", progressView.progress];
    //lblResult.text = newValue;
    if(progressView.progress == 1.0)
    {
        //lblResult.text = @"Load Finished!";
        [timer invalidate];
    }
}

-(void)prepareContent{
    
    self.bannerList = (NSMutableArray*)[[BannerDao BannerDao] getAll];
    self.contentList = (NSMutableArray*)[[ContentDao ContentDao] getNews];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupScrollView:(UIScrollView*)svMain {
    // we have 3 images here.
    // we will add all images into a scrollView & set the appropriate size.
    
    for (int i=1; i<=self.bannerList.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*svMain.frame.size.width, 0, svMain.frame.size.width, svMain.frame.size.height)];
        

        // set scale to fill
        imgV.contentMode=UIViewContentModeScaleToFill;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setCenter:CGPointMake(CGRectGetWidth(imgV.bounds)/2, CGRectGetHeight(imgV.bounds)/2)];
        [spinner setColor:[UIColor grayColor]];
        
        [svMain addSubview:spinner];
        
        [spinner startAnimating];
        // set image
        ModelBanner *banner= (ModelBanner *)[self.bannerList objectAtIndex:i-1];
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[banner.image_url lastPathComponent]];
        if ([fileManager fileExistsAtPath:filePath]){
            //NSLog(@"File %@ is already add.",filePath);
            [imgV setImage:[UIImage imageWithContentsOfFile:filePath]];
            [spinner stopAnimating];
        }else{
            // download the image asynchronously
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"Banner : Downloading Started");
                NSURL  *url = [NSURL URLWithString:banner.image_url];
                NSData *urlData = [NSData dataWithContentsOfURL:url];
                if ( urlData )
                {
                    //saving is done on main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [urlData writeToFile:filePath atomically:YES];
                        NSLog(@"Banner : File Saved !");
                        [imgV setImage:[UIImage imageWithData:urlData]];
                        [spinner stopAnimating];
                    });
                }
                
            });
        }

        // apply tag to access in future
        imgV.tag=i+1;
        // add to scrollView
        [svMain addSubview:imgV];
        
    }
    // set the content size to 10 image width
    [svMain setContentSize:CGSizeMake(svMain.frame.size.width*self.bannerList.count, svMain.frame.size.height)];
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
    
}

- (void)scrollingTimer {
    
    // access the scroll view with the tag
    //UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    // same way, access pagecontroll access
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = svBanner.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/svBanner.frame.size.width) + 1 ;
    // if page is not 10, display it
    if( nextPage!=self.bannerList.count )  {
        [svBanner scrollRectToVisible:CGRectMake(nextPage*svBanner.frame.size.width, 0, svBanner.frame.size.width, svBanner.frame.size.height) animated:YES];
        pgCtr.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        [svBanner scrollRectToVisible:CGRectMake(0, 0, svBanner.frame.size.width, svBanner.frame.size.height) animated:YES];
        pgCtr.currentPage=0;
    }
    
    //NSLog(@"next banner:%d",nextPage);

}



#pragma mark - Table view data source

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //For each section, you must return here it's label
    if(section == 0) return @"header 1";
    if(section == 1) return @"header 1";
    if(section == 2) return @"header 1";
    if(section == 3) return @"header 1";

}
*/

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	ModelContent *app= (ModelContent *)[self.contentList objectAtIndex:indexPath.row];
    
    lbTitle = (UILabel *)[cell viewWithTag:101];
    lbTitle.text = app.title;
    
    lbDesc = (UILabel *)[cell viewWithTag:102];
    lbDesc.text = app.description;
    
    lbCreateDate = (UILabel *)[cell viewWithTag:103];
    lbCreateDate.text = app.create_date;
    
    
    newImg = (UIImageView *)[cell viewWithTag:100];
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(CGRectGetWidth(newImg.bounds)/2, CGRectGetHeight(newImg.bounds)/2)];
    [spinner setColor:[UIColor grayColor]];
    [newImg addSubview:spinner];
    [spinner startAnimating];

    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[app.image_url lastPathComponent]];
    if ([fileManager fileExistsAtPath:filePath]){
        newImg.image =[UIImage imageWithContentsOfFile:filePath];
        [spinner stopAnimating];
    }else{
        // download the image asynchronously
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"News & Events: Downloading Started");
            NSURL  *url = [NSURL URLWithString:app.image_url];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                //saving is done on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [urlData writeToFile:filePath atomically:YES];
                    NSLog(@"News & Events: File Saved !");
                    newImg.image =[UIImage imageWithData:urlData];
                    [spinner stopAnimating];
                });
            }
            
        });
    }

    UIView *lvView = (UIView *)[cell viewWithTag:13];
    [lvView.layer setCornerRadius:6.0f];
    //Setting Read/UnRead colour
    if([app.read isEqualToString:@"0"]){
        lvView.backgroundColor = [UIColor brownColor];
    }else{
        lvView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selectedRow = indexPath.row;
}
 
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    

    if([segue.identifier isEqualToString:@"newDetail"]){
        
        NewsDetailController *transferViewController = segue.destinationViewController;

        NSIndexPath *indexPath = [self.tvContent indexPathForSelectedRow];
        
        ModelContent *content= (ModelContent *)self.contentList[indexPath.row];
        
        [transferViewController setContentItem:content];
        
    }
}


@end
