//
//  WebPopUpViewController.h
//  MUIC Life
//
//  Created by GOKIRI on 10/5/56 BE.
//  Copyright (c) 2556 dsnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPopUpViewController : UIViewController<UIWebViewDelegate,NSXMLParserDelegate>{
     UIWebView *web;
     UIView *baseview;
    
    UIButton *closeBtn;
    IBOutlet UIActivityIndicatorView *activitie;
    
    NSMutableData *JSONData;
    
    NSXMLParser *parser;
    
    NSString *currentElement;
    
    NSMutableString *result;
    
    NSMutableString *_url;
    
    NSMutableString *message;
    
}
@property(nonatomic,retain)  UIWebView *web;
@property(nonatomic,retain)  UIView *baseview;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activitie;

-(void)setWebDataWithPath:(NSString*)_str;

-(void)webserviewCall;

@end
