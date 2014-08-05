//
//  MapView.h
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "EventAnnotation.h"
@class MapView;

@protocol MapViewProtocol <NSObject>
- (NSArray *)mapViewAnotations:(MapView *)sender;
@optional
- (void)mapView:(MapView *)sender didChangeRegion:(MKCoordinateRegion)region;
@end
///////////////////////////////////////////////////////
///
///          -MapView-
#pragma mark -MapView
///
///////////////////////////////////////////////////////
@interface MapView : UIView<MKMapViewDelegate> {
    MKMapView *_mapView;
    NSArray *_annotationCache;
}
@property (weak) id<MapViewProtocol> delegate;
@property (readonly) MKMapView *map;
- (void)reloadData; //reloads new data
@end
