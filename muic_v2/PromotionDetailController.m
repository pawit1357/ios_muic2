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
    
    
    cell.textLabel.text = app.title;
    cell.detailTextLabel.text = app.title;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // retrive image on global queue
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:app.image_url]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image =img;
        });
    });
    
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
