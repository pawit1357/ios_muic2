//
//  SendFaqController.m
//  muic_v2
//
//  Created by pawit on 10/7/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "SendFaqController.h"
#import "Webservice.h"
#import "InternetStatus.h"
#import "NSData+Base64.h"

@implementation SendFaqController

NSString *URL_SENDFAQ =@"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceLib/SendQuestion/question/%@";

@synthesize txtMsg,spinner;


- (void)viewDidLoad {
    [super viewDidLoad];


}

- (IBAction)btnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSend:(id)sender {
   
    
    NSString* str = [NSString stringWithUTF8String:[txtMsg.text cStringUsingEncoding:NSUTF8StringEncoding]];
    
    //Init the NSURLSession with a configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //Create an URLRequest
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_SENDFAQ,str]];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //Create POST Params and add it to HTTPBody
    //NSString *params = @"/question/pawit";
    //[urlRequest setHTTPMethod:@"POST"];
    //[urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Create task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle your response here
    }];
    
    [dataTask resume];
    
    NSString *jsonString = [[NSString alloc] initWithBytes: [JSONData mutableBytes] length:[JSONData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"success %@",jsonString);
    [spinner stopAnimating];
    spinner.hidden = YES;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Muic"
                                                      message:@"Your Question have been Send."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    message.delegate = self;
    [message show];
    
    
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    /*
    InternetStatus *internet  = [[InternetStatus alloc]init];

    if([internet checkWiFiConnection]){
        
        
        NSString* str = [NSString stringWithUTF8String:[txtMsg.text cStringUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *escapedUrlString = [NSString stringWithFormat:URL_SENDFAQ,str,0];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:300];
     
        NSData *postData = [escapedUrlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    
     
     NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (theConnection) {
            [spinner startAnimating];
            JSONData = [[NSMutableData alloc] init];
            NSLog(@"theConnection %@",JSONData);
            [theConnection start];
        }
        else
        {
    
     
        }
        
    }else{
        
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"MUIC" message:@"Your Question have can not send" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        al.delegate =self;

        
    }
    */


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
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *jsonString = [[NSString alloc] initWithBytes: [JSONData mutableBytes] length:[JSONData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"success %@",jsonString);
    [spinner stopAnimating];
    spinner.hidden = YES;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Muic"
                                                      message:@"Your Question have been Send."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    message.delegate = self;
    [message show];
    
    

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
