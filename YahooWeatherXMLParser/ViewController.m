//
//  ViewController.m
//  YahooWeatherXMLParser
//
//  Created by Nikos Maounis on 26/10/13.
//  Copyright (c) 2013 Nikos Maounis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize temperatureLabel, parser, tempTypeSegment;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Temperature finder";
    [self parseWeather];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changedTempMetrics:(id)sender {
    [self parseWeather];
}

- (void) parseWeather {
    dispatch_queue_t weatherqueue = dispatch_queue_create("yahooweather", NULL);
    dispatch_async(weatherqueue, ^(void) {
        NSString *location = @"946738";
        NSString *temperatureUnit;
        if (self.tempTypeSegment.selectedSegmentIndex == 0){
        temperatureUnit = @"c";
        } else {
            temperatureUnit = @"f";
        }
        NSString *address = @"http://weather.yahooapis.com/forecastrss?w=";
        NSString *request = [NSString stringWithFormat:@"%@%@&u=%@",address, location, temperatureUnit];
        NSURL *URL = [NSURL URLWithString:request];
        
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
        self.parser.delegate = self;
        [self.parser parse];

    });

}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"yweather:condition"])
    {
        // UI updates should be dispatched to the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *temp = attributeDict[@"temp"];
            self.temperatureLabel.text = temp;
        });
    }
}


@end
