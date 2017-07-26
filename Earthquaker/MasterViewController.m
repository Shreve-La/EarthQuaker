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

@interface MasterViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.context = self.appDelegate.persistentContainer.viewContext;
    [self fetchUSGSData];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withQuake:quake];
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


- (void)configureCell:(UITableViewCell *)cell withQuake:(Quake *)quake {
    cell.textLabel.text = quake.title;
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
NSURL *url = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson"];
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
        quake.longitude = [geometry[0] doubleValue];
        quake.latitude = [geometry[1] doubleValue];
        quake.depth = [geometry[2] doubleValue];
        
        [APICallerPlaceImage makeNearbySearchURLfromQuake:quake];
        NSLog(@"Nearby Search: %@", quake.nearbySearchURL);
        [APICallerPlaceImage callNearbySearchWithQuake:quake];
        NSLog(@"Photo Search: %@", quake.photoReference);
        
        [APICallerPlaceImage makePhotoURLfromQuake:quake];
        NSLog(@"Photo Search: %@", quake.photoURL);

        
        
        [APICallerPlaceImage fetchPlaceImagefromQuake:quake];


        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [queue addOperationWithBlock:^{ [[NSOperationQueue mainQueue] addOperationWithBlock:^{}];}];
    }
  
    [self.appDelegate saveContext];
    [self.tableView reloadData];
    
}];

[dataTask resume];

}


/*
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];}
*/

@end
