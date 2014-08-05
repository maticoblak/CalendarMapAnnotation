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
///////////////////////////////////////////////////////
///          Map protocol
#pragma mark Map protocol
///////////////////////////////////////////////////////
- (NSArray *)mapViewAnotations:(MapView *)sender {
    return [EventAnnotation calendarAnnotations];
}
@end
