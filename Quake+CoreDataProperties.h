//
//  Quake+CoreDataProperties.h
//  Earthquaker
//
//  Created by swcl on 2017-07-23.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "Quake+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Quake (CoreDataProperties)

+ (NSFetchRequest<Quake *> *)fetchRequest;

@property (nonatomic) float mag;
@property (nullable, nonatomic, copy) NSString *place;
@property (nonatomic) int64_t time;
@property (nonatomic) int64_t updated;
@property (nonatomic) int16_t tz;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *detail;
@property (nonatomic) int16_t felt;
@property (nonatomic) float cdi;
@property (nonatomic) float mmi;
@property (nullable, nonatomic, copy) NSString *alert;
@property (nullable, nonatomic, copy) NSString *status;
@property (nonatomic) int16_t tsunami;
@property (nonatomic) int16_t sig;
@property (nullable, nonatomic, copy) NSString *net;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *ids;
@property (nullable, nonatomic, copy) NSString *sources;
@property (nullable, nonatomic, copy) NSString *types;
@property (nonatomic) int16_t nst;
@property (nonatomic) float dmin;
@property (nonatomic) float rms;
@property (nullable, nonatomic, copy) NSDecimalNumber *gap;
@property (nullable, nonatomic, copy) NSString *magType;
@property (nullable, nonatomic, copy) NSString *type;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic) float depth;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
