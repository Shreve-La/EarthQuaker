//
//  USGSData.h
//  Earthquaker
//
//  Created by swcl on 2017-08-02.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface USGSData : NSObject

+(void)fetchUSGSDataWithContext:(NSManagedObjectContext*)context;



@end
