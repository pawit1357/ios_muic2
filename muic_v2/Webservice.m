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

    NSString *URL_BANNER= @"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceApp/GetBanner";
    NSString *URL_MENU= @"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceApp/GetMenu";
    NSString *URL_CONTENT= @"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceApp/GetContent";
    //NSString *URL_CONTENT_NEWS= @"http://prdapp.net/itechservice/index.php/ServiceApp/GetContentNews";
    NSString *URL_BOOK= @"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceApp/GetBook";
    NSString *URL_QUESTION= @"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceApp/GetQuestion";
    NSString *URL_REGISTER= @"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceApp/Register/udid/%@/phone_type/%d";
    NSString *URL_VERSION =@"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceApp/GetVersion";
    NSString *URL_POPUP=@"https://ed.muic.mahidol.ac.th/itech2/index.php/ServiceLife/PushNews";

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
    
        NSHTTPURLResponse *response = nil;
        NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_BANNER ];
        NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //-- Get request and response though URL
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        //-- JSON Parsing
        NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"Result = %@",result);
    if( result != nil){
        if( result.count>0 ){
            [[BannerDao BannerDao] deleteAll];
            for (NSMutableDictionary *dataDict in result)
            {
                ModelBanner *banner = [[ModelBanner alloc] init];
                banner.id = [[dataDict objectForKey:@"id"] integerValue];
                banner.app_id = [[dataDict objectForKey:@"app_id"] integerValue];
                banner.image_url = [dataDict objectForKey:@"image_url"];
                banner.status = [dataDict objectForKey:@"status"];
            
                if( [[[BannerDao BannerDao] getSingle:banner.id ] count]> 0 ){
                    if( [banner.status isEqualToString:@"I"] ){
                        [[BannerDao BannerDao] deleteModel:banner];
                    }else{
                        [[BannerDao BannerDao]  updateModel:banner];
                    }
                }else{
                    if( ![banner.status isEqualToString:@"I"] ){
                        [[BannerDao BannerDao]  saveModel:banner];
                    }
                }
            }
        }
}
    return TRUE;
}

- (BOOL) getMenu{
    //-- Make URL request with server

    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_MENU ];
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    if( result != nil){
        if( result.count>0 ){
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
        menu.status = [dataDict objectForKey:@"status"];
        
        if( [[MenuDao MenuDao] getSingleMenu:menu.id ] != nil ){
            if( [menu.status isEqualToString:@"I"] ){
                [[MenuDao MenuDao] deleteMenu:menu];
            }else{
                [[MenuDao MenuDao]  updateMenu:menu];
            }
        }else{
            if( ![menu.status isEqualToString:@"I"] ){
                [[MenuDao MenuDao]  saveMenu:menu];
            }
        }
    }
        }
}
    return TRUE;
}

- (BOOL) getContent{
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_CONTENT ];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    if( result != nil){
        if( result.count>0 ){
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
        content.status = [dataDict objectForKey:@"status"];


        if( [[ContentDao ContentDao] getSingleContent:content.id ] != nil ){
            if( [content.status isEqualToString:@"I"] ){
                [[ContentDao ContentDao] deleteContent:content];
            }else{
                [[ContentDao ContentDao]  updateContent:content];
            }
        }else{
            if( ![content.status isEqualToString:@"I"] ){
                 [[ContentDao ContentDao]  saveContent:content];
            }
        }
        }
         }
        }
    return TRUE;
}
/*
- (BOOL) getNewsEvent{
    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_CONTENT_NEWS ];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    if(result.count>0){
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
            content.status = [dataDict objectForKey:@"status"];
            
            if( [[[ContentDao ContentDao] getSingleContent:content.id ] count]> 0 ){
                if( [content.status isEqualToString:@"I"] ){
                    [[ContentDao ContentDao] deleteContent:content];
                }else{
                    [[ContentDao ContentDao]  updateContent:content];
                }
            }else{
                if( ![content.status isEqualToString:@"I"] ){
                    [[ContentDao ContentDao]  saveContent:content];
                }
            }
        }
    }
    return TRUE;
}
 */
- (BOOL) GetBook{
    //-- Make URL request with server

    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_BOOK ];

    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    if( result != nil){
        if( result.count>0 ){
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
        
        
        if( [[[BookDao BookDao] getSingleBook:book.id ] count]> 0 ){
            if( [book.status isEqualToString:@"I"] ){
                [[BookDao BookDao] deleteBook:book];
            }else{
                [[BookDao BookDao]  updateBook:book];
            }
        }else{
            if( ![book.status isEqualToString:@"I"] ){
                [[BookDao BookDao]  saveBook:book];
            }
        }

    }
         }
        }
    return TRUE;
}

- (BOOL) GetQuestion{
    //-- Make URL request with server

    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_QUESTION ];

    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    if( result != nil){
        if( result.count>0 ){

    for (NSMutableDictionary *dataDict in result)
    {
        
        ModelFaq *quest = [[ModelFaq alloc] init];
        quest.id = [[dataDict objectForKey:@"id"] integerValue];
        quest.app_id = [[dataDict objectForKey:@"app_id"] integerValue];
        quest.question = [dataDict objectForKey:@"question"];
        quest.status = [dataDict objectForKey:@"status"];
        quest.create_date = [dataDict objectForKey:@"create_date"];
        quest.isRead = [dataDict objectForKey:@"isRead"];
        quest.answer = [dataDict objectForKey:@"answer"];
        

        if( [[FaqDao FaqDao] getSingleQuestion:quest.id ] != nil ){
            if( [quest.status isEqualToString:@"I"] ){
                [[FaqDao FaqDao] deleteQuestion:quest];
            }else{
                [[FaqDao FaqDao]  updateQuestion:quest];
            }
        }else{
            if( ![quest.status isEqualToString:@"I"] ){
                [[FaqDao FaqDao]  saveQuestion:quest];
            }
        }
    }
    }
    }
    return TRUE;
}


- (ModelPopup*) GetPopup{
    //-- Make URL request with server
    ModelPopup *model = nil;
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@",URL_POPUP ];
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    if( result != nil){
        if( result.count>0 ){
        
        for (NSMutableDictionary *dataDict in result)
        {
            model = [[ModelPopup alloc] init];
            model.id = [[dataDict objectForKey:@"id"] integerValue];
            model.url = [dataDict objectForKey:@"url"];
            model.message = [dataDict objectForKey:@"message"];
        }
        }
    }

    return model;
}


- (BOOL) registerDevice:(NSString*) udid andPhoneType:(NSString*)phone_type{
    
    NSString *escapedUrlString = [NSString stringWithFormat:URL_REGISTER,udid,@"1"];
    
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
        [theConnection start];
    }
    else
    {
        
    }
    return true;
}

- (NSInteger) isUpdateApp{
    //-- Make URL request with server
    NSInteger version = 0;
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:URL_VERSION,@""];
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"Result = %@",result);
    if( result != nil){
        if( result.count>0 ){
        for (NSMutableDictionary *dataDict in result)
        {
            version =  [[dataDict objectForKey:@"version"] integerValue];
            
        }
    }
}



    return version;
}

@end
