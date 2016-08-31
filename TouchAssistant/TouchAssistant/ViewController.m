//
//  ViewController.m
//  TouchAssistant
//
//  Created by Peter on 8/31/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ViewController.h"
#import "NumberPosition.h"
#import "TouchAssistantView.h"
#define  screenS [UIScreen mainScreen].bounds.size
#define  viewWidth 300

@interface ViewController ()

@property (nonatomic,assign)NSInteger cengCount;
@property (nonatomic,assign)NSInteger selectedPosition;
@property (nonatomic,strong)NSArray *bigarray;

@property (nonatomic,strong)TouchAssistantView *ta;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cengCount = NO;
    [self setBigArray];
    
    
    
    TouchAssistantView *ta = [TouchAssistantView TAWithBigArrary:_bigarray andInitialPosition:CGPointMake(100, 100)];
    ta.backgroundColor = [UIColor lightGrayColor];
    _ta = ta;
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)show:(id)sender {
    [_ta showTA];
}


- (IBAction)hide:(id)sender {
    [_ta hideTA];
}


-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)setBigArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ConfigureFile.plist" ofType:nil];
    NSArray *arra = [NSArray arrayWithContentsOfFile:path];
    _bigarray = arra;
}



@end
