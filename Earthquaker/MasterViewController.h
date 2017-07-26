//
//  MasterViewController.h
//  Earthquaker
//
//  Created by swcl on 2017-07-23.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Quake+CoreDataClass.h"
#import "AppDelegate.h"


@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, strong) AppDelegate *appDelegate;


@property (strong, nonatomic) NSFetchedResultsController<Quake *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) UISearchController *searchController;


@end

