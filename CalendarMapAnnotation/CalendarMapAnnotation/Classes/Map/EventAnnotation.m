//
//  EventAnnotation.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "EventAnnotation.h"
#import "CalendarTools.h"
///////////////////////////////////////////////////////
///
///          -EventAnnotation-
#pragma mark -EventAnnotation
///
///////////////////////////////////////////////////////
@implementation EventAnnotation
@synthesize location = _location;
///////////////////////////////////////////////////////
///          Initializers
#pragma mark Initializers
///////////////////////////////////////////////////////
- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        
    }
    return self;
}
+ (NSArray *)calendarAnnotations {
    NSMutableArray *toReturn = [[NSMutableArray alloc] init];
    
    for(CalendarEntity *entity in [CalendarTools fetchEvents]) {
        EventAnnotation *annotation = [[EventAnnotation alloc] init];
        annotation.location = annotation.location;
        
        NSMutableDictionary *additionalInfo = [[NSMutableDictionary alloc] init];
        additionalInfo[@"latitude"] = @(entity.coordinate.latitude);
        additionalInfo[@"longitude"] = @(entity.coordinate.longitude);
        additionalInfo[@"title"] = entity.dispayString;
        
        annotation.additionalInfo = additionalInfo;
        
        [toReturn addObject:annotation];
    }
    
    return toReturn;
}
///////////////////////////////////////////////////////
///          Map protocol
#pragma mark Map protocol
///////////////////////////////////////////////////////
- (CLLocationCoordinate2D)coordinate {
    return _location;
}
@end
