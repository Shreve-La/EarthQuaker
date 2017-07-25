//
//  DetailViewController.h
//  Earthquaker
//
//  Created by swcl on 2017-07-23.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import "Earthquaker+CoreDataModel.h"
#import "Quake+CoreDataClass.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Quake *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

