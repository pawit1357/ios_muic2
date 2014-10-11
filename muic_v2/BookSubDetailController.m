//
//  BookSubDetailController.m
//  muic_v2
//
//  Created by pawit on 10/11/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "BookSubDetailController.h"

@interface BookSubDetailController ()

@end

@implementation BookSubDetailController

-(void) setBookItem:(ModelBook*)newBookItem{
    _bookItem = newBookItem;
    [self prepareContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareContent];
}

- (void) prepareContent{
    if(_bookItem){
    
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
