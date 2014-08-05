//
//  MapViewController.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "MapViewController.h"
#import "EventAnnotation.h"
#import "ExtensionUIViewControllerViewExtension.h"
///////////////////////////////////////////////////////
///
///          -MapViewController-
#pragma mark -MapViewController
///
///////////////////////////////////////////////////////
@implementation MapViewController
///////////////////////////////////////////////////////
///          Initializers
#pragma mark Initializers
///////////////////////////////////////////////////////
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _mapView = [[MapView alloc] initWithFrame:CGRectMake(.0f, .0f, self.width, self.height)];
    _mapView.delegate = self;
    [self addSubview:_mapView];
    [_mapView reloadData];
    
    UIButton *addNewButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0f, 20.0f, 80.0f, 36.0f)];
    [addNewButton setTitle:@"Add" forState:UIControlStateNormal];
    [addNewButton setBackgroundColor:[UIColor grayColor]];
    [addNewButton addTarget:self action:@selector(newEntryPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addNewButton];
    
    UIButton *userTrackingButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0f, addNewButton.bottom+10.0f, 80.0f, 36.0f)];
    [userTrackingButton setTitle:@"Tracking" forState:UIControlStateNormal];
    [userTrackingButton setBackgroundColor:[UIColor grayColor]];
    [userTrackingButton addTarget:self action:@selector(trackUserPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:userTrackingButton];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_refreshTimer invalidate]; //just in case
    _refreshTimer = nil;
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}
///////////////////////////////////////////////////////
///          Map protocol
#pragma mark Map protocol
///////////////////////////////////////////////////////
- (NSArray *)mapViewAnotations:(MapView *)sender {
    return [EventAnnotation calendarAnnotations];
}
///////////////////////////////////////////////////////
///          Handles
#pragma mark Handles
///////////////////////////////////////////////////////
- (void)reloadData {
    [_mapView reloadData];
}
///////////////////////////////////////////////////////
///          Add new event
#pragma mark Add new event
///////////////////////////////////////////////////////
- (void)newEntryPressed:(id)sender {
    _addNewPopupView = [[AddNewEventView alloc] initWithFrame:CGRectMake(self.width, .0f, self.width, self.height)];
    _addNewPopupView.delegate = self;
    _addNewPopupView.exclusiveTouch = YES;
    _addNewPopupView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.8f];
    [self addSubview:_addNewPopupView];
    
    [UIView animateWithDuration:.2 animations:^{
        _addNewPopupView.left = .0f;
    }];
}
- (void)addNewEventViewFinishedSettingEvent:(AddNewEventView *)sender {
    [UIView animateWithDuration:.2 animations:^{
        _addNewPopupView.left = self.width;
    }completion:^(BOOL finished) {
        [_addNewPopupView removeFromSuperview];
        _addNewPopupView = nil;
    }];
}
///////////////////////////////////////////////////////
///          Tracking
#pragma mark Tracking
///////////////////////////////////////////////////////
- (void)trackUserPressed:(id)sender {
    //toggle
    if(_trackingEnabled) {
        [[UserTracking sharedInstance] beginTracking];
        [UserTracking sharedInstance].delegate = self;
        _trackingEnabled = NO;
        if(_userAnotation == nil) {
            _userAnotation = [[EventAnnotation alloc] init];
            _userAnotation.color = [UIColor yellowColor];
            [_mapView.map addAnnotation:_userAnotation];
        }
    }
    else {
        [[UserTracking sharedInstance] endTracking];
        [UserTracking sharedInstance].delegate = nil;
        _trackingEnabled = YES;
        if(_userAnotation == nil) {
            [_mapView.map removeAnnotation:_userAnotation];
            _userAnotation = nil;
        }
    }
}
- (void)userTracking:(UserTracking *)sender updatedUserLocation:(CLLocationCoordinate2D)coordinate {
    _userAnotation.location = coordinate;
    [_mapView.map setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(.01, .01)) animated:YES];
    
}
@end
