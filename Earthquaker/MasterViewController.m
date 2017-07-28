//
//  MasterViewController.m
//  Earthquaker
//
//  Created by swcl on 2017-07-23.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "APICallerPlaceImage.h"
#import "AppDelegate.h"
#import "QuakeCell.h"
#import <QuartzCore/QuartzCore.h>



typedef NS_ENUM(NSInteger, ScopeIndexes) {
  kAllScope = 0,
  kMagnitudeScope,
  kFeltScope
  
};

@interface MasterViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic)  NSArray *dataEarthquakes;
@property (nonatomic)  NSArray *searchResults;


@property (nonatomic, strong) NSMutableArray *quakesDataAll;   // all quakes data
@property (nonatomic, strong) NSMutableArray *searchedQuakesData;  // all quakes data found based on the search bar's scope
@property (nonatomic, strong) NSArray *filteredQuakesData;  // data currently being filtered in and out while typing in the search bar

// for state restoration
@property BOOL restoringSearchState;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property (nonatomic, strong) NSString *searchControllerText;
@property (assign) NSInteger searchControllerScopeIndex;

@property BOOL searchControllerActiveFromPreviousView;



@end

@implementation MasterViewController


- (void)viewDidLoad {

  [super viewDidLoad];
  self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  self.context = self.appDelegate.persistentContainer.viewContext;
  [self fetchUSGSData];
  self.dataEarthquakes = @[];
  self.searchResults = @[];
//  [self setupSearchController];
  [self.tableView reloadData];
self.navigationItem.title = @"Shaker - Realtime Earthquake Data";
  
  
  // setup our search display controller
  //
  _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self;
  [self.searchController.searchBar sizeToFit];
  self.tableView.tableHeaderView = self.searchController.searchBar;
  
  self.searchController.delegate = self;
  self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
  
  self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
  self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
  
  // Search is now just presenting a view controller. As such, normal view controller
  // presentation semantics apply. Namely that presentation will walk up the view controller
  // hierarchy until it finds the root view controller or one that defines a presentation context.
  //
  self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
  
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

#pragma mark - UISearchBarDelegate

// called when UISearchBar's keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  // all we do here is dismiss the keyboard
  [searchBar resignFirstResponder];
}

//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
//  [self updateSearchResultsForSearchController:self.searchController];
//}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
  // user tapped the scope bar, toggling between: All, Mine, Recents, or Near Me, to change the search criteria
  if (self.quakesDataAll.count > 0)
  {
    switch (self.searchController.searchBar.selectedScopeButtonIndex)
    {
      case kAllScope:
      {
        // search all data
        [self searchAll];
        break;
      }
        
      case kMagnitudeScope:
      {
        // search for data by magnitude
        [self searchMagnitude];
        break;
      }
        
      case kFeltScope:
      {
        // find data by felt
        [self searchFelt];
        break;
      }
        
    }
  }
  
}



- (void)searchAll
{
  // search for all data
    [self updateSearchResultsForSearchController:self.searchController];

}

- (void)searchMagnitude {
   // start the search with predicate
  
//      NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"creatorUserRecordID", ourLoggedInRecordID];
//
  
  NSString *searchString = _searchController.searchBar.text;
  if (!searchString.length) {
    self.searchResults =self.dataEarthquakes;
  } else {
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF.%K contains[cd] %@", @"mag", strippedString];
    self.fetchedResultsController.fetchRequest.predicate = resultPredicate;
    NSError *err = nil;
    [self.fetchedResultsController performFetch:&err];
    if (err != nil) {
      NSLog(@"Error searching: %@", err.localizedDescription);
      abort();
    }
    [self.tableView reloadData];
    
  }

}

- (void)searchFelt {
  // start the search with predicate
  
//  NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"creatorUserRecordID", ourLoggedInRecordID];
//
  NSString *searchString = _searchController.searchBar.text;
  if (!searchString.length) {
    self.searchResults =self.dataEarthquakes;
  } else {
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF.%K contains[cd] %@", @"felt", strippedString];
    self.fetchedResultsController.fetchRequest.predicate = resultPredicate;
    NSError *err = nil;
    [self.fetchedResultsController performFetch:&err];
    if (err != nil) {
      NSLog(@"Error searching: %@", err.localizedDescription);
      abort();
    }
    [self.tableView reloadData];
    
  }

  
}


#pragma mark - SearchBar and UISearchController

- (void)setupSearchController {
  // Setup the Search Controller
  // following delegates are included in the H file UISearchBarDelegate, UISearchControllerDelegate and UISearchResultsUpdating.
  
  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self; //updater delegate, in H file
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.delegate = self;
  
  NSArray *scopeTitles = @[@"all", @"mag", @"felt"]; //to be used for segmented controls
  scopeTitles =  self.searchController.searchBar.scopeButtonTitles;
  
  self.tableView.tableHeaderView = self.searchController.searchBar;
  self.definesPresentationContext = YES;
  [self.searchController.searchBar sizeToFit];
}


//implementing the required method for the delegate - searchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  NSString *searchString = searchController.searchBar.text;
  if (!searchString.length) {
    self.searchResults =self.dataEarthquakes;
  } else {
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF.%K contains[cd] %@", @"title", strippedString];
    self.fetchedResultsController.fetchRequest.predicate = resultPredicate;
    NSError *err = nil;
    [self.fetchedResultsController performFetch:&err];
    if (err != nil) {
      NSLog(@"Error searching: %@", err.localizedDescription);
      abort();
    }
    [self.tableView reloadData];
  
  }
}





#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController
{
  _searchedQuakesData = [self.quakesDataAll copy];   // start our search with all data
  
  // configure the search bar scope buttons
  NSMutableArray *scopeTitles = [NSMutableArray arrayWithArray:
                                 @[NSLocalizedString(@"All", nil),
                                   NSLocalizedString(@"Magnitude", nil),
                                   NSLocalizedString(@"Felt", nil)]];
  
  self.searchController.searchBar.scopeButtonTitles = scopeTitles;
  
  self.refreshControl.enabled = NO;   // no refreshing the table while filtering
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
  self.refreshControl.enabled = YES;  // bring back refresh control
  [self.tableView reloadData];        // reset the table back since we are done searching
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Quake *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }

}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuakeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  if (cell == nil) {
    cell = [[QuakeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
  
  Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [self configureCell:cell withQuake:quake];
    if (!quake.smallPhoto){
    [APICallerPlaceImage callNearbySearchWithQuake:(Quake*)quake];
    }

  
  if (!cell.quakeImageView.image) {
    cell.quakeImageView.image = [UIImage imageNamed:@"icon2"];
  }
  cell.quakeImageView.layer.cornerRadius = 8;
  cell.quakeImageView.layer.masksToBounds = YES;
  
  cell.magnitudeLabel.textColor = [UIColor blackColor];
//  cell.magnitudeLabel.layer.cornerRadius = 24;
//  cell.magnitudeLabel.layer.masksToBounds = YES;
  
  

  int magValue = [cell.magnitudeLabel.text intValue];
  
  if ( magValue >= 6) {
    cell.colorLabelMag.backgroundColor = [UIColor brownColor];
  } else if ( magValue >= 4) {
    cell.colorLabelMag.backgroundColor = [UIColor redColor];
  } else if ( magValue >= 2) {
    cell.colorLabelMag.backgroundColor = [UIColor yellowColor];
  } else {
    cell.colorLabelMag.backgroundColor = [UIColor greenColor];
  }
  
  return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}


- (void)configureCell:(QuakeCell *)cell withQuake:(Quake *)quake {
  
  
  NSDate *timeFormatted = [NSDate dateWithTimeIntervalSince1970:quake.time/1000];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  
    cell.magnitudeLabel.text = [NSString stringWithFormat:@"%.1f", quake.mag];
    cell.titleQuakeLabel.text = quake.title;
    cell.placeLabel.text = quake.place;
    cell.timeLabel.text = [formatter stringFromDate:timeFormatted];
    cell.quakeImageView.image = [UIImage imageWithData:(NSData*)quake.smallPhoto];
  
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<Quake *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Quake *> *fetchRequest = Quake.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Quake *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withQuake:anObject];
            break;
        
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withQuake:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - Fetch USGS Data; add to coredata as a Quake entity

-(void)fetchUSGSData{
    
NSURL *url = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"];
NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {NSLog(@"error: %@", error.localizedDescription);
        return ;
    }
    NSError *jsonError = nil;
    
    NSDictionary *quakes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if (jsonError) {
        NSLog(@"jsonError: %@", jsonError.localizedDescription);
        return ;
    }

    //    NSLog(@"quakes: %@", quakes);
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  
    // Process USGS JSON Data and add to coredata.
    for (NSDictionary *quakeitem in quakes[@"features"]) {
        

// Check if JSON quakeitem is already in core data. if yes, move on to next record.
            NSString *url = quakeitem[@"properties"][@"url"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.url == %@", url];
        NSLog(@"%@", url);
        NSLog(@"%@", predicate);
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Quake"];
            request.predicate = predicate;
            NSArray <Quake *>* fetchedQuakes = [self.context executeFetchRequest:request error:nil];
            if(fetchedQuakes.count){
                NSLog(@"Match Found: %@", [NSNumber numberWithLong: fetchedQuakes.count]);
            continue;
            }else{NSLog(@"Match Not Found: %lu", fetchedQuakes.count);}
        
        
// Unique records generate a new object with properties from JSON
        Quake *quake = [[Quake alloc] initWithContext:context];

        quake.place = quakeitem[@"properties"][@"place"];
        quake.time = [quakeitem[@"properties"][@"time"] doubleValue]; //USGS time data is in milliseconds
        quake.title = quakeitem[@"properties"][@"title"];
//        quake.mag = [quakeitem[@"properties"][@"mag"] floatValue];
        quake.updated = [quakeitem[@"properties"][@"updated"] doubleValue];
        quake.url = quakeitem[@"properties"][@"url"];
        
        NSString* temp = quakeitem[@"properties"][@"felt"];
            if (![temp isEqual:[NSNull null]]){
            quake.felt = [quakeitem[@"properties"][@"felt"] intValue];
            }
        quake.detail = quakeitem[@"properties"][@"detail"];
        NSArray <NSNumber*>*geometry = quakeitem[@"geometry"][@"coordinates"];
        quake.longitude = [geometry[0] doubleValue];
        quake.latitude = [geometry[1] doubleValue];
        quake.depth = [geometry[2] doubleValue];
        // Make url for Google Nearby Places API
        quake.nearbySearchURL = [APICallerPlaceImage makeNearbySearchURLfromQuake:quake];
        NSLog(@"nearbySearchURL: %@", quake.nearbySearchURL);
            }
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperationWithBlock:^{ [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//    [APICallerPlaceImage callNearbySearchWithQuake:(Quake*)quake];
//    }];
//    }];
    
    [self.appDelegate saveContext];
    [self.tableView reloadData];

    }];
    
[dataTask resume];
}

        








@end
