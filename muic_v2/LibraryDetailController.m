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
#import "NSString_stripHtml.h"
#import "NSData+Base64.h"
#import "BookSubDetailController.h"

@interface LibraryDetailController ()

@end

@implementation LibraryDetailController


@synthesize tvMain,bookList,filteredBookList,isFiltered,searchBar,segmentFilter;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Book list";
    fileManager = [NSFileManager defaultManager];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"simpleMenuButton.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    backButton.target = self.revealViewController;
    
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    // scroll the search bar off-screen
    CGRect newBounds = self.tvMain.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    self.tvMain.bounds = newBounds;
    //backButton.tintColor = [UIColor grayColor];
}

- (void)viewDidUnload
{
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
    if(isFiltered){
        if(filteredBookList.count >indexPath.row){
            model = (ModelBook *)[self.filteredBookList objectAtIndex:indexPath.row];
        }
    }
    else{
        if(bookList.count>indexPath.row){
            model = (ModelBook *)[self.bookList objectAtIndex:indexPath.row];
        }
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
   
    
    
    UILabel *lbBook = (UILabel *)[cell viewWithTag:101];
    lbBook.text =  [[NSString alloc] initWithData:[NSData dataFromBase64String:model.book_name] encoding:NSUTF8StringEncoding];
    
    UILabel *lbTitle = (UILabel *)[cell viewWithTag:102];
    lbTitle.text = [[[NSString alloc] initWithData:[NSData dataFromBase64String:model.book_title] encoding:NSUTF8StringEncoding] stripHtml];
    
    
    //col 1
    UILabel *lbAuthor = (UILabel *)[cell viewWithTag:103];
    lbAuthor.text = [[NSString alloc] initWithData:[NSData dataFromBase64String:model.book_author] encoding:NSUTF8StringEncoding];;
    
    UILabel *lbCallNo = (UILabel *)[cell viewWithTag:104];
    lbCallNo.text = [[NSString alloc] initWithData:[NSData dataFromBase64String:model.callNo] encoding:NSUTF8StringEncoding];;
    
    UIImageView *bookImg = (UIImageView *)[cell viewWithTag:100];
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(CGRectGetWidth(bookImg.bounds)/2, CGRectGetHeight(bookImg.bounds)/2)];
    [spinner setColor:[UIColor grayColor]];
    
    [bookImg addSubview:spinner];
    
    [spinner startAnimating];
    
    

    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[model.book_cover lastPathComponent]];
    
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if( [[filePath pathExtension] isEqualToString:@""] ){
        bookImg.image =[UIImage imageNamed:@"news_layout.png"];
    }else if ( fileExists ){
        
        bookImg.image =[UIImage imageWithContentsOfFile:filePath];
        [spinner stopAnimating];
        
    }else{
        // download the image asynchronously
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Books: Downloading Started");
//            NSString * urlImg = [self URLEncodeString:@"https://ed.muic.mahidol.ac.th/itech2/images/muiclogo.png"];

            NSURL  *url = [NSURL URLWithString:model.book_cover];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                //saving is done on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [urlData writeToFile:filePath atomically:YES];
                    NSLog(@"Books: File Saved !");
                    bookImg.image =[UIImage imageWithData:urlData];
                    [spinner stopAnimating];
                });
            }else{
                bookImg.image =[UIImage imageNamed:@"news_layout.png"];
            }
            
        });
    }
     
    return cell;
}




-(BOOL)downloadMedia :(NSString*)url_ :(NSString*)name{
    NSString *stringURL = url_;
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSError* error = nil;
    
    NSData *urlData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Data has loaded successfully.");
    }
    
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,name];
        [urlData writeToFile:filePath atomically:YES];
        return YES;
    }
    return NO;
}

-(UIImage*)loadMedia :(NSString*)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:name];
    UIImage *img_ = [UIImage imageWithContentsOfFile:getImagePath];
    return img_;
}

#pragma mark -

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(NSString *) URLEncodeString:(NSString *) str
{
    
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount;
    if(self.isFiltered)
        rowCount = filteredBookList.count;
    else
        rowCount = bookList.count;
    
    return rowCount;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"bookSubDetail"]){
        
        BookSubDetailController *transferViewController = segue.destinationViewController;
        
        NSIndexPath *selectedIndexPath = [self.tvMain indexPathForSelectedRow];
        
        ModelBook *book= (ModelBook *)self.bookList[selectedIndexPath.row];
        
        [transferViewController setBookItem:book];
    }
    
    
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


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    
    [self.searchBar resignFirstResponder];
     
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
    
    self.isFiltered = false;
    
        if(segmentFilter.selectedSegmentIndex == 1){
            self.bookList = (NSMutableArray*)[[BookDao BookDao] getBookRelease:bookType];

        }else if(segmentFilter.selectedSegmentIndex == 2){
            self.bookList = (NSMutableArray*)[[BookDao BookDao] getBookRecommted:bookType];
        }else{
            self.bookList = (NSMutableArray*)[[BookDao BookDao] getBookByType:bookType];

        }
        [self.tvMain reloadData];
}

@end
