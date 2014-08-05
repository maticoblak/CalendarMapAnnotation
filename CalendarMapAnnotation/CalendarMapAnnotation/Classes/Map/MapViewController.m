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
@end
