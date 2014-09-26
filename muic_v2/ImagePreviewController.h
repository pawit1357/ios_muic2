//
//  ImagePreviewController.h
//  muic_v2
//
//  Created by pawit on 9/26/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelContent.h"

@interface ImagePreviewController : UIViewController{
    
    NSFileManager *fileManager;
    NSString *documentsDirectory;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPreview;


@property (strong, nonatomic) ModelContent *contentItem;

@end
