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
#import "AppDao.h"
#import "modelapp.h"
#import "Modelcontent.h"
#import "ContentDao.h"

#import "MenuDetailController.h"
#import "SidebarViewController.h"
#import "MainViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

@synthesize menuList,tvMenuList,cvAppList,appList;

int currentMenuId = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    [self prepareData];
}

-(void) prepareData{
    
    AppDelegate *a = DELEGATE;
    ModelMenu *menu = [[ModelMenu alloc] init];
    menu.app_id = a.selectedApp;
    menu.parent = -1;
    self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getMenu:menu];
    self.appList  = (NSMutableArray*)[[AppDao AppDao] getAll];
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
     7 = ask
     */
    if ([segue.identifier isEqualToString:@"menuDetail"]) {
         MenuDetailController *transferViewController = segue.destinationViewController;
         //NSArray *itemDetail = self.menuList[selectedRowIndex];
        //NSLog(@"**********************************:%d",currentMenuId);
        
        NSMutableArray *contents = (NSMutableArray*)[[ContentDao ContentDao] getMenuContent:currentMenuId];
        if( contents.count>0){
            
            ModelContent *content = (ModelContent*)[contents objectAtIndex:0];
            
        
         [transferViewController setContentItem:content];
        }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
    
            cell.textLabel.text = menu.name;
            cell.detailTextLabel.text = menu.name;
            cell.imageView.image = [UIImage imageNamed:menu.icon];
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row < self.menuList.count){
        
        AppDelegate *a = DELEGATE;
        ModelMenu *m= (ModelMenu *)[self.menuList objectAtIndex:indexPath.row];
        
        ModelMenu *menu = [[ModelMenu alloc] init];
        menu.app_id = a.selectedApp;
        menu.parent = m.id;
        self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getMenu:menu];
        if ([self.menuList count] == 0) {
            
            currentMenuId = m.id;
            
            [self prepareData];
            [self performSegueWithIdentifier:@"menuDetail" sender:@" "];
        }
        [self.tvMenuList reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.appList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    ModelApp *app= (ModelApp *)[self.appList objectAtIndex:indexPath.row];
    
    recipeImageView.image = [UIImage imageNamed:app.image_url];
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DetailViewController* viewController = [[DetailViewController alloc] init];
    //configure detail view controller
    // viewController.detailInfo = ...
    //[self.navigationController pushViewController:viewController animated:YES];

    ModelApp *app= (ModelApp *)[self.appList objectAtIndex:indexPath.row];
    ModelMenu *menu = [[ModelMenu alloc] init];
    menu.app_id = app.id;
    menu.parent = -1;
    self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getMenu:menu];
    
    AppDelegate *a = DELEGATE;
    a.selectedApp = app.id;
    
    [self.tvMenuList reloadData];
}

@end
