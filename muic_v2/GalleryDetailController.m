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
#import "ImagePreviewController.h"

@interface GalleryDetailController ()

@end

@implementation GalleryDetailController

@synthesize cvMain,contentList;

int selectedItemIndex;

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


 - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 return self.contentList.count;
 }
 
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *identifier = @"Cell";
 
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
     UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
 
     ModelContent *app= (ModelContent *)[self.contentList objectAtIndex:indexPath.row];
 
     
     
     UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     [spinner setCenter:CGPointMake(CGRectGetWidth(recipeImageView.bounds)/2, CGRectGetHeight(recipeImageView.bounds)/2)];
     [spinner setColor:[UIColor grayColor]];
     
     [recipeImageView addSubview:spinner];
     
     [spinner startAnimating];
     
     
     
     NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[app.image_url lastPathComponent]];
     if ([fileManager fileExistsAtPath:filePath]){
         recipeImageView.image =[UIImage imageWithContentsOfFile:filePath];
         [spinner stopAnimating];
     }else{
         // download the image asynchronously
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             NSLog(@"Gallery: Downloading Started");
             NSURL  *url = [NSURL URLWithString:app.image_url];
             NSData *urlData = [NSData dataWithContentsOfURL:url];
             if ( urlData )
             {
                 //saving is done on main thread
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [urlData writeToFile:filePath atomically:YES];
                     NSLog(@"Gallery: File Saved !");
                     recipeImageView.image =[UIImage imageWithData:urlData];
                     [spinner stopAnimating];
                 });
             }
             
         });
     }
     return cell;
 }
 
 -(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
 {
     selectedItemIndex = indexPath.row;
     
 }
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"previewImage"]){
        
        ImagePreviewController *transferViewController = segue.destinationViewController;
        
        
        ModelContent *content= (ModelContent *)self.contentList[selectedItemIndex];
        
        [transferViewController setContentItem:content];
    }
    
    
}
@end
