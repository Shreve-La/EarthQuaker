//
//  Quake+CoreDataProperties.m
//  Earthquaker
//
//  Created by swcl on 2017-07-26.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "Quake+CoreDataProperties.h"

@implementation Quake (CoreDataProperties)

+ (NSFetchRequest<Quake *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Quake"];
}

@dynamic depth;
@dynamic detail;
@dynamic felt;
@dynamic id;
@dynamic ids;
@dynamic latitude;
@dynamic longitude;
@dynamic mag;
@dynamic nearbySearchURL;
@dynamic photoReference;
@dynamic photoURL;
@dynamic place;
@dynamic time;
@dynamic title;
@dynamic tz;
@dynamic updated;
@dynamic url;
@dynamic lrgPhotoURL;
@dynamic smallPhoto;
@dynamic lrgPhoto;

@end
