//
//  UserTracking.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "UserTracking.h"

static UserTracking *__sharedInstance = nil;
///////////////////////////////////////////////////////
///
///          -UserTracking-
#pragma mark -UserTracking
///
///////////////////////////////////////////////////////
@implementation UserTracking
///////////////////////////////////////////////////////
///          Shared instance
#pragma mark Shared instance
///////////////////////////////////////////////////////
+ (UserTracking *)sharedInstance {
    if(__sharedInstance == nil) {
        __sharedInstance = [[UserTracking alloc] init];
    }
    return __sharedInstance;
}
///////////////////////////////////////////////////////
///          Initializers
#pragma mark Initializers
///////////////////////////////////////////////////////
- (instancetype)init {
    if((self = [super init])) {
        [self beginTracking];
    }
    return self;
}
///////////////////////////////////////////////////////
///          Internal
#pragma mark Internal
///////////////////////////////////////////////////////
- (void)beginTracking {
    if(_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [_locationManager startUpdatingLocation];
}
- (void)endTracking {
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.delegate userTracking:self updatedUserLocation:newLocation.coordinate];
}
@end
