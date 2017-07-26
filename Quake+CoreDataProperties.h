//
//  Quake+CoreDataProperties.h
//  Earthquaker
//
//  Created by swcl on 2017-07-26.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "Quake+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Quake (CoreDataProperties)

+ (NSFetchRequest<Quake *> *)fetchRequest;

@property (nonatomic) float depth;
@property (nullable, nonatomic, copy) NSString *detail;
@property (nonatomic) int16_t felt;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *ids;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double mag;
@property (nullable, nonatomic, copy) NSString *nearbySearchURL;
@property (nullable, nonatomic, copy) NSString *photoReference;
@property (nullable, nonatomic, copy) NSString *photoURL;
@property (nullable, nonatomic, copy) NSString *place;
@property (nonatomic) double time;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) double tz;
@property (nonatomic) double updated;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *lrgPhotoURL;
@property (nullable, nonatomic, retain) NSData *smallPhoto;
@property (nullable, nonatomic, retain) NSData *lrgPhoto;

@end

NS_ASSUME_NONNULL_END
