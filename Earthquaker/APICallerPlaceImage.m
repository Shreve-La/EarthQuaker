//
//  APICallerPlaceImage.m
//  Earthquaker
//
//  Created by swcl on 2017-07-25.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "APICallerPlaceImage.h"

@implementation APICallerPlaceImage

static NSString *const GOOGLE_PLACES_KEY = @"";


#pragma mark - API Caller //Taken from fetchUSGSData

+(void)makeNearbySearchURLfromQuake:(Quake*)quake{
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=";
    NSString *lat = [NSString stringWithFormat:@"%f,", quake.latitude];
    NSString *longitute = [NSString stringWithFormat:@"%f", quake.longitude];
    NSString *radius = @"&radius=50000";
    NSString *key = [NSString stringWithFormat:@"&key=%@", GOOGLE_PLACES_KEY];
    NSString *newURL = [NSString stringWithFormat:@"%@%@%@%@%@", baseURL, lat, longitute, radius, key];
    quake.nearbySearchURL = newURL;
}

+(void)callNearbySearchWithQuake:(Quake*)quake {
  
}



+(void)fetchPlaceImagefromQuake:(Quake*)quake{
    //Sample Places API Call: https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU&key=YOUR_API_KEY

    /*
    Sample Google places [api call:]
    ?location=-33.8670522,151.1957362
    &radius=500
    &types=food
    &name=harbour
    &key=YOUR_API_KEY
    content_copy
     */

    
// Build URL for Photo Search
    NSString *returnedPhotoReference;
    NSNumber *imageWidth = [NSNumber numberWithInt:400];
    NSString *baseUrl = @"https://maps.googleapis.com/maps/api/place/photo?";
    NSString *maxWidth = [NSString stringWithFormat:@"maxwidth=%@", imageWidth];
    NSString *photoReference = [NSString stringWithFormat:@"&photoreference=%@", returnedPhotoReference];
    NSString *key = [NSString stringWithFormat:@"&key=%@", GOOGLE_PLACES_KEY ];
    NSURL *placesPhotoRequest =[NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@%@", baseUrl, maxWidth, photoReference, key]];

    
    
    
    
//    
//    
//    NSURL *url = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson"];
//    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"error: %@", error.localizedDescription);
//            return ;
//        }
//        NSError *jsonError = nil;
//        
//        NSDictionary *quakes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//        
//        if (jsonError) {
//            NSLog(@"jsonError: %@", jsonError.localizedDescription);
//            return ;
//        }
//        NSLog(@"quakes: %@", quakes);
//        
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        
//        for (NSDictionary *quakeitem in quakes[@"features"]) {
//            Quake *quake = [[Quake alloc] initWithContext:context];
//            
//            quake.place = quakeitem[@"properties"][@"place"];
//            quake.time = [quakeitem[@"properties"][@"time"] doubleValue]; //USGS time data is in milliseconds
//            quake.title = quakeitem[@"properties"][@"title"];
//            quake.mag = [quakeitem[@"properties"][@"mag"] floatValue];
//            quake.updated = [quakeitem[@"properties"][@"updated"] intValue];
//            quake.url = quakeitem[@"properties"][@"url"];
//            
//            
//            NSString* temp = quakeitem[@"properties"][@"felt"];
//            if (![temp isEqual:[NSNull null]]){
//                quake.felt = [quakeitem[@"properties"][@"felt"] intValue];
//            }
//            quake.detail = quakeitem[@"properties"][@"detail"];
//            
//            NSArray <NSNumber*>*geometry = quakeitem[@"geometry"][@"coordinates"];
//            NSLog(@"%@", geometry[0]);
//            quake.longitude = [geometry[0] doubleValue];
//            quake.latitude = [geometry[1] doubleValue];
//            quake.depth = [geometry[2] doubleValue];
//            
//            
//            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//            [queue addOperationWithBlock:^{
//                
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                }];
//            }];
//        }
//        
//        
//        [self.appDelegate saveContext];

}


@end
