//
//  Webservice.m
//  muic_v2
//
//  Created by pawit on 9/29/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "Webservice.h"
#import "ModelConfig.h"
#import "ModelBanner.h"
#import "ModelConfig.h"
#import "ModelMenu.h"
#import "ModelBook.h"
#import "ModelContent.h"
#import "ModelFaq.h"

@implementation Webservice

    NSString *URL_BANNER= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetBanner";
    NSString *URL_MENU= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetMenu";
    NSString *URL_CONTENT= @" http://prdapp.net/itechservice/index.php/ServiceApp/GetContent";
    NSString *URL_BOOK= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetBook";
    NSString *URL_QUESTION= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetQuestion";
    NSString *URL_REGISTER= @"http://prdapp.net/itechservice/index.php/ServiceAccount/Register/user/%@/phone_type/%d";
    NSString *URL_SENDFAQ =@"http://prdapp.net/itechservice/index.php/ServiceLib/SendQuestion/question/%@/udid/%@";

static Webservice *_webservice = nil;

+(id)Webservice{
    @synchronized(self) {
        
        if (_webservice == nil)
            _webservice = [[self alloc] init];
    }
    return _webservice;
}

- (NSMutableArray*) getBanner{
        //-- Make URL request with server
        
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSHTTPURLResponse *response = nil;
    
        NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_BANNER ];
    
        NSLog(@"%@",jsonUrlString);
        
        NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //-- Get request and response though URL
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        //-- JSON Parsing
        NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"Result = %@",result);
        
        for (NSMutableDictionary *dataDict in result)
        {
            
            ModelBanner *model = [[ModelBanner alloc] init];
            model.id = [[dataDict objectForKey:@"id"] integerValue];
            model.app_id = [[dataDict objectForKey:@"app_id"] integerValue];
            model.image_url = [dataDict objectForKey:@"image_url"];

            // Add the wim object to the wims Array
            [data addObject:model];
        }
    
        return data;
    }

- (NSMutableArray*) getMenu{
    //-- Make URL request with server
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_MENU ];
    
    NSLog(@"%@",jsonUrlString);
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelMenu *model = [[ModelMenu alloc] init];
        model.id= [[dataDict objectForKey:@"id"] integerValue];
        model.app_id= [[dataDict objectForKey:@"app_id"] integerValue];
        model.parent= [[dataDict objectForKey:@"parent"] integerValue];
        model.name= [dataDict objectForKey:@"name"];
        model.icon= [dataDict objectForKey:@"icon"];
        model.type= [[dataDict objectForKey:@"type"] integerValue];
        model.description = [dataDict objectForKey:@"description"];
        
        // Add the wim object to the wims Array
        [data addObject:model];
    }
    
    return data;
}

- (NSMutableArray*) getContent{
    //-- Make URL request with server
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_CONTENT ];
    
    NSLog(@"%@",jsonUrlString);
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelContent *model = [[ModelContent alloc] init];
        
        model.id = [[dataDict objectForKey:@"id"] integerValue];
        model.app_id = [[dataDict objectForKey:@"app_id"] integerValue];
        model.menu_id = [[dataDict objectForKey:@"menu_id"] integerValue];
        model.title = [dataDict objectForKey:@"title"];
        model.sub_title =[dataDict objectForKey:@"sub_title"];
        model.description = [dataDict objectForKey:@"description"];
        model.image_url = [dataDict objectForKey:@"image_url"];
        model.read = [dataDict objectForKey:@"read"];
        model.create_date = [dataDict objectForKey:@"create_date"];

        // Add the wim object to the wims Array
        [data addObject:model];
    }
    
    return data;
}

- (NSMutableArray*) GetBook{
    //-- Make URL request with server
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_BOOK ];
    
    NSLog(@"%@",jsonUrlString);
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelBook *model = [[ModelBook alloc] init];
        
        model.id = [[dataDict objectForKey:@"id"] integerValue];
        model.book_name = [dataDict objectForKey:@"book_name"];
        model.book_title = [dataDict objectForKey:@"book_title"];
        model.book_cover = [dataDict objectForKey:@"book_cover"];
        model.book_author = [dataDict objectForKey:@"book_author"];
        model.callNo = [dataDict objectForKey:@"callNo"];
        model.division = [dataDict objectForKey:@"division"];
        model.program = [dataDict objectForKey:@"program"];
        model.type = [dataDict objectForKey:@"type"];
        model.status = [dataDict objectForKey:@"status"];
        model.flag = [dataDict objectForKey:@"flag"];
        model.recommended = [dataDict objectForKey:@"recommended"];
        
        // Add the wim object to the wims Array
        [data addObject:model];
    }
    
    return data;
}

- (NSMutableArray*) GetQuestion{
    //-- Make URL request with server
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_QUESTION ];
    
    NSLog(@"%@",jsonUrlString);
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelFaq *model = [[ModelFaq alloc] init];
        model.id = [[dataDict objectForKey:@"id"] integerValue];
        model.app_id = [[dataDict objectForKey:@"id"] integerValue];
        model.question = [dataDict objectForKey:@"book_author"];
        model.status = [dataDict objectForKey:@"book_author"];
        model.create_date = [dataDict objectForKey:@"book_author"];
        model.isRead = [dataDict objectForKey:@"book_author"];
        model.answer = [dataDict objectForKey:@"book_author"];
        
        
        // Add the wim object to the wims Array
        [data addObject:model];
    }
    
    return data;
}

- (BOOL) registerDevice:(NSString*) udid{
    
    NSString *escapedUrlString = [NSString stringWithFormat:URL_REGISTER,udid,@"2"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:300];
    NSData *postData = [escapedUrlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
        [theConnection start];
    }
    else
    {
        
    }
    return true;
}

- (BOOL) sendFAQ:(NSString*) question andUdid:(NSString*) udid{
    NSString *escapedUrlString = [NSString stringWithFormat:URL_SENDFAQ,question,udid];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:300];
    NSData *postData = [escapedUrlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
        [theConnection start];
    }
    else
    {
        
    }
    return true;
}

@end
