//
//  MasterViewController.m
//  Earthquaker
//
//  Created by swcl on 2017-07-23.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "QuakeCell.h"

@interface MasterViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic)  NSMutableArray *dataEarthquakes;
@property (nonatomic)  NSMutableArray *searchResults;

@end

@implementation MasterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  self.context = self.appDelegate.persistentContainer.viewContext;
  [self fetchUSGSData];
  
  self.dataEarthquakes = [[NSMutableArray alloc]init];
  self.searchResults = [[NSMutableArray alloc]init];
  
  [self fetchDataFromCoreDataForSearchBarResult];
  [self setupSearchController];
  
  
    // Do any additional setup after loading the view, typically from a nib.
    
// TODO: Remove if not needed
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

// TODO: Remove if not needed
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
//    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)insertNewObject:(Quake*)quake {
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    Quake *newQuake = [[Quake alloc] initWithContext:context];
//        
//   
//        
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//}



#pragma mark - SearchBar and UISearchController

- (void)setupSearchController {
  // Setup the Search Controller
  // following delegates are included in the H file UISearchBarDelegate, UISearchControllerDelegate and UISearchResultsUpdating.
  
  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self; //updater delegate, in H file
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.delegate = self;
  
  NSArray *scopeTitles = @[@"All", @"A", @"B"]; //to be used for segmented controls
  scopeTitles =  self.searchController.searchBar.scopeButtonTitles;
  
  self.tableView.tableHeaderView = self.searchController.searchBar;
  self.definesPresentationContext = YES;
  [self.searchController.searchBar sizeToFit];
}

// to get data from coredata into the searchBar for initial character searching
- (void)fetchDataFromCoreDataForSearchBarResult {
  NSArray *tempArr  = [self.fetchedResultsController fetchedObjects];
  
  for (Quake *quake1 in tempArr) {
    NSString *quakeDesc = [quake1 valueForKey:@"place"];//to get data from the place attribute of the entity
    NSLog(@"quake desc %@", quakeDesc);
    
    NSMutableArray *tempArr2 = [@[]mutableCopy];
    if (![quakeDesc isEqual:nil]) {
      [tempArr2 addObject:quakeDesc];
      [self.dataEarthquakes arrayByAddingObjectsFromArray: tempArr2];
    }
  }
}

//implementing the required method for the delegate - searchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  NSString *searchString = searchController.searchBar.text;
  if (!searchString.length) {
    self.searchResults =self.dataEarthquakes;
  } else {
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF.%K contains[cd] %@",@"size", strippedString];
    self.searchResults = [self.dataEarthquakes filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];
    
  }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  [self updateSearchResultsForSearchController:self.searchController];
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


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [sectionInfo numberOfObjects];
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    QuakeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
////    cell.quake = quake;
//    [self configureCell:cell withQuake:quake];
//    return cell;
//}



//TODO: made minor update to include the searchBar results
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([tableView isEqual:self.searchController.searchResultsController]) {
    return self.searchResults.count;
  } else {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
  }
}

//TODO: made minor update to include the searchBar results
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuakeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  if (cell == nil) {
    cell = [[QuakeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
  
  if ([tableView isEqual:self.searchController.searchResultsController]) {
    cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
  } else {
    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withQuake:quake];
    
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
  
//    cell.textLabel.text = quake.title;
  
  NSDate *timeFormatted = [NSDate dateWithTimeIntervalSince1970:quake.time];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  
    cell.magnitudeLabel.text = [NSString stringWithFormat:@"%.1f", quake.mag];
    cell.titleQuakeLabel.text = quake.title;
    cell.placeLabel.text = quake.place;
  
  cell.timeLabel.text = [formatter stringFromDate:timeFormatted];
 ;
  NSLog(@"formatted time: %@", timeFormatted);
  
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Quake *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
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


#pragma mark - API Caller
-(void)fetchUSGSData{
NSURL *url = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"];
NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
        return ;
    }
    NSError *jsonError = nil;
    
    NSDictionary *quakes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if (jsonError) {
        NSLog(@"jsonError: %@", jsonError.localizedDescription);
        return ;
    }
    NSLog(@"quakes: %@", quakes);
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];

    for (NSDictionary *quakeitem in quakes[@"features"]) {
        Quake *quake = [[Quake alloc] initWithContext:context];
        
        quake.place = quakeitem[@"properties"][@"place"];
        quake.time = [quakeitem[@"properties"][@"time"] doubleValue]; //USGS time data is in milliseconds
        quake.title = quakeitem[@"properties"][@"title"];
        quake.mag = [quakeitem[@"properties"][@"mag"] floatValue];
        quake.updated = [quakeitem[@"properties"][@"updated"] intValue];
        quake.url = quakeitem[@"properties"][@"url"];
        
   
        NSString* temp = quakeitem[@"properties"][@"felt"];
        if (![temp isEqual:[NSNull null]]){
            quake.felt = [quakeitem[@"properties"][@"felt"] intValue];
            }
        quake.detail = quakeitem[@"properties"][@"detail"];
        
        NSArray <NSNumber*>*geometry = quakeitem[@"geometry"][@"coordinates"];
        NSLog(@"%@", geometry[0]);
        quake.longitude = [geometry[0] doubleValue];
        quake.latitude = [geometry[1] doubleValue];
        quake.depth = [geometry[2] doubleValue];
        
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            }];
        }];
    }
  
    
    [self.appDelegate saveContext];
    
    [self.tableView reloadData];
}];

[dataTask resume];

}




/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
