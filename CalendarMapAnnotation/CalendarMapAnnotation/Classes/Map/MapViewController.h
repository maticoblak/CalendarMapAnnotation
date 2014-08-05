//
//  MapViewController.h
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapView.h"
#import "AddNewEventView.h"
///////////////////////////////////////////////////////
///
///          -MapViewController-
#pragma mark -MapViewController
///
///////////////////////////////////////////////////////
@interface MapViewController : UIViewController<MapViewProtocol, AddNewEventViewProtocol> {
    MapView *_mapView;
    NSTimer *_refreshTimer;
    AddNewEventView *_addNewPopupView;
}
@end
