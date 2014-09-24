//
//  LibraryDetailController.m
//  muic_v2
//
//  Created by pawit on 9/23/2557 BE.
//  Copyright (c) 2557 muic. All rights reserved.
//

#import "LibraryDetailController.h"
#import "SWRevealViewController.h"
#import "ModelBook.h"

@interface LibraryDetailController ()

@end

@implementation LibraryDetailController


@synthesize tvMain,bookList,filteredBookList,isFiltered,searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    searchBar.delegate = (id)self;
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) setBookList:(NSMutableArray *)newBookList{
    
    if(bookList != newBookList){
        bookList = newBookList;
    }
    
    [self prepareContent];
}

- (void) prepareContent{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ModelBook *model;
    if(isFiltered)
        model = (ModelBook *)[self.filteredBookList objectAtIndex:indexPath.row];
    else
        model = (ModelBook *)[self.bookList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *lbBook = (UILabel *)[cell viewWithTag:101];
    lbBook.text = model.book_name;
    
    UILabel *lbTitle = (UILabel *)[cell viewWithTag:102];
    lbTitle.text = model.book_title;
    
    
    //col 1
    UILabel *lbAuthor = (UILabel *)[cell viewWithTag:103];
    lbAuthor.text = model.book_author;
    
    UILabel *lbCallNo = (UILabel *)[cell viewWithTag:104];
    lbCallNo.text = model.callNo;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // retrive image on global queue
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.book_cover]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // assign cell image on main thread
            UIImageView *vehicleImg = (UIImageView *)[cell viewWithTag:100];
            vehicleImg.image = img;
        });
    });
    
    return cell;
}

#pragma mark -

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredBookList.count;
    else
        rowCount = bookList.count;
    
    return rowCount;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
    ShowWimDetailController *transferViewController = segue.destinationViewController;
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"showWimDetail"])
    {
        
        NSIndexPath *indexPath = [self.viewList indexPathForSelectedRow];
        NSArray *info = self.wimData[indexPath.row];
        
        [transferViewController setWimDetailItem:info];
    }
    */
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredBookList = [[NSMutableArray alloc] init];
        
        for (ModelBook* book in bookList)
        {
            NSRange nameRange = [book.book_name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [book.book_title rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredBookList addObject:book];
            }
        }
    }
    [self.tvMain reloadData];
}

@end
