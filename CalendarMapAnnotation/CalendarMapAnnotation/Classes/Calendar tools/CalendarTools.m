//
//  CalendarTools.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "CalendarTools.h"
#import <EventKit/EventKit.h>

///////////////////////////////////////////////////////
///
///          -CalendarTools-
#pragma mark -CalendarTools
///
///////////////////////////////////////////////////////
@implementation CalendarTools
///////////////////////////////////////////////////////
///          Initialization
#pragma mark Initialization
///////////////////////////////////////////////////////
+ (NSArray *)fetchEvents {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(granted == NO) {
            [[[UIAlertView alloc] initWithTitle:@"This application requires access to calendar" message:@"Pleas enable access in settings!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else {
            
        }
    }];
    return [self _entityArrayWithEvents:[self _getEvents]];//can be empty
}
///////////////////////////////////////////////////////
///          Internal
#pragma mark Internal
///////////////////////////////////////////////////////
+ (NSArray *)_getEvents {
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    EKEventStore *store = [[EKEventStore alloc] init];
    // Create the start date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    return events;
}
+ (NSArray *)_entityArrayWithEvents:(NSArray *)events {
    NSMutableArray *toReturn = [[NSMutableArray alloc] init];
    for(EKEvent *event in events) {
        CalendarEntity *entity = [[CalendarEntity alloc] init];
        entity.dispayString = event.title;
        entity.coordinate = [self _addressForLocation:event.location];
        entity.eventDate = event.startDate;
        [toReturn addObject:entity];
    }
    return toReturn;
}
+ (CLLocationCoordinate2D)_addressForLocation:(NSString *)address {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}
@end
///////////////////////////////////////////////////////
///
///          -CalendarEntity-
#pragma mark -CalendarEntity
///
///////////////////////////////////////////////////////
@implementation CalendarEntity

@end