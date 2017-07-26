//
//  QuakeCell.m
//  Earthquaker
//
//  Created by Endeavour2 on 7/24/17.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "QuakeCell.h"
#import "Quake+CoreDataClass.h"


@interface QuakeCell ()
//@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *titleQuakeLabel;


@end

@implementation QuakeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setQuakeCellWith:(Quake *)quake {
////  self.magnitudeLabel.text = quake.mag;
//  self.titleQuakeLabel.text = quake.title;
//  self.placeLabel.text = quake.place;
////  self.timeLabel.text = quake.time;
//   _quake = quake;
//}


@end
