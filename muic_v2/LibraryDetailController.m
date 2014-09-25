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
#import "BookDao.h"

@interface LibraryDetailController ()

@end

@implementation LibraryDetailController


@synthesize tvMain,bookList,filteredBookList,isFiltered,searchBar,segmentFilter;

//bool btnCancel = true;
//int type = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    // scroll the search bar off-screen
    CGRect newBounds = self.tvMain.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    self.tvMain.bounds = newBounds;
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

-(void) setBookList:(NSMutableArray *)newBookList{
    
    if(bookList != newBookList){
        bookList = newBookList;
    }
    
    [self prepareContent];
}

- (void) prepareContent{
    
    //initial current type
    if(self.bookList.count>0){
        ModelBook *book = (ModelBook *)[self.bookList objectAtIndex:0];
        bookType = book.type;
    }
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
    
    UIImageView *bookImg = (UIImageView *)[cell viewWithTag:100];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(CGRectGetWidth(bookImg.bounds)/2, CGRectGetHeight(bookImg.bounds)/2)];
    [spinner setColor:[UIColor grayColor]];
    
    [bookImg addSubview:spinner];
    
    // start spinner
    [spinner startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // retrive image on global queue
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.book_cover]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // assign cell image on main thread
            bookImg.image = img;
            
            [spinner stopAnimating];
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
    //[self.searchDisplayController setActive:YES];
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


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    
    [self.searchBar resignFirstResponder];
    /*
    LibraryDetailController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"bookDetail"];
    ModelBook* book;
    
    if(isFiltered)
    {
        book = [filteredBookList objectAtIndex:indexPath.row];
    }
    else
    {
        book = [bookList objectAtIndex:indexPath.row];
    }
    
    vc.food = book;
     */
    //[self.navigationController pushViewController:vc animated:true];
     
}


- (void)activateSearch {
    [self.tvMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.searchBar becomeFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    // hide the search bar when users are finished
    // we could implement the same code as in viewDidAppear
    // or even easier: just call that method
    [self viewWillAppear:YES];
    
}

// this method is never called
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    NSLog(@"Search Controller did end search");
}

- (IBAction)displaySearchBar:(id)sender {
    // makes the search bar visible
    // no longer works in iOS 7
    // [self.searchBar becomeFirstResponder];
    
    // SUGGESTED BY JANOS HOMOKI
    // makes the search bar visible
    if(isFiltered){
        [self.tvMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
        NSTimeInterval delay;
        if (self.tvMain.contentOffset.y >1000) delay = 0.4;
        else delay = 0.1;
            [self performSelector:@selector(activateSearch) withObject:nil afterDelay:delay];
    }else{
        [self.searchBar resignFirstResponder];
        [self searchBarCancelButtonClicked:searchBar];
    }
    isFiltered = !isFiltered;
}

- (IBAction)segmentFilter:(id)sender {
    
    if(!isFiltered){
            
        if(segmentFilter.selectedSegmentIndex == 1){
            self.bookList = (NSMutableArray*)[[BookDao BookDao] getBookRelease:bookType];

        }else if(segmentFilter.selectedSegmentIndex == 2){
            self.bookList = (NSMutableArray*)[[BookDao BookDao] getBookRecommted:bookType];
        }else{
            self.bookList = (NSMutableArray*)[[BookDao BookDao] getBookByType:bookType];

        }
        [self.tvMain reloadData];
        
    }
}

@end
