//
//  EarthQuakeDataSet.h
//  Earthquaker
//
//  Created by swcl on 2017-07-25.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarthQuakeDataSet : NSObject

@property (strong, nonatomic) NSDictionary *DataSet;
@property (strong, nonatomic) NSDate *downloaddate;
@property (strong, nonatomic) NSDate *firstDateInData;
@property (strong, nonatomic) NSDate *lastDateInData;


// -(void)addToCoreData;




@end

