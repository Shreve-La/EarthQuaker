
//  DetailViewController.m
//  Earthquaker
//
//  Created by swcl on 2017-07-23.
//  Copyright © 2017 Shreve.ca. All rights reserved.
//

#import "DetailViewController.h"
@import MapKit;

@interface DetailViewController ()
@property (nonatomic) CLLocationCoordinate2D quakeLocation;
@property (weak, nonatomic) IBOutlet MKMapView *quakeLocationMap;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleQuakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabelMag;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
      self.titleQuakeLabel.text = self.detailItem.title;
      self.magnitudeLabel.text = [NSString stringWithFormat:@"%.1f", self.detailItem.mag];
      self.placeLabel.text = self.detailItem.place;
      
      NSDate *timeFormatted = [NSDate dateWithTimeIntervalSince1970:self.detailItem.time/1000];
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateStyle:NSDateFormatterMediumStyle];
      [formatter setTimeStyle:NSDateFormatterShortStyle];
      
      self.timeLabel.text = [formatter stringFromDate:timeFormatted];
      
      // set color code for magnitude label baed on the magnitude value
      int magValue = [self.magnitudeLabel.text intValue];
      
      if ( magValue >= 6) {
        self.colorLabelMag.backgroundColor = [UIColor brownColor];
      } else if ( magValue >= 4) {
        self.colorLabelMag.backgroundColor = [UIColor redColor];
      } else if ( magValue >= 2) {
        self.colorLabelMag.backgroundColor = [UIColor yellowColor];
      } else {
        self.colorLabelMag.backgroundColor = [UIColor greenColor];
      }
      
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
  [self quakeLocationData];
 // NSLog(@"%f did it work?", self.detailItem.latitude);
  
  
}

- (void)quakeLocationData {

    double longitude  = self.detailItem.longitude;
    double latitude = self.detailItem.latitude;
    self.quakeLocation = CLLocationCoordinate2DMake(latitude, longitude);
    self.quakeLocationMap.showsPointsOfInterest = YES;
    
    MKPointAnnotation *quakePoint = [[MKPointAnnotation alloc] init];
    quakePoint.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(4.0f, 4.0f);
    self.quakeLocationMap.region = MKCoordinateRegionMake(quakePoint.coordinate, span);
    [self.quakeLocationMap addAnnotation:quakePoint];
    
    
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %f", self.quakeLocation.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %f", self.quakeLocation.longitude];

    
//    [self setMapView];
  
}

//- (void)setMapView {
//  MKCoordinateSpan span = MKCoordinateSpanMake(0.5f, 0.5f);
//  self.quakeLocationMap.region = MKCoordinateRegionMake(self.quakeLocation, span);
////  [self.quakeLocationMap addAnnotation:self.detailItem];
//}


//- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id < MKAnnotation >)annotation
//{
//  static NSString *reuseId = @"StandardPin";
//
//  MKAnnotationView *aView = (MKAnnotationView *)[sender
//                                                 dequeueReusableAnnotationViewWithIdentifier:reuseId];
//
//  if (aView == nil)
//  {
//    aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
//    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    aView.canShowCallout = YES;
//  }
//  aView.image = [UIImage imageNamed : @"Location_OnMap"];
//  aView.annotation = annotation;
//  aView.calloutOffset = CGPointMake(0, -5);
//  aView.draggable = YES;
//  aView.enabled = YES;
//  return aView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(Quake *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
