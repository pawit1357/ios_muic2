//
//  NewsDetailController.m
//  muic_v2
//
//  Created by pawit on 9/22/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "NewsDetailController.h"
#import "ContentDao.h"
#import "NSData+Base64.h"
@interface NewsDetailController ()

@end

@implementation NewsDetailController

@synthesize wvMain,spinner;

-(void) seContentItem:(id)newContentItem{
    
    _contentItem = newContentItem;
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
        //update already read content
        content.read = @"1";
        
        Boolean result = (Boolean)[[ContentDao ContentDao] updateReadContent:content];
        if(result){
            NSLog(@"Complete update read status.");
        }
        
        
        NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
        NSString *css = [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
        
        NSString *embedHTML =[NSString stringWithFormat: @"<html><head><style type=\"text/css\">%@</style></head><body>%@</body></html>",css,[[NSString alloc] initWithData:[NSData dataFromBase64String:content.description] encoding:NSUTF8StringEncoding]];
        
        

        
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
