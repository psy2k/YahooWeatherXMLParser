//
//  YahooWeatherXMLParserTests.m
//  YahooWeatherXMLParserTests
//
//  Created by Nikos Maounis on 26/10/13.
//  Copyright (c) 2013 Nikos Maounis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface YahooWeatherXMLParserTests : XCTestCase

@property (nonatomic, strong) ViewController *vc;

@end

@implementation YahooWeatherXMLParserTests

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitNotNil
{
    XCTAssertNotNil(self.vc, @"Main ViewController object not instantiated");
}

@end
