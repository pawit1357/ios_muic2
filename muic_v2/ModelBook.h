//
//  ModelBook.h
//  muic_v2
//
//  Created by pawit on 9/23/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBook : NSObject{

    NSInteger id;
    NSString * book_name;
    NSString * book_cover;
    NSString * book_title;
    NSString * book_author;
    NSString * callNo;
    NSString * division;
    NSString * program;
    NSString * type;
    NSString * status;
    NSString * flag;
    NSString * recommended;
    NSDate * create_date;

}

@property (nonatomic) NSInteger id;
@property (nonatomic, retain) NSString *book_name;
@property (nonatomic, retain) NSString *book_cover;
@property (nonatomic, retain) NSString *book_title;
@property (nonatomic, retain) NSString *book_author;
@property (nonatomic, retain) NSString *callNo;
@property (nonatomic, retain) NSString *division;
@property (nonatomic, retain) NSString *program;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *flag;
@property (nonatomic, retain) NSString *recommended;
@property (nonatomic, retain) NSDate *create_date;


@end
