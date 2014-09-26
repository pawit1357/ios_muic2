//
//  ImagePreviewController.m
//  muic_v2
//
//  Created by pawit on 9/26/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "ImagePreviewController.h"

@interface ImagePreviewController ()

@end

@implementation ImagePreviewController

@synthesize imgPreview;

-(void) seContentItem:(id)newContentItem{
    
    if(_contentItem != newContentItem){
        _contentItem = newContentItem;
    }
    [self prepareContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    [self prepareContent];
}

- (void) prepareContent{
    if(_contentItem){

        ModelContent *content = (ModelContent*)_contentItem;

        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[content.image_url lastPathComponent]];
        if ([fileManager fileExistsAtPath:filePath]){
            imgPreview.image =[UIImage imageWithContentsOfFile:filePath];
            [self resizingImage];
        }
        
    }
}


-(void)resizingImage{
    
    float screenwidth;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        screenwidth = 320.0;
    }else{
        screenwidth = 768.0;
    }
    
    float scale = imgPreview.image.size.width/screenwidth;
    float resizewidth = screenwidth;
    float resizeheight = imgPreview.image.size.height/scale;
    
    NSLog(@"resizeheight %f",resizeheight);
    
    imgPreview.frame = CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height/2) - resizeheight/2, resizewidth, resizeheight);
    
    
    
}
    /*
-(void)setImagePreviewWithPath{
    
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,    NSUserDomainMask, YES);
    NSLog(@"%@", [dirArray objectAtIndex:0]);
    
    NSString *img_path = imgPath;
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",[dirArray objectAtIndex:0],img_path];
    NSLog(@"fileName %@",fileName);
    
    
    previewImg.image = [UIImage imageWithContentsOfFile:fileName];
    
    
    
    [self resizingImage];
    
}
 */

@end
