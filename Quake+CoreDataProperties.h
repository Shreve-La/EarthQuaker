//
//  Quake+CoreDataProperties.h
//  Earthquaker
//
//  Created by swcl on 2017-07-25.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "Quake+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Quake (CoreDataProperties)

+ (NSFetchRequest<Quake *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *alert;
@property (nonatomic) float cdi;
@property (nullable, nonatomic, copy) NSString *code;
@property (nonatomic) float depth;
@property (nullable, nonatomic, copy) NSString *detail;
@property (nonatomic) float dmin;
@property (nonatomic) int16_t felt;
@property (nullable, nonatomic, copy) NSDecimalNumber *gap;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *ids;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double mag;
@property (nullable, nonatomic, copy) NSString *magType;
@property (nonatomic) float mmi;
@property (nullable, nonatomic, copy) NSString *net;
@property (nonatomic) int16_t nst;
@property (nullable, nonatomic, copy) NSString *place;
@property (nonatomic) float rms;
@property (nonatomic) int16_t sig;
@property (nullable, nonatomic, copy) NSString *sources;
@property (nullable, nonatomic, copy) NSString *status;
@property (nonatomic) double time;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int16_t tsunami;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *types;
@property (nonatomic) int16_t tz;
@property (nonatomic) int64_t updated;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *nearbySearchURL;

@end

NS_ASSUME_NONNULL_END
