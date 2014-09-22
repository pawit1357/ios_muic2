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
    // Do any additional setup after loading the view.
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    
    //backButton.target = self.revealViewController;
    //backButton.action = @selector(revealToggle:);
    //self.navigationItem.leftBarButtonItem= backButton;
    
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    [self prepareContent];
    
}

- (void) prepareContent{
    if(_contentItem){
        
        ModelContent *content = (ModelContent*)_contentItem;
        self.title = content.title;
        
        
        
        //ModelContent *content = (ModelContent*)[contents objectAtIndex:0];
        NSLog(@">>>>%@",content.description);
        
        NSString *embedHTML =[NSString stringWithFormat: @"<html><head></head><body>%@</p></body></html>",content.description];
        
        //self.wvContent.userInteractionEnabled = NO;
        //self.wvContent.opaque = NO;
        //self.wvContent.backgroundColor = [UIColor clearColor];
        self.wvMain.scrollView.scrollEnabled = TRUE;
        [self.wvMain loadHTMLString: embedHTML baseURL: nil];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end