//
//  CalendarTools.h
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class CalendarTools;
@class CalendarEntity;

///////////////////////////////////////////////////////
///
///          -CalendarTools-
#pragma mark -CalendarTools
///
///////////////////////////////////////////////////////
@interface CalendarTools : NSObject
+ (NSArray *)fetchEvents;
@end
///////////////////////////////////////////////////////
///
///          -CalendarEntity-
#pragma mark -CalendarEntity
///
///////////////////////////////////////////////////////
@interface CalendarEntity : NSObject {
    
}
@property NSString *dispayString; //name
@property CLLocationCoordinate2D coordinate;
@property NSDate *eventDate;
@property NSString *eventIdentifier;

+ (CalendarEntity *)withEventIdentifier:(NSString *)identifier;

- (void)findCoordinatesForAddress:(NSString *)address;
@end