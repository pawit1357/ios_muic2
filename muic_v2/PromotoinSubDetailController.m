//
//  PromotoinSubDetailController.m
//  muic_v2
//
//  Created by pawit on 9/23/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "PromotoinSubDetailController.h"
#import "NSData+Base64.h"

@interface PromotoinSubDetailController ()

@end

@implementation PromotoinSubDetailController

@synthesize wvMain,spinner;

-(void) seContentItem:(id)newContentItem{
    
    //if(_contentItem != newContentItem){
        _contentItem = newContentItem;
   //}
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
        
        NSData *data = [NSData dataFromBase64String:content.description];
        NSString *convertedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *embedHTML =[NSString stringWithFormat: @"<html><head><style>body{font: 16px sans-serif;background: #fff;padding: 5px;color: #000;margin: 5;text-align: justify;text-justify: inter-word;}</style></head><body>%@</p></body></html>",convertedString];
        
        //self.wvContent.userInteractionEnabled = NO;
        //self.wvContent.opaque = NO;
        //self.wvContent.backgroundColor = [UIColor clearColor];
        self.wvMain.scrollView.scrollEnabled = TRUE;
        [self.wvMain loadHTMLString: embedHTML baseURL: nil];
        
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
