//
//  ViewController.m
//  bawl2
//
//  Created by Admin on 29.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "Constants.h"

#import "MapViewController.h"
#import "CurrentItems.h"
#import "NetworkDataSorce.h"
#import "UIColor+Bawl.h"
#import "MyAlert.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id<DataSorceProtocol> dataSorce;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (nonatomic) BOOL isUserLogined;

@end

@implementation MapViewController

#pragma mark - Lasy Instantiation

-(id<DataSorceProtocol>)dataSorce
{
    if (_dataSorce==nil)
    {
        _dataSorce = [[NetworkDataSorce alloc] init];
    }
    return _dataSorce;
}

#pragma mark - Load/appear view controller

-(void)viewDidLoad
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor bawlRedColor];
    //    UIFont *newFont = [UIFont fontWithName:@"ComicSansMS-Italic" size:25];
    //    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
    //                                                                    NSFontAttributeName : newFont};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBarButtons];
    [[NSNotificationCenter defaultCenter] addObserverForName:MyNotificationUserCheckedAndLogIned
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self updateBarButtons];
                                                  }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Loadin information about current user

-(void)updateBarButtons
{
    CurrentItems *ci = [CurrentItems sharedItems];
    if (ci.user != nil)
    {
        // so change bar button to sign out
        self.isUserLogined = YES;
        self.rightBarButton.title = @"Log Out";
        self.leftBarButton.enabled = YES;
    }
    else
    {
        self.isUserLogined = NO;
        self.leftBarButton.enabled = NO;

        // at first check info about request user
        if ([ci.activeRequests objectForKey:ActiveRequestCheckCurrentUser]!=nil)
        {
            // so we are logining user. wait for notification
            self.rightBarButton.title = @"wait...";
        }
        else
        {
            // no user, and no active request
            self.rightBarButton.title = @"Log In";
        }
    }
}


#pragma mark - Loading Map View

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    _mapView.mapType = MKMapTypeHybrid;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(50.619020, 26.252073);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [_mapView setRegion:region];
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(segueToNewIssue:)];
    [_mapView addGestureRecognizer:longTap];
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

-(void)segueToNewIssue:(UILongPressGestureRecognizer*)longTap
{
    CGPoint originPoint = [longTap locationInView:self.mapView];
    CLLocationCoordinate2D coordinatePoint = [self.mapView convertPoint:originPoint toCoordinateFromView:self.mapView];
    

}

#pragma mark - Map View Delegate

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

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:MySegueFromMapToDescription sender:view];
}



-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CurrentItems *ci = [CurrentItems sharedItems];
    ci.issue = view.annotation;
}


#pragma mark action
- (IBAction)sequeToLogInButton:(UIBarButtonItem *)sender {
    
    if (!self.isUserLogined)
    {
        [self performSegueWithIdentifier:MySegueFromMapToLogIn sender:self];
    }
    else
    {
        CurrentItems *ci = [CurrentItems sharedItems];
        __weak MapViewController *wSelf = self;
        sender.tintColor = [sender.tintColor colorWithAlphaComponent:0.3];
        sender.enabled = NO;
        
        [self.dataSorce requestSignOutWithHandler:^(NSString *stringAnswer, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if([stringAnswer isEqualToString:[@"Bye " stringByAppendingString:ci.user.name]])
                {
                    // alert - good
                    [MyAlert alertWithTitle:@"Log Out" andMessage:@"You loged out successfully!"];
                }
                else
                {
                    // alert - bad
                    [MyAlert alertWithTitle:@"Log Out" andMessage:[@"Something has gone wrong! (server answer: )" stringByAppendingString:stringAnswer]];
                }
                ci.user = nil;
                [wSelf updateBarButtons];
                sender.tintColor = [sender.tintColor colorWithAlphaComponent:1];
                sender.enabled = YES;
            });
        }];
    }
}




@end
