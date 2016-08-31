//
//  NumberPosition.h
//  TouchAssistant
//
//  Created by Peter on 8/31/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, NumberStyle) {
    NumberStyle4 = 0,          
    NumberStyle8,
};

@interface NumberPosition : NSObject

+(instancetype)shareNumInstance;

-(CGPoint)getPositionFromType:(NumberStyle)style andNumber:(NSInteger)index;

@end
