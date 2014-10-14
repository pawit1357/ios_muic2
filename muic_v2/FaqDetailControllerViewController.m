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
#import "FaqDao.h"
#import "NSData+Base64.h"
#import "NSString_stripHtml.h"
#import "InternetStatus.h"
#import "MyUtils.h"
#import "Webservice.h"
#import "NSString_stripHtml.h"

@interface FaqDetailControllerViewController ()

@end

@implementation FaqDetailControllerViewController

@synthesize faqList,tvFaqList;


- (void)awakeFromNib
{
    expandedRowIndex = -1;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FAQ";
    // Do any additional setup after loading the view.
    backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc] initWithFrame:CGRectMake(15, 50, 290, 30)];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl setBackgroundColor:[[MyUtils MyUtils] colorFromHexString:@"#0b162b"]];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tvFaqList addSubview:refreshControl];
    
    [self prepareContent];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    NSLog(@"Begin update menu..");
    
    if(refreshControl){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
    }
    InternetStatus *internet  = [[InternetStatus alloc]init];
    if([internet checkWiFiConnection]){
        [[Webservice Webservice] GetQuestion];
        [self prepareContent];
        [self.tvFaqList reloadData];
    }
    [refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareContent{
    
    //initial current type
   self.faqList =(NSMutableArray*)[[FaqDao FaqDao] getAllQuestion];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger row = [indexPath row];
    NSInteger dataIndex = [self dataIndexForRowIndex:row];
    
    ModelFaq *model = (ModelFaq *)[self.faqList objectAtIndex:dataIndex];
    
    BOOL expandedCell = expandedRowIndex != -1 && expandedRowIndex + 1 == row;
    
    if (!expandedCell)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.imageView.image =[UIImage imageNamed:@"help_faq.png"];
        cell.textLabel.text = [[[NSString alloc] initWithData:[NSData dataFromBase64String:model.question] encoding:NSUTF8StringEncoding] stripHtml];
        cell.detailTextLabel.text = @"";
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expanded"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"expanded"];
        //cell.imageView.image =[UIImage imageNamed:@"help_faq.png"];
        //cell.textLabel.text = [[[NSString alloc] initWithData:[NSData dataFromBase64String:model.question] encoding:NSUTF8StringEncoding] stripHtml];
        cell.detailTextLabel.text = [[[NSString alloc] initWithData:[NSData dataFromBase64String:model.answer] encoding:NSUTF8StringEncoding] stripHtml];
        cell.detailTextLabel.numberOfLines = 6;
        //cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        return cell;
    }
}

#pragma mark -

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    BOOL preventReopen = NO;
    
    if (row == expandedRowIndex + 1 && expandedRowIndex != -1)
        return nil;
    
    [tableView beginUpdates];
    
    if (expandedRowIndex != -1)
    {
        NSInteger rowToRemove = expandedRowIndex + 1;
        
        preventReopen = row == expandedRowIndex;
        if (row > expandedRowIndex)
            row--;
        expandedRowIndex = -1;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    NSInteger rowToAdd = -1;
    if (!preventReopen)
    {
        rowToAdd = row + 1;
        expandedRowIndex = row;
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToAdd inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
    }
    [tableView endUpdates];
    
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.faqList count] + (expandedRowIndex != -1 ? 1 : 0);
    
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (expandedRowIndex != -1 && row == expandedRowIndex + 1)
        return 100;
    return 40;
}

- (NSInteger)dataIndexForRowIndex:(NSInteger)row
{
    if (expandedRowIndex != -1 && expandedRowIndex <= row)
    {
        if (expandedRowIndex == row)
            return row;
        else
            return row - 1;
    }
    else
        return row;
}

@end
