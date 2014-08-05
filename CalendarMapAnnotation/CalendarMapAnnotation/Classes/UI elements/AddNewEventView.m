//
//  AddNewEventView.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "AddNewEventView.h"
#import "ExtensionUIViewControllerViewExtension.h"
#import "CalendarTools.h"
///////////////////////////////////////////////////////
///
///          -AddNewEventView-
#pragma mark -AddNewEventView
///
///////////////////////////////////////////////////////
@implementation AddNewEventView
///////////////////////////////////////////////////////
///          Initializer
#pragma mark Initializer
///////////////////////////////////////////////////////
- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        _eventDate = [NSDate date];
        
        CGFloat position = 40.0f;
        
        _titleField = [[UITextField alloc] initWithFrame:CGRectMake(11.0f, position+22.0f, self.width-22.0f, 36.0f)];
        _titleField.layer.cornerRadius = 11.0f;
        _titleField.placeholder = @"Event title";
        _titleField.backgroundColor = [UIColor colorWithWhite:153.0f/255.0F alpha:1.0f];
        [self addSubview:_titleField];
        
        _addressField = [[UITextField alloc] initWithFrame:CGRectMake(11.0f, _titleField.bottom+14.0f, self.width-22.0f, 36.0f)];
        _addressField.layer.cornerRadius = 11.0f;
        _addressField.placeholder = @"Address";
        _addressField.backgroundColor = [UIColor colorWithWhite:153.0f/255.0F alpha:1.0f];
        [self addSubview:_addressField];
        
        _dateButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0f, _addressField.bottom+14.0f, self.width-22.0f, 36.0f)];
        _dateButton.layer.cornerRadius = 11.0f;
        _dateButton.backgroundColor = [UIColor colorWithWhite:153.0f/255.0F alpha:1.0f];
        [_dateButton addTarget:self action:@selector(changeDatePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dateButton];
        
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(22.0f, _dateButton.bottom+30.0f, self.width-44.0f,42.0f)];
        doneButton.layer.cornerRadius = 11.0f;
        doneButton.backgroundColor = [UIColor colorWithWhite:153.0f/255.0F alpha:1.0f];
        [doneButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [self addSubview:doneButton];
        
        [self refresh];
    }
    return self;
}
///////////////////////////////////////////////////////
///          Handles
#pragma mark Handles
///////////////////////////////////////////////////////
- (void)refresh {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM. dd. yyyy hh:mma"];
    [_dateButton setTitle:[NSString stringWithFormat:@"Begins at: %@", [dateFormatter stringFromDate:_eventDate]] forState:UIControlStateNormal];
}
- (void)changeDatePressed:(id)sender {
    _overlay = [[UIButton alloc] initWithFrame:CGRectMake(.0f, self.height, self.width, self.height)];
    _overlay.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.8f];
    [_overlay addTarget:self action:@selector(overlayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_overlay];
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(.0f, 60.0f, self.width, self.height-60.0f)];
    [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [picker setDate:_eventDate];
    [_overlay addSubview:picker];
    
    [UIView animateWithDuration:.2 animations:^{
        _overlay.top = .0f;
    }];
}
- (void)dateChanged:(UIDatePicker *)sender {
    _eventDate = sender.date;
    [self refresh];
}
- (void)donePressed:(id)sender {
    [CalendarTools insertNewEvent:_titleField.text withLocation:_addressField.text atDate:_eventDate];
    
    [self.delegate addNewEventViewFinishedSettingEvent:self];
}
- (void)overlayPressed:(id)sender {
    [UIView animateWithDuration:.2 animations:^{
        _overlay.top = self.height;
    } completion:^(BOOL finished) {
        [_overlay removeFromSuperview];
        _overlay = nil;
    }];
}
@end
