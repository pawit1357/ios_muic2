//
//  GalleryDetailController.m
//  muic_v2
//
//  Created by pawit on 9/22/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "GalleryDetailController.h"
#import "ModelContent.h"
#import "SWRevealViewController.h"

@interface GalleryDetailController ()

@end

@implementation GalleryDetailController

@synthesize cvMain,contentList;


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


 - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 return self.contentList.count;
 }
 
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *identifier = @"Cell";
 
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
     UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
 
     ModelContent *app= (ModelContent *)[self.contentList objectAtIndex:indexPath.row];
 
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         // retrive image on global queue
         UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:app.image_url]]];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             recipeImageView.image =img;
         });
     });
     
     
     

     
     return cell;
 }
 
 -(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
 {
     
 }

@end
