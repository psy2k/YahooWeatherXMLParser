//
//  ViewController.h
//  YahooWeatherXMLParser
//
//  Created by Nikos Maounis on 26/10/13.
//  Copyright (c) 2013 Nikos Maounis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) NSXMLParser *parser;

@end
