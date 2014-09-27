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
    [self prepareContent];
}


- (void) prepareContent{
    if(_contentItem){
        
        /*
        NSString* url = @"http://google.com?get=something&...";
        
        NSURL* nsUrl = [NSURL URLWithString:url];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
        
        [self.wvContent loadRequest:request];
         */
        
        ModelContent *content = (ModelContent*)_contentItem;
        self.title = content.title;

        NSString *embedHTML =[NSString stringWithFormat: @"<html><head><style>body{font: 33px sans-serif;background: #fff;padding: 30px;color: #000;margin: 50;text-align: justify;text-justify: inter-word;}</style></head><body>%@</p></body></html>",content.description];
        
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
