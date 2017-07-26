//
//  EarthQuakeDataSet.m
//  Earthquaker
//
//  Created by swcl on 2017-07-25.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "EarthQuakeDataSet.h"

@implementation EarthQuakeDataSet


- (instancetype)initWithDownLoad:(NSDictionary*)downloadedData;
{
    self = [super init];
    if (self) {
        _DataSet = [[NSDictionary alloc] initWithDictionary:downloadedData];
    }
    return self;
}




@end
