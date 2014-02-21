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

@synthesize temperatureLabel, parser, tempTypeSegment, cityTextField, getWoeidBtn, woeid, cityName;

BOOL parseChars;
BOOL shouldParseWeather = YES;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Temperature finder";
    UITapGestureRecognizer *tapToDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [tapToDismissKeyboard setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapToDismissKeyboard];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)tapped{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changedTempMetrics:(id)sender {
    [self parseWeather];
}

#pragma mark - Weather info parsing
- (void) parseWeather {
    if (woeid){
    dispatch_queue_t weatherqueue = dispatch_queue_create("yahooweather", NULL);
    dispatch_async(weatherqueue, ^(void) {
//        NSString *location = @"946738";
        NSString *temperatureUnit;
        if (self.tempTypeSegment.selectedSegmentIndex == 0){
        temperatureUnit = @"c";
        } else {
            temperatureUnit = @"f";
        }
        NSString *address = @"http://weather.yahooapis.com/forecastrss?w=";
        NSString *request = [NSString stringWithFormat:@"%@%@&u=%@",address, woeid, temperatureUnit];
        NSURL *URL = [NSURL URLWithString:request];
        
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
        self.parser.delegate = self;
        [self.parser parse];

    });
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"City missing" message:@"Type a city in order to get temperature" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK",nil, nil];
        [alert show];
    }
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"yweather:condition"])
    {
        // UI updates should be dispatched to the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *temp = attributeDict[@"temp"];
            if (self.tempTypeSegment.selectedSegmentIndex == 0){
                double delayInSeconds = 0.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView animateWithDuration:0.6f animations:^(void) {
                        self.temperatureLabel.alpha = .5;
                        self.temperatureLabel.transform = CGAffineTransformMakeScale(2.5, 2.5);
                        self.temperatureLabel.text = [temp stringByAppendingString:@" °C"];
                        self.temperatureLabel.layer.shadowOpacity = .6f;
                        self.temperatureLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                        self.temperatureLabel.layer.shadowRadius = 1;
                        self.temperatureLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                        self.temperatureLabel.layer.shouldRasterize = YES;
                        self.temperatureLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        self.temperatureLabel.alpha = 1;
                    }];
                });
                
            } else {
                double delayInSeconds = 0.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView animateWithDuration:0.5f animations:^(void) {
                        self.temperatureLabel.alpha = .5;
                        self.temperatureLabel.transform = CGAffineTransformMakeScale(2.5, 2.5);
                        self.temperatureLabel.text = [temp stringByAppendingString:@" °F"];
                        self.temperatureLabel.layer.shadowOpacity = .6f;
                        self.temperatureLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                        self.temperatureLabel.layer.shadowRadius = 1;
                        self.temperatureLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                        self.temperatureLabel.layer.shouldRasterize = YES;
                        self.temperatureLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        self.temperatureLabel.alpha = 1;
                    }];
                });
            }
        });
    }
    if ([elementName isEqual:@"woeid"])
    {
        parseChars = YES;
        NSLog(@"Woeid: %@", woeid);
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (parseChars) {
        woeid = string;
        parseChars = NO;
    }
}

- (IBAction)getWoeid:(id)sender {
        if ([self.cityTextField.text length] > 0 || [self.cityTextField.text isEqualToString:@""] == FALSE){
         [self.view endEditing:YES];
         shouldParseWeather = YES;
         cityName = self.cityTextField.text;
         [self parseWoeid];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"City missing" message:@"Type a city in order to get temperature" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK",nil, nil];
            [alert show];
        }
}

- (void) parseWoeid {
    dispatch_queue_t woeidqueue = dispatch_queue_create("woeidqueue", NULL);
    dispatch_async(woeidqueue, ^(void) {
        NSString *request = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=select * from geo.places where text=\"%@\"&format=xml", cityName];
        NSString *encRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:encRequest];
        
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
        self.parser.delegate = self;
        [self.parser parse];
        
    });
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (shouldParseWeather) {
      [self parseWeather];
      shouldParseWeather = NO;
    }
}

@end
