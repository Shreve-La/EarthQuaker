//
//  USGSData.m
//  Earthquaker
//
//  Created by swcl on 2017-08-02.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "USGSData.h"
#import "Quake+CoreDataClass.h"
#import "AppDelegate.h"
#import "APICallerPlaceImage.h"


@implementation USGSData



+(void)fetchUSGSDataWithContext:(NSManagedObjectContext*)context{
    // These are the 3 main summary feeds for USGS (documentation: https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php )
    NSURL *allMonth = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"];
    NSURL *allWeek = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson"];
    NSURL *allDay = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"];
    
    //Request Data
    NSURL *url = allDay;
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {NSLog(@"error: %@", error.localizedDescription);
            return ;
        }
        
        NSError *jsonError = nil;
        
        //Recieve JSON Data
        NSDictionary *quakes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return ;
        }
        
        // Process Data in JSON Payload
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *quakeitem in quakes[@"features"]) {
                
                // Check if object already exists
                NSString *url = quakeitem[@"properties"][@"url"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.url == %@", url];
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Quake"];
                request.predicate = predicate;
                
                NSUInteger count = [context countForFetchRequest: request error: nil];
                NSLog(@"Number of matching items : %lu", count);
                if (count>0) {
                    // Quake record is already in CoreData, will proceed to next record
                    continue;}
                else {
                    NSLog(@"Number of matching items found: %lu", count);
                    // Quake record is not in CoreData, will proceed to make new object and set properties
                }
                
                // Unique records generate a new object with properties from JSON
                Quake *quake = [[Quake alloc] initWithContext:context];
                
                quake.place = quakeitem[@"properties"][@"place"];
                quake.time = [quakeitem[@"properties"][@"time"] doubleValue]; //USGS time data is in milliseconds
                quake.title = quakeitem[@"properties"][@"title"];
                quake.updated = [quakeitem[@"properties"][@"updated"] doubleValue];
                quake.url = quakeitem[@"properties"][@"url"];
                quake.detail = quakeitem[@"properties"][@"detail"];
                
                NSString* tempMag  = quakeitem[@"properties"][@"mag"];
                if (![tempMag isEqual:[NSNull null]]){
                    quake.mag = [quakeitem[@"properties"][@"mag"] doubleValue];
                }else{
                    quake.mag = 0;
                }
                
                NSString* temp = quakeitem[@"properties"][@"felt"];
                if (![temp isEqual:[NSNull null]]){
                    quake.felt = [quakeitem[@"properties"][@"felt"] intValue];
                }
                
                NSString* tempGeo = quakeitem[@"geometry"][@"coordinates"];
                if (![tempGeo isEqual:[NSNull null]]){
                    NSArray <NSNumber*>*geometry = quakeitem[@"geometry"][@"coordinates"];
                    quake.longitude = [geometry[0] doubleValue];
                    quake.latitude = [geometry[1] doubleValue];
                    quake.depth = [geometry[2] doubleValue];
                }
                
                // Make url for Google Nearby Places API
                quake.nearbySearchURL = [APICallerPlaceImage makeNearbySearchURLfromQuake:quake];
                NSLog(@"nearbySearchURL: %@", quake.nearbySearchURL);
                
            }
        });
        
        
        
    }];
    
    [dataTask resume];
}









@end
