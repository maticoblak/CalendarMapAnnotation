//
//  ViewController.m
//  CalendarMapAnnotation
//
//  Created by Matic Oblak on 8/5/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "ViewController.h"
#import "CalendarTools.h"
#import "MapViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CalendarTools fetchEvents];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self presentViewController:[[MapViewController alloc] init] animated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
