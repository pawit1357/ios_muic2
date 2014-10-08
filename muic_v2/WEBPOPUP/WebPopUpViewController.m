//
//  WebPopUpViewController.m
//  MUIC Life
//
//  Created by GOKIRI on 10/5/56 BE.
//  Copyright (c) 2556 dsnsoft. All rights reserved.
//

#import "WebPopUpViewController.h"
#import "InternetStatus.h"

@interface WebPopUpViewController ()

@end

@implementation WebPopUpViewController
@synthesize web;
@synthesize baseview;
@synthesize activitie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleBottomMargin;

    }
    return self;
}
-(void)webserviewCall{

    InternetStatus *internet  = [[InternetStatus alloc]init];
    
    if([internet checkWiFiConnection]){
        
        NSString *path = [NSString stringWithFormat:@"http://www.prdapp.net/itechservice/index.php/ServiceLife/PushNews"];
        
        NSString *escapedUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)path, NULL, (CFStringRef)@" ", kCFStringEncodingUTF8));
        
        
        NSData *postData = [escapedUrlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSLog(@"%@",postLength);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]
                                                               cachePolicy:NSURLCacheStorageNotAllowed
                                                           timeoutInterval:300];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (theConnection) {
            JSONData = [[NSMutableData alloc] init];
            NSLog(@"theConnection %@",JSONData);
            [theConnection start];
        }
        else
        {
            
        }
        
    }else{
        
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"MUIC" message:@"You Question have can not send Because Internet not connecting" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        al.delegate =self;
        
        [al show];
        
        //[al release];
        
        
    }


    
}

-(void)setWebDataWithPath:(NSString*)_str{
    
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, baseview.frame.size.width,
                                                     baseview.frame.size.height)];
    
    web.delegate = self;
    web.opaque = NO;
    web.backgroundColor = [UIColor clearColor];
    web.scalesPageToFit = YES;
    //[web setUserInteractionEnabled:NO];
    NSURL *url = [NSURL URLWithString:_str];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    NSArray *subviews = web.subviews;
    NSObject *obj = nil;
    int i = 0;
    for (; i < subviews.count ; i++)
    {
        obj = [subviews objectAtIndex:i];
        
        if([[obj class] isSubclassOfClass:[UIScrollView class]] == YES)
        {
            
            ((UIScrollView*)obj).minimumZoomScale=0.5;
            ((UIScrollView*)obj).maximumZoomScale=6.0;
            //((UIScrollView*)obj).delegate=self;
            ((UIScrollView*)obj).bounces = NO;
            //((UIScrollView*)obj).zoomScale = 2.0;
            ((UIScrollView*)obj).backgroundColor = [UIColor clearColor];
            //((UIScrollView*)obj).scrollEnabled = NO;
            ((UIScrollView*)obj).userInteractionEnabled = YES;
            
        }
    }
    
    [web loadRequest:requestObj];

    [baseview addSubview:web];
    [baseview addSubview:closeBtn];
    
}
-(void)clearSelf{
    
    [self removeFromParentViewController];
    //[self.view removeFromSuperview];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self setWebDataWithPath:@"http://www.google.com"];
    
    //baseview = [[UIView alloc]initWithFrame:CGRectMake(20, 20,
                                                        //self.view.frame.size.width - 40,
                                                        //[UIScreen mainScreen].bounds.size.height - 40)];
    
    baseview = [[UIView alloc]initWithFrame:CGRectMake(20, 40,
                                                       self.view.frame.size.width - 40,
                                                       [UIScreen mainScreen].bounds.size.height /2)];
    baseview.autoresizesSubviews = YES;
    baseview.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin;

    baseview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:baseview];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"Ps-x-button.png"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(baseview.frame.size.width /2, 0, 50, 50);
    [closeBtn addTarget:self action:@selector(clearSelf) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    activitie.frame = CGRectMake((baseview.frame.size.width / 2) - (activitie.frame.size.width / 2),
                                 (baseview.frame.size.height / 2) - (activitie.frame.size.height / 2),
                                 activitie.frame.size.width,
                                 activitie.frame.size.height);
    */
    activitie.frame = CGRectMake(0,300,100,100);
    
    [baseview addSubview:activitie];
    
    [baseview addSubview:closeBtn];
    
    [self webserviewCall];
    
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [JSONData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [JSONData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    //[connection release];
    //[JSONData release];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //NSString *jsonString = [[NSString alloc] initWithBytes: [JSONData mutableBytes] length:[JSONData length] encoding:NSUTF8StringEncoding];
    
    parser = [[NSXMLParser alloc]initWithData:JSONData];
    parser.delegate = self;
    
    [parser parse];
    
}

- (void) parser: (NSXMLParser*) parser parseErrorOccurred: (NSError *) parseError{
    
	NSString * errorString = [NSString stringWithFormat:@"Unable to download xml from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
    currentElement = elementName;
    if([elementName isEqualToString:@"item"]){
        
        NSLog(@"------ start parse  item ------");
    }else if([elementName isEqualToString:@"result"]){
        
        result = [[NSMutableString alloc]init];
        
    }else if([elementName isEqualToString:@"url"]){
        
        _url = [[NSMutableString alloc]init];
       
    }else if([elementName isEqualToString:@"message"]){
        
        message = [[NSMutableString alloc]init];
       
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"item"]){
        
        NSLog(@"------ finish parse item ------");
        if((_url != Nil)||([_url isEqualToString:@""])){
            self.view.hidden = NO;
            [self setWebDataWithPath:_url];
            
        }else{
            
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
            
        }
        
        
    }else if([elementName isEqualToString:@"result"]){
        
        
    }else if([elementName isEqualToString:@"url"]){
        
        
    }else if([elementName isEqualToString:@"message"]){
        
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if(![[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString: @""]){
                
        if([currentElement isEqualToString:@"item"]){
            
           
            
        }else if([currentElement isEqualToString:@"result"]){
            
            [result setString:string];
            
        }else if([currentElement isEqualToString:@"url"]){
            
            [_url setString:string];
            
        }else if([currentElement isEqualToString:@"message"]){
            
            [message setString:string];
            
        }
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
