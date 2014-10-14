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
#import "NSData+Base64.h"
#import "MyUtils.h";
@interface MenuDetailController ()

@end

@implementation MenuDetailController

@synthesize wvContent,spinner;

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

    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //set background color
    self.view.backgroundColor =[[MyUtils MyUtils] colorFromHexString:@"#0b162b"];
    [self prepareContent];
}


- (void) prepareContent{
    if(_contentItem){
        
        ModelContent *content = (ModelContent*)_contentItem;
        self.title = content.title;

        NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
        NSString *css = [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
        
        NSString *embedHTML =[NSString stringWithFormat: @"<html><head><style type=\"text/css\">%@</style></head><body>%@</body></html>",css,[[NSString alloc] initWithData:[NSData dataFromBase64String:content.description] encoding:NSUTF8StringEncoding]];
        
        //self.wvContent.userInteractionEnabled = NO;
        //self.wvContent.opaque = NO;
        //self.wvContent.backgroundColor = [UIColor clearColor];
        self.wvContent.scrollView.scrollEnabled = TRUE;
        [self.wvContent loadHTMLString: embedHTML baseURL: nil];
        

    }
}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    [spinner startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [spinner stopAnimating];
    spinner.hidden=YES;
}

@end
