//
//  GalleryDetailController.h
//  muic_v2
//
//  Created by pawit on 9/22/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryDetailController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *contentList;

@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
    
@end
