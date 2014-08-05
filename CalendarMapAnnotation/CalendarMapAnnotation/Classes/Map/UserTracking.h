//
//  UserTracking.h
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class UserTracking;

@protocol UserTrackingProtocol <NSObject>
- (void)userTracking:(UserTracking *)sender updatedUserLocation:(CLLocationCoordinate2D)coordinate;
@end

///////////////////////////////////////////////////////
///
///          -UserTracking-
#pragma mark -UserTracking
///
///////////////////////////////////////////////////////
@interface UserTracking : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}
@property (weak) id<UserTrackingProtocol> delegate;
+ (UserTracking *)sharedInstance;

- (void)beginTracking;
- (void)endTracking;
@end
