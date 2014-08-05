//
//  MapView.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "MapView.h"
#import "ExtensionUIViewControllerViewExtension.h"
///////////////////////////////////////////////////////
///
///          -MapView-
#pragma mark -MapView
///
///////////////////////////////////////////////////////
@implementation MapView
@synthesize map = _mapView;
///////////////////////////////////////////////////////
///          Initializers
#pragma mark Initializers
///////////////////////////////////////////////////////
- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(.0f, .0f, self.width, self.height)];
        _mapView.delegate = self;
        [self addSubview:_mapView];
    }
    return self;
}
///////////////////////////////////////////////////////
///          Handles
#pragma mark Handles
///////////////////////////////////////////////////////
- (void)reloadData {
    [_mapView removeAnnotations:_annotationCache];
    _annotationCache = [self.delegate mapViewAnotations:self];
    [_mapView addAnnotations:_annotationCache];
}
@end
