//
//  APICallerPlaceImage.m
//  Earthquaker
//
//  Created by swcl on 2017-07-25.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "APICallerPlaceImage.h"
//#import "APIKeys.h"

@implementation APICallerPlaceImage

static NSString *const GOOGLE_PLACES_KEY = @""; //add key to run

#pragma mark - Fetch google nearby places dictionary

+(void)makeNearbySearchURLfromQuake:(Quake*)quake{
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=";
    NSString *lat = [NSString stringWithFormat:@"%f,", quake.latitude];
    NSString *longitute = [NSString stringWithFormat:@"%f", quake.longitude];
    NSString *radius = @"&radius=50000";
    NSString *key = [NSString stringWithFormat:@"&key=%@", GOOGLE_PLACES_KEY];
    NSString *newURL = [NSString stringWithFormat:@"%@%@%@%@%@", baseURL, lat, longitute, radius, key];
    quake.nearbySearchURL = newURL;
}


#pragma mark - Fetch google photo id reference#

+(void)callNearbySearchWithQuake:(Quake*)quake {
    NSURL *url = [NSURL URLWithString:quake.nearbySearchURL];
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:urlRequest
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                   if (error) {NSLog(@"error: %@", error.localizedDescription);
                       return ;
                   }
                   NSError *jsonError = nil;
                   NSDictionary *nearbyPlaceData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                   if (jsonError) {
                       NSLog(@"jsonError: %@", jsonError.localizedDescription);
                       return ;
                   }
                   
                   //Retrieve photoReference from dictionary set to coredata object
                   quake.photoReference = nearbyPlaceData[@"results"][0][@"photos"][0][@"photo_reference"];
                   NSLog(@"photoReference: %@", quake.photoReference);
                   
                   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                   [queue addOperationWithBlock:^{
                       
                       //When complete Build Photo URL
                       [APICallerPlaceImage makePhotoURLfromQuake:quake];
                       NSLog(@"Photo Search: %@", quake.photoURL);
                       [APICallerPlaceImage fetchSmallImagefromQuake:quake];
                       
                     
                   }];
               }];
    
    [dataTask resume];
}


#pragma mark - Make URLs to retrieve small and large photo
//Sample Call to retrieve photo:
/*
        https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU&key=YOUR_API_KEY
 */
 
+(void)makePhotoURLfromQuake:(Quake*)quake{
    NSString *returnedPhotoReference = quake.photoReference;
    NSNumber *smlImageWidth = [NSNumber numberWithInt:40];
    NSNumber *lrgImageWidth = [NSNumber numberWithInt:400];
    NSString *baseUrl = @"https://maps.googleapis.com/maps/api/place/photo?";
    NSString *smlWidth = [NSString stringWithFormat:@"maxwidth=%@", smlImageWidth];
    NSString *lrgWidth = [NSString stringWithFormat:@"maxwidth=%@", lrgImageWidth];
    NSString *photoReference = [NSString stringWithFormat:@"&photoreference=%@", returnedPhotoReference];
    NSString *key = [NSString stringWithFormat:@"&key=%@", GOOGLE_PLACES_KEY ];
    NSString *smallPhotoRequestURL = [NSString stringWithFormat:@"%@%@%@%@", baseUrl, smlWidth, photoReference, key];
    NSString *LrgplacesPhotoRequestURL = [NSString stringWithFormat:@"%@%@%@%@", baseUrl, lrgWidth, photoReference, key];
    quake.photoURL = smallPhotoRequestURL;
    quake.lrgPhotoURL = LrgplacesPhotoRequestURL;
    NSLog(@"Generated URL for photo request: %@", LrgplacesPhotoRequestURL);
}


#pragma mark - Fetch small photo, from URL attribute on quake.
+(void)fetchSmallImagefromQuake:(Quake*)quake{
    NSString *urlForLocalPhoto = quake.photoURL;
    NSURL *url = [NSURL URLWithString:urlForLocalPhoto];
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error) {NSLog(@"error: %@", error.localizedDescription);
                                                        return ;
                                                    }
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                        quake.smallPhoto = data;
                                                        NSLog(@"%@", quake.smallPhoto);
                                                        AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                                        [del saveContext];
                                                    }];
                                                }];
    
    [dataTask resume];
}



@end
