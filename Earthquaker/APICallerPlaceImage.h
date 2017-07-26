//
//  APICallerPlaceImage.h
//  Earthquaker
//
//  Created by swcl on 2017-07-25.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Quake+CoreDataClass.h"
#import "AppDelegate.h"

@interface APICallerPlaceImage : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController<Quake *> *fetchedResultsController;

+(void)fetchSmallImagefromQuake:(Quake*)quake;

+(void)makeNearbySearchURLfromQuake:(Quake*)quake;

+(void)makePhotoURLfromQuake:(Quake*)quake;

+(void)callNearbySearchWithQuake:(Quake*)quake;




@end
