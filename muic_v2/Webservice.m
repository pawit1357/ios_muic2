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


#import "BannerDao.h"
#import "ContentDao.h"
#import "MenuDao.h"
#import "BookDao.h"
#import "AppConfigDao.h"
#import "FaqDao.h"

@implementation Webservice

    NSString *URL_BANNER= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetBanner";
    NSString *URL_MENU= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetMenu";
    NSString *URL_CONTENT= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetContent";
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

- (void) syncronizeData{
    
}

- (BOOL) getBanner{
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
        if(result.count>0){
        [[BannerDao BannerDao] deleteAll];
        for (NSMutableDictionary *dataDict in result)
        {
            ModelBanner *banner = [[ModelBanner alloc] init];
            banner.id = [[dataDict objectForKey:@"id"] integerValue];
            banner.app_id = [[dataDict objectForKey:@"app_id"] integerValue];
            banner.image_url = [dataDict objectForKey:@"image_url"];

            [[BannerDao BannerDao]  saveModel:banner];
            // Add the wim object to the wims Array
            [data addObject:banner];
        }
}
        return TRUE;
    }

- (BOOL) getMenu{
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
        if(result.count>0){
    [[MenuDao MenuDao] deleteAll];
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelMenu *menu = [[ModelMenu alloc] init];
        menu.id= [[dataDict objectForKey:@"id"] integerValue];
        menu.app_id= [[dataDict objectForKey:@"app_id"] integerValue];
        menu.parent= [[dataDict objectForKey:@"parent"] integerValue];
        menu.name= [dataDict objectForKey:@"name"];
        menu.icon= [dataDict objectForKey:@"icon"];
        menu.type= [[dataDict objectForKey:@"type"] integerValue];
        menu.description = [dataDict objectForKey:@"description"];
        
        [[MenuDao MenuDao] saveModel:menu];
        // Add the wim object to the wims Array
        [data addObject:menu];
    }
}
    return TRUE;
}

- (BOOL) getContent{
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
        if(result.count>0){
    [[ContentDao ContentDao] deleteAll];
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelContent *content = [[ModelContent alloc] init];
        
        content.id = [[dataDict objectForKey:@"id"] integerValue];
        content.app_id = [[dataDict objectForKey:@"app_id"] integerValue];
        content.menu_id = [[dataDict objectForKey:@"menu_id"] integerValue];
        
        if( [dataDict objectForKey:@"title"] != nil){
            content.title = [dataDict objectForKey:@"title"];
        }else{
            content.title = @" ";
        }
        if([dataDict objectForKey:@"sub_title"] != nil){
            content.sub_title =[dataDict objectForKey:@"sub_title"];
        }else{
            content.sub_title = @" ";
        }
        if([dataDict objectForKey:@"description"] != nil){
            //NSData *data = [NSData dataFromBase64String:[dataDict objectForKey:@"description"]];
            //NSString *convertedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            content.description = [dataDict objectForKey:@"description"];
        }else{
            content.description = @" ";
        }
        if([dataDict objectForKey:@"image_url"] != nil){
            content.image_url = [dataDict objectForKey:@"image_url"];
        }else{
            content.image_url = @" ";
        }
        if([dataDict objectForKey:@"read"] != nil){
            content.read = [dataDict objectForKey:@"read"];
        }else{
            content.read = @" ";
        }
        if([dataDict objectForKey:@"create_date"] != nil){
            content.create_date =  [dataDict objectForKey:@"create_date"];
        }else{
            content.create_date = @" ";
        }
        
        [[ContentDao ContentDao] saveModel:content];
        // Add the wim object to the wims Array
        [data addObject:content];
    }
        }
    return TRUE;
}

- (BOOL) GetBook{
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
        if(result.count>0){
    [[BookDao BookDao] deleteAll];
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelBook *book = [[ModelBook alloc] init];
        
        book.id = [[dataDict objectForKey:@"id"] integerValue];
        book.book_name = [dataDict objectForKey:@"book_name"];
        book.book_title = [dataDict objectForKey:@"book_title"];
        book.book_cover = [dataDict objectForKey:@"book_cover"];
        book.book_author = [dataDict objectForKey:@"book_author"];
        book.callNo = [dataDict objectForKey:@"callNo"];
        book.division = [dataDict objectForKey:@"division"];
        book.program = [dataDict objectForKey:@"program"];
        book.type = [dataDict objectForKey:@"type"];
        book.status = [dataDict objectForKey:@"status"];
        book.flag = [dataDict objectForKey:@"flag"];
        book.recommended = [dataDict objectForKey:@"recommended"];
        
        [[BookDao BookDao]saveModel:book];
        // Add the wim object to the wims Array
        [data addObject:book];
    }
        }
    return TRUE;
}

- (BOOL) GetQuestion{
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
    if(result.count>0){
    [[FaqDao FaqDao]deleteAll];
    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelFaq *quest = [[ModelFaq alloc] init];
        quest.id = [[dataDict objectForKey:@"id"] integerValue];
        quest.app_id = [[dataDict objectForKey:@"id"] integerValue];
        quest.question = [dataDict objectForKey:@"book_author"];
        quest.status = [dataDict objectForKey:@"book_author"];
        quest.create_date = [dataDict objectForKey:@"book_author"];
        quest.isRead = [dataDict objectForKey:@"book_author"];
        quest.answer = [dataDict objectForKey:@"book_author"];
        
        [[FaqDao FaqDao] saveModel:quest];
        // Add the wim object to the wims Array
        [data addObject:quest];
    }
    }
    return TRUE;
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
