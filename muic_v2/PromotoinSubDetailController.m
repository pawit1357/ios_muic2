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
        
        
        NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
        NSString *css = [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
        
        NSString *embedHTML =[NSString stringWithFormat: @"<html><head><style type=\"text/css\">%@</style></head><body>%@</body></html>",css,[[NSString alloc] initWithData:[NSData dataFromBase64String:content.description] encoding:NSUTF8StringEncoding]];
        
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
