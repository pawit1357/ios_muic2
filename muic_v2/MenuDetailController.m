//
//  MenuDetailController.m
//  muic_v2
//
//  Created by pawit on 9/19/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "MenuDetailController.h"
#import "SWRevealViewController.h"
#import "ModelContent.h"
#import "ContentDao.h"

@interface MenuDetailController ()

@end

@implementation MenuDetailController


-(void) seContentItem:(id)newContentItem{
    
    if(_contentItem != newContentItem){
        _contentItem = newContentItem;
    }
    

    [self prepareContent];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    //backButton.action = @selector(revealToggle:);
    
    //UIBarButtonItem *mainButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    //mainButton.target = self.revealViewController;
    //mainButton.action = @selector(revealToggle:);
    
    //self.navigationItem.rightBarButtonItem= mainButton;
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    [self prepareContent];
    
}

- (void) prepareContent{
    if(_contentItem){
        
        ModelContent *content = (ModelContent*)_contentItem;
        self.title = content.title;


            
            //ModelContent *content = (ModelContent*)[contents objectAtIndex:0];
            //NSLog(@">>>>%@",content.description);
            
            NSString *embedHTML =[NSString stringWithFormat: @"<html><head></head><body>%@</p></body></html>",content.description];
            
            //self.wvContent.userInteractionEnabled = NO;
            //self.wvContent.opaque = NO;
            //self.wvContent.backgroundColor = [UIColor clearColor];
            self.wvContent.scrollView.scrollEnabled = TRUE;
            [self.wvContent loadHTMLString: embedHTML baseURL: nil];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
