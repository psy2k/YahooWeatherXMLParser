//
//  ViewController.h
//  YahooWeatherXMLParser
//
//  Created by Nikos Maounis on 26/10/13.
//  Copyright (c) 2013 Nikos Maounis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate> {
    
    NSMutableString	*currentNodeContent;
    
}

@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) NSXMLParser *parser;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tempTypeSegment;

@property (strong, nonatomic) IBOutlet UIButton *getWoeidBtn;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) NSString *woeid;
@property (strong, nonatomic) NSString *cityName;
@end
