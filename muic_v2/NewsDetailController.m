//
//  NewsDetailController.m
//  muic_v2
//
//  Created by pawit on 9/22/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "NewsDetailController.h"

@interface NewsDetailController ()

@end

@implementation NewsDetailController

-(void) seContentItem:(id)newContentItem{
    
    if(_contentItem != newContentItem){
        _contentItem = newContentItem;
    }
    [self prepareContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareContent];
}

- (void) prepareContent{
    if(_contentItem){
        
        ModelContent *content = (ModelContent*)_contentItem;
        self.title = content.title;
        
        NSString *embedHTML =[NSString stringWithFormat: @"<html><head></head><body>%@</p></body></html>",content.description];
        
        self.wvMain.scrollView.scrollEnabled = TRUE;
        [self.wvMain loadHTMLString: embedHTML baseURL: nil];
        
    }
}

@end
