//
//  PromotionDetailController.m
//  muic_v2
//
//  Created by pawit on 9/22/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "PromotionDetailController.h"
#import "ModelContent.h"
#import "SWRevealViewController.h"
#import "PromotoinSubDetailController.h"

@interface PromotionDetailController ()

@end

@implementation PromotionDetailController

@synthesize tvMain,contentList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) setContentList:(NSMutableArray *)newContentList{
    
    if(contentList != newContentList){
        contentList = newContentList;
    }
    
    [self prepareContent];
}

- (void) prepareContent{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
	ModelContent *app= (ModelContent *)[self.contentList objectAtIndex:indexPath.row];
    
    lbTitle = (UILabel *)[cell viewWithTag:101];
    lbTitle.text = app.title;
    
    lbDesc = (UILabel *)[cell viewWithTag:102];
    lbDesc.text = app.description;
    
    lbCreateDate = (UILabel *)[cell viewWithTag:103];
    lbCreateDate.text = @"";
    
    
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
            NSLog(@"Promotion: Downloading Started");
            NSURL  *url = [NSURL URLWithString:app.image_url];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                //saving is done on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [urlData writeToFile:filePath atomically:YES];
                    NSLog(@"Promotion: File Saved !");
                    newImg.image =[UIImage imageWithData:urlData];
                    [spinner stopAnimating];
                });
            }
            
        });
    }
    
    /*
    cell.textLabel.text = app.title;
    cell.detailTextLabel.text = app.title;
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(CGRectGetWidth(cell.imageView.bounds)/2, CGRectGetHeight(cell.imageView.bounds)/2)];
    [spinner setColor:[UIColor grayColor]];
    
    [cell.imageView addSubview:spinner];
    
    // start spinner
    [spinner startAnimating];
    
	
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // retrive image on global queue
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:app.image_url]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image =img;
            [spinner stopAnimating];
        });
    });
    */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selectedRow = indexPath.row;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"promotionSubDetail"]){
        
        PromotoinSubDetailController *transferViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tvMain indexPathForSelectedRow];
        
        ModelContent *content= (ModelContent *)self.contentList[indexPath.row];
        
        [transferViewController setContentItem:content];
    }
    
    
}

@end
