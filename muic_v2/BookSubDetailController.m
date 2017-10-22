//
//  BookSubDetailController.m
//  muic_v2
//
//  Created by pawit on 10/11/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "BookSubDetailController.h"
#import "NSData+Base64.h"

@interface BookSubDetailController ()

@end

@implementation BookSubDetailController

@synthesize wvTitle,spinner,imgBook,lbName,lbAuthor,lbCallNo,lbDivision,lbProgram;

-(void) setBookItem:(ModelBook*)newBookItem{
    _bookItem = newBookItem;
    [self prepareContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    [self prepareContent];
}

- (void) prepareContent{
    if(_bookItem){
    
        
        
        ModelBook *book = (ModelBook*)_bookItem;
        self.title = [[NSString alloc] initWithData:[NSData dataFromBase64String:book.book_name] encoding:NSUTF8StringEncoding];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[book.book_cover lastPathComponent]];
        if ([fileManager fileExistsAtPath:filePath]){
            imgBook.image =[UIImage imageWithContentsOfFile:filePath];
        }
        
        lbName.text =[[NSString alloc] initWithData:[NSData dataFromBase64String:book.book_name] encoding:NSUTF8StringEncoding];
        lbAuthor.text =[[NSString alloc] initWithData:[NSData dataFromBase64String:book.book_author] encoding:NSUTF8StringEncoding];
        lbCallNo.text =[[NSString alloc] initWithData:[NSData dataFromBase64String:book.callNo] encoding:NSUTF8StringEncoding];
        lbDivision.text = book.division;
        lbProgram.text = book.program;
        
        
        NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
        NSString *css = [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
        
        NSString *embedHTML =[NSString stringWithFormat: @"<html><head><style type=\"text/css\">%@</style></head><body>%@</body></html>",css,[[NSString alloc] initWithData:[NSData dataFromBase64String:book.book_title] encoding:NSUTF8StringEncoding]];
        
        //self.wvContent.userInteractionEnabled = NO;
        //self.wvContent.opaque = NO;
        //self.wvContent.backgroundColor = [UIColor clearColor];
        self.wvTitle.scrollView.scrollEnabled = TRUE;
        [self.wvTitle loadHTMLString: embedHTML baseURL: nil];
    }
}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    [spinner startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
