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

@interface SidebarViewController ()

@end

@implementation SidebarViewController

@synthesize menuList,tvMenuList,cvAppList,appList;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    AppDelegate *a = DELEGATE;
    ModelMenu *menu = [[ModelMenu alloc] init];
    menu.app_id = a.selectedApp;
    menu.parent = -1;
    self.menuList = (NSMutableArray*)[[MenuDao MenuDao] getMenu:menu];
    self.appList  = (NSMutableArray*)[[AppDao AppDao] getAll];

}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
   // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    //destViewController.title = [[self.menuList objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    
    if ([segue.identifier isEqualToString:@"menuDetail"]) {
        //destViewController.title =@"test";
        /*
        PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [_menuItems objectAtIndex:indexPath.row]];
        photoController.photoFilename = photoFilename;
        */
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
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
*/
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
    
    ModelMenu *menu= (ModelMenu *)[self.menuList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = menu.name;
    cell.detailTextLabel.text = menu.name;
    cell.imageView.image = [UIImage imageNamed:menu.icon];
    
    return cell;
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
    [self.tvMenuList reloadData];
}

@end
