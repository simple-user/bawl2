//
//  ViewController.m
//  bawl2
//
//  Created by Admin on 29.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "MapViewController.h"
#import "NetworkDataSorce.h"
#import "UIColor+Bawl.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id<DataSorceProtocol> dataSorce;

@end

@implementation MapViewController


-(id<DataSorceProtocol>)dataSorce
{
    if (_dataSorce==nil)
    {
        _dataSorce = [[NetworkDataSorce alloc] init];
    }
    return _dataSorce;
}

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    _mapView.mapType = MKMapTypeHybrid;
    [self updateAnnotations];
}



-(void)updateAnnotations
{
    __weak MapViewController * wSelf = self;
    [self.dataSorce requestAllIssues:^(NSArray<Issue *> *issues, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf.mapView removeAnnotations:self.mapView.annotations];
            [wSelf.mapView addAnnotations:issues];
        });
    }];
    
}

//- (MKAnnotationView *)mapView:(MKMapView *)sender
//            viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    MKAnnotationView *aView = [sender dequeueReusableAnnotationViewWithIdentifier:IDENT];
//    if (!aView) {
//        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                reuseIdentifier:IDENT];
//        // set canShowCallout to YES and build aView’s callout accessory views here
//    }
//    aView.annotation = annotation; // yes, this happens twice if no dequeue
//    // maybe load up accessory views here (if not too expensive)?
//    // or reset them and wait until mapView:didSelectAnnotationView:  to load actual data
//    return aView;
//}
//

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *annotationIdentifier = @"bawlAnnotation1";
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if(!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        aView.canShowCallout = YES;
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        rightButton.layer.borderColor = [[UIColor bawlRedColor05alpha ] CGColor];
        rightButton.layer.borderWidth = 1.0;
        rightButton.layer.cornerRadius = 6.0;
        [rightButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        aView.rightCalloutAccessoryView = rightButton;
    }
    aView.annotation = annotation;
    return aView;
}
		

@end
