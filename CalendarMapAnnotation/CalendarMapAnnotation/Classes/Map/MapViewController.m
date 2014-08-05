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
#import "CalendarTools.h"
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
    
    UIButton *datePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0f, userTrackingButton.bottom+10.0f, 80.0f, 36.0f)];
    [datePickerButton setTitle:@"Date" forState:UIControlStateNormal];
    [datePickerButton setBackgroundColor:[UIColor grayColor]];
    [datePickerButton addTarget:self action:@selector(dateSelectionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:datePickerButton];
    
    UIButton *regionSelectionButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0f, datePickerButton.bottom+10.0f, 80.0f, 36.0f)];
    regionSelectionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    regionSelectionButton.titleLabel.numberOfLines = 0;
    [regionSelectionButton setTitle:@"Select region" forState:UIControlStateNormal];
    [regionSelectionButton setTitle:@"End selection" forState:UIControlStateSelected];
    [regionSelectionButton setBackgroundColor:[UIColor grayColor]];
    [regionSelectionButton addTarget:self action:@selector(regionSelectionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:regionSelectionButton];
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
    NSDate *startDate = _selectedPresentationDate;
    if(startDate == nil) startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[startDate timeIntervalSince1970] + (7.0*24.0*60.0*60.0)]; // + 7 days
    
    NSArray *items = [EventAnnotation calendarAnnotationsFrom:startDate to:endDate];
    for (EventAnnotation *annotation in items) {
        if(annotation.additionalInfo && [annotation.additionalInfo isKindOfClass:[CalendarEntity class]]) {
            CalendarEntity *entity = (CalendarEntity *)annotation.additionalInfo;
            annotation.color = [self _colorForDate:entity.eventDate];
        }
    }
    return items;
}
///////////////////////////////////////////////////////
///          Internal
#pragma mark Internal
///////////////////////////////////////////////////////
- (UIColor *)_colorForDate:(NSDate *)date {
    NSDate *startDate = _selectedPresentationDate;
    if(startDate == nil) startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[startDate timeIntervalSince1970] + (7.0*24.0*60.0*60.0)]; // + 7 days
    
    CGFloat interpolator = [date timeIntervalSinceDate:startDate]/[endDate timeIntervalSinceDate:startDate];
    if(interpolator < .0f) interpolator = .0f;
    if(interpolator > 1.0f) interpolator = 1.0f;
    
    return [UIColor colorWithRed:1.0f-interpolator green:.0f blue:interpolator alpha:1.0f];
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
///////////////////////////////////////////////////////
///          Date selection
#pragma mark Date selection
///////////////////////////////////////////////////////
- (void)dateSelectionPressed:(id)sender {
    _overlay = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, self.width, self.height)];
    _overlay.backgroundColor = [UIColor colorWithWhite:.2f alpha:.4f];
    _overlay.alpha = .0f;
    [_overlay addTarget:self action:@selector(hideDateOverlay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_overlay];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(.0f, self.height, self.width, self.width)];
    [_datePicker setDate:_selectedPresentationDate?_selectedPresentationDate:[NSDate date]];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_overlay addSubview:_datePicker];
    
    [UIView animateWithDuration:.2 animations:^{
        _overlay.alpha = 1.0f;
        _datePicker.bottom = self.height;
    }];
}
- (void)hideDateOverlay:(id)sender {
    [UIView animateWithDuration:.2 animations:^{
        _overlay.alpha = .0f;
        _datePicker.top = self.height;
    } completion:^(BOOL finished) {
        [_overlay removeFromSuperview];
        _overlay = nil;
        [_datePicker removeFromSuperview];
        _datePicker = nil;
    }];
}
- (void)dateChanged:(UIDatePicker *)picker {
    _selectedPresentationDate = picker.date;
}
///////////////////////////////////////////////////////
///          Region selection
#pragma mark Region selection
///////////////////////////////////////////////////////
- (void)regionSelectionPressed:(UIButton *)sender {
    //toggle
    sender.selected = !sender.selected;
    
    if(sender.selected) {
        [_mapView beginRegionSelectionMode];
    }
    else {
        [_mapView endRegionSelectionMode];
    }
}
@end
