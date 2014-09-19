//
//  MenuController.m
//  muic_v2
//
//  Created by pawit on 8/31/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "ModalAppListController.h"
#import "AppDao.h"
#import "Modelapp.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface ModalAppListController ()

@end



@implementation ModalAppListController

@synthesize vApp,appList;

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
}

-(void)prepareContents{
    self.appList  = (NSMutableArray*)[[AppDao AppDao] getAll];
    
    //ModelMenu *menu = [[ModelMenu alloc] init];
    //menu.app_id =1;

    //NSMutableArray *tmp = (NSMutableArray*)[[MenuDao MenuDao] getMenu:menu];
    //NSLog(@"");
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
    AppDelegate *a = DELEGATE;
    a.selectedApp = indexPath.row;
    NSLog(@"value of variable str : %d",a.selectedApp );
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //MainViewController *transferViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"appListSegue"]){
    
        
        //NSIndexPath *indexPath = [self.vApp indexPathForSelectedRow];
        //NSArray *info = self.appList[indexPath.row];
        
        //transferViewController.lbInfo.text = @"NOOB";
        //[transferViewController setAppInfo:info];
    }
}

@end
