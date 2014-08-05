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
#import "UserTracking.h"
///////////////////////////////////////////////////////
///
///          -MapViewController-
#pragma mark -MapViewController
///
///////////////////////////////////////////////////////
@interface MapViewController : UIViewController<
MapViewProtocol,
AddNewEventViewProtocol,
UserTrackingProtocol> {
    MapView *_mapView;
    NSTimer *_refreshTimer;
    AddNewEventView *_addNewPopupView;
    BOOL _trackingEnabled;
    
    EventAnnotation *_userAnotation;
    
    NSDate *_selectedPresentationDate;
    
    UIButton *_overlay;
    UIDatePicker *_datePicker;
}
@end
