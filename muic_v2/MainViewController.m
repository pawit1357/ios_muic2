//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "MenuDao.h"
#import "BannerDao.h"
#import "ContentDao.h"
#import "BookDao.h"
#import "FaqDao.h"
#import "ModelContent.h"
#import "NewsDetailController.h"
#import "Webservice.h"
#import "NSData+Base64.h"
#import "NSString_stripHtml.h"
#import "MyUtils.h"
#import "InternetStatus.h"
#import "AppConfigDao.h"
#import "ModelPopup.h"

@interface MainViewController ()

@end

@implementation MainViewController


@synthesize contentList,appInfo,svBanner,bannerList,spiner;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"News & Events";

    //ModelMenu *menu = [[MenuDao MenuDao]getSingleMenu:395];
    //ModelContent *ccc = [[ContentDao ContentDao]getSingleContent:325];
    
    //Adjust tableview size
    self.bannerList = (NSMutableArray*)[[BannerDao BannerDao] getAll];
    
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    
    self.navigationItem.leftBarButtonItem = backButton;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self setupScrollView:svBanner];
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 120, 280, 36)];
    [pgCtr setTag:12];
    pgCtr.numberOfPages=self.bannerList.count;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:pgCtr];
    self.svBanner.userInteractionEnabled = false;
    
    //Refresh control
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc] initWithFrame:CGRectMake(15, 50, 290, 30)];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl setBackgroundColor:[[MyUtils MyUtils] colorFromHexString:@"#0b162b"]];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tvContent addSubview:refreshControl];
    
    

    //[self showToolBar];
    [self prepareContent];
    
    InternetStatus *internet  = [[InternetStatus alloc]init];
    if([internet checkWiFiConnection]){
        ModelPopup *popup = [[Webservice Webservice]GetPopup];
        if( [[AppConfigDao AppConfigDao] getPopupId] != popup.id){
            if( ![popup.url isEqualToString:@""] ){
                [self showAlertPopup:popup];
            }
        }
    }else{
        NSLog(@"Can't Connect to internet.");
    }
}



-(void) showAlertPopup:(ModelPopup *)model{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 150)];
    // Add some custom content to the alert view
    [alertView setContainerView:demoView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
    [alertView setDelegate:self];
    
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(20, 20)];
    [spinner setColor:[UIColor grayColor]];
    [demoView addSubview:spinner];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, self.view.bounds.size.width-38, 81)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL  *url = [NSURL URLWithString:model.url];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            [spinner startAnimating];
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AppConfigDao AppConfigDao] updatePopupURLid:model.id];
                [imageView setImage:[UIImage imageWithData:urlData]];
                [spinner stopAnimating];
                [demoView addSubview:imageView];
            });
        }
        
    });
    
    

    //
    UILabel *lbText =[[UILabel alloc] initWithFrame:CGRectMake(10,0,self.view.bounds.size.width-20,50)];
    lbText.textColor = [UIColor brownColor];
    lbText.font=[UIFont boldSystemFontOfSize:11.0];
    lbText.text = model.message;
    [demoView addSubview:lbText];
//

    
    
    [self.view addSubview:alertView];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
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
        [[Webservice Webservice] getBanner];
        [[Webservice Webservice]getMenu];
        [[Webservice Webservice] getContent];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareContent];
                [self.tvContent reloadData];
            });
        });
    }
    [refreshControl endRefreshing];
    
}


-(void)showToolBar
{
    CGRect frame, remain;
    CGRectDivide(self.view.bounds, &frame, &remain, 55, CGRectMaxYEdge);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
    //toolbar.backgroundColor = [UIColor blackColor];
    
    UIImage *image = [[UIImage imageNamed:@"news.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *btnNews = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnNewsClicked)];
    
    //UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIImage *image1 = [[UIImage imageNamed:@"anounce.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *btnAnouce = [[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(btnAnouceClicked)];
    
    [toolbar setItems:[[NSArray alloc] initWithObjects:btnNews,btnAnouce,nil]];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:toolbar];
}

-(void)btnNewsClicked{
    self.contentList = (NSMutableArray*)[[ContentDao ContentDao] getNews];
    [self generateGruped];
    [self.tvContent reloadData];
}

-(void)btnAnouceClicked{
    self.contentList = (NSMutableArray*)[[ContentDao ContentDao] getAnnounce];
    [self generateGruped];
    [self.tvContent reloadData];
}



-(void)prepareContent{
    
    self.contentList = (NSMutableArray*)[[ContentDao ContentDao] getNews];

    [self generateGruped];
}
- (void) generateGruped{
    
    //Group new & event & annouce
    self.sections = [[NSMutableDictionary alloc] init];
    BOOL found;
    // Loop through the books and create our keys
    for (NSDictionary *content in self.contentList)
    {
        ModelContent *c= (ModelContent *)content;
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:[NSString stringWithFormat:@"%ld",(long)c.app_id]])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"%ld",(long)c.app_id]];
        }
    }
    
    // Loop again and sort the books into their respective keys
    for (NSDictionary *content in self.contentList)
    {
        ModelContent *c= (ModelContent *)content;
        
        [[self.sections objectForKey:[NSString stringWithFormat:@"%ld",(long)c.app_id]] addObject:c];
        
    }
    // Sort each section array
    /*
     for (NSString *key in [self.sections allKeys])
     {
     [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
     }
     */
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //For each section, you must return here it's label

    NSString *app_id = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    
    ModelMenu *app = [[MenuDao MenuDao]getAppInfo:[app_id integerValue]];
    return app.name;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return [[self.sections allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
        NSDictionary *content = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    

    ModelContent *app= (ModelContent *)content;
    

    lbTitle = (UILabel *)[cell viewWithTag:101];
    
    NSData *dataTitle = [NSData dataFromBase64String:app.title];
    NSString *convertedTitleStr = [[NSString alloc] initWithData:dataTitle encoding:NSUTF8StringEncoding];
    
    lbTitle.text = [convertedTitleStr stripHtml];
    
    lbDesc = (UILabel *)[cell viewWithTag:102];
    NSData *data = [NSData dataFromBase64String:app.description];
    NSString *convertedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    lbDesc.text = [convertedString stripHtml];
    
    lbCreateDate = (UILabel *)[cell viewWithTag:103];
    lbCreateDate.text = app.create_date;
    
    
    newImg = (UIImageView *)[cell viewWithTag:100];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(CGRectGetWidth(newImg.bounds)/2, CGRectGetHeight(newImg.bounds)/2)];
    [spinner setColor:[UIColor grayColor]];
    [newImg addSubview:spinner];
    
    [spinner startAnimating];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[app.image_url lastPathComponent]];
    
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if( [[filePath pathExtension] isEqualToString:@""] ){
        newImg.image =[UIImage imageNamed:@"news_layout.png"];
    }else if ( fileExists ){
        
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
            }else{
                newImg.image =[UIImage imageNamed:@"news_layout.png"];
            }
            
        });
    }
    //}

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
    
}
 
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    if([segue.identifier isEqualToString:@"newDetail"]){
        
        NewsDetailController *transferViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tvContent indexPathForSelectedRow];
        NSDictionary *content = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        ModelContent *selectedModel= (ModelContent *)content;
        
        
        [transferViewController setContentItem:selectedModel];
        
    }
}


@end
