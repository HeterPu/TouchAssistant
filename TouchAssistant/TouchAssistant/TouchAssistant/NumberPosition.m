//
//  NumberPosition.m
//  TouchAssistant
//
//  Created by Peter on 8/31/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "NumberPosition.h"
@interface NumberPosition()
@property(nonatomic,assign)CGFloat width;

@end

@implementation NumberPosition


+(instancetype)shareNumInstance{
    NumberPosition *num = [[NumberPosition alloc]init];
    num.width = 300;
    return num;
}


-(CGPoint)getPositionFromType:(NumberStyle)style andNumber:(NSInteger)index {
    if (style == NumberStyle4) {
        switch (index) {
            case 1:
                return [self getIndex:1];
            case 2:
                return [self getIndex:3];
            case 3:
                return [self getIndex:5];
            case 4:
                return [self getIndex:7];
            default:
                break;
        }
        return CGPointZero;
    }
    else
    {
      return [self getIndex:(index - 1)];
    }
}



-(CGPoint)getIndex:(NSInteger)index {
    CGFloat cubeW = _width / 3;
    
    NSInteger row = index / 3;
    NSInteger col = index % 3;
    
    return CGPointMake(cubeW / 2 + col * cubeW, cubeW / 2 + row * cubeW);
    
}

@end
