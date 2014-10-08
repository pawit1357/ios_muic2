//
//  SendFaqController.h
//  muic_v2
//
//  Created by pawit on 10/7/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendFaqController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>{
    NSMutableData *JSONData;
}



@property (weak, nonatomic) IBOutlet UITextView *txtMsg;

- (IBAction)btnClose:(id)sender;
- (IBAction)btnSend:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
