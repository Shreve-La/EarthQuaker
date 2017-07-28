//
//  QuakeCell.h
//  Earthquaker
//
//  Created by Endeavour2 on 7/24/17.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Quake;

@interface QuakeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleQuakeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *quakeImageView;
@property (weak, nonatomic) IBOutlet UILabel *colorLabelMag;


@property (nonatomic, strong) Quake *quake;

@end
