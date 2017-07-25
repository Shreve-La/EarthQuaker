//
//  Quake+CoreDataProperties.m
//  Earthquaker
//
//  Created by swcl on 2017-07-25.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "Quake+CoreDataProperties.h"

@implementation Quake (CoreDataProperties)

+ (NSFetchRequest<Quake *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Quake"];
}

@dynamic alert;
@dynamic cdi;
@dynamic code;
@dynamic depth;
@dynamic detail;
@dynamic dmin;
@dynamic felt;
@dynamic gap;
@dynamic id;
@dynamic ids;
@dynamic latitude;
@dynamic longitude;
@dynamic mag;
@dynamic magType;
@dynamic mmi;
@dynamic net;
@dynamic nst;
@dynamic place;
@dynamic rms;
@dynamic sig;
@dynamic sources;
@dynamic status;
@dynamic time;
@dynamic title;
@dynamic tsunami;
@dynamic type;
@dynamic types;
@dynamic tz;
@dynamic updated;
@dynamic url;
@dynamic nearbySearchURL;

@end
