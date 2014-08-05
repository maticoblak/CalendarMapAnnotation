//
//  EventAnnotation.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "EventAnnotation.h"
#import "CalendarTools.h"
#import "ExtensionUIViewControllerViewExtension.h"
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
        
        annotation.additionalInfo = entity;
        
        [toReturn addObject:annotation];
    }
    
    return toReturn;
}
///////////////////////////////////////////////////////
///          Map protocol
#pragma mark Map protocol
///////////////////////////////////////////////////////
- (CLLocationCoordinate2D)coordinate {
    if(self.additionalInfo && [self.additionalInfo isKindOfClass:[CalendarEntity class]]) {
        CalendarEntity *entity = (CalendarEntity *)self.additionalInfo;
        return entity.coordinate;
    }
    return _location;
}
- (MKAnnotationView *)basicAnnotationView {
    static const CGFloat dimension = 12.0f;
    MKAnnotationView *toReturn = [[MKAnnotationView alloc] initWithFrame:CGRectMake(.0f, .0f, dimension, dimension)];
    toReturn.clipsToBounds = YES;
    toReturn.layer.cornerRadius = dimension*.5f;
    toReturn.backgroundColor = self.color?self.color:[UIColor redColor];
    return toReturn;
}
@end
