//
//  Quake+CoreDataProperties.m
//  Earthquaker
//
//  Created by swcl on 2017-07-23.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "Quake+CoreDataProperties.h"

@implementation Quake (CoreDataProperties)

+ (NSFetchRequest<Quake *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Quake"];
}

@dynamic mag;
@dynamic place;
@dynamic time;
@dynamic updated;
@dynamic tz;
@dynamic url;
@dynamic detail;
@dynamic felt;
@dynamic cdi;
@dynamic mmi;
@dynamic alert;
@dynamic status;
@dynamic tsunami;
@dynamic sig;
@dynamic net;
@dynamic code;
@dynamic ids;
@dynamic sources;
@dynamic types;
@dynamic nst;
@dynamic dmin;
@dynamic rms;
@dynamic gap;
@dynamic magType;
@dynamic type;
@dynamic longitude;
@dynamic latitude;
@dynamic depth;
@dynamic id;
@dynamic title;

@end
