//
//  FaqDetailControllerViewController.m
//  muic_v2
//
//  Created by pawit on 10/7/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "FaqDetailControllerViewController.h"
#import "SWRevealViewController.h"
#import "ModelFaq.h"
#import "NSData+Base64.h"
#import "NSString_stripHtml.h"

@interface FaqDetailControllerViewController ()

@end

@implementation FaqDetailControllerViewController

@synthesize faqList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FAQ";
    // Do any additional setup after loading the view.
    backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setFaqList:(NSMutableArray *)newFaqList{
    
    if(faqList != newFaqList){
        faqList = newFaqList;
    }
    
    [self prepareContent];
}

- (void) prepareContent{
    
    //initial current type
}
        



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ModelFaq *model = (ModelFaq *)[self.faqList objectAtIndex:indexPath.row];
    NSData *data = [NSData dataFromBase64String:model.answer];
    NSString *convertedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    cell.textLabel.text = model.question;
    cell.detailTextLabel.text  = [convertedString stripHtml];
  
    return cell;
}

#pragma mark -

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.faqList.count;
    
}

@end
