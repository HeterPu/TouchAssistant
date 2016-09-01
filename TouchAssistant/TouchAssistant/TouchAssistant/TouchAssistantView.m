//
//  TouchAssistantView.m
//  TouchAssistant
//
//  Created by Peter on 8/31/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "TouchAssistantView.h"
#import "NumberPosition.h"

#define  screenS [UIScreen mainScreen].bounds.size
#define kTAWidth  50
#define KViewWidth 300

@interface TouchAssistantView()
@property (nonatomic,assign)NSInteger cengCount;
@property (nonatomic,assign)NSInteger selectedPosition;
@property (nonatomic,strong)NSArray *bigarray;
@property (nonatomic,assign)CGPoint lastPoint;
@property (nonatomic,assign)NSInteger firstIndex;
@property (nonatomic,assign)NumberStyle  firstMenuMode;
@end
@implementation TouchAssistantView

static TouchAssistantView* _instance = nil;

+(instancetype)TAWithBigArrary:(NSArray *)arra
            andInitialPosition:(CGPoint)point {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[TouchAssistantView alloc]initWithFrame:CGRectMake(point.x, point.y, kTAWidth, kTAWidth)];
        _instance.bigarray = arra;
        _instance.lastPoint = CGPointMake(point.x, point.y);
    }) ;
    
    return _instance ;
}


-(void)setBigarray:(NSArray *)bigarray {
    _bigarray = bigarray;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnify:)];
    tap.numberOfTapsRequired = 1;
    self.layer.cornerRadius = 10;
    [self addGestureRecognizer:tap];
}

-(void)magnify:(UIGestureRecognizer *)gesture {
    if (!_cengCount) {
        
        [UIView animateWithDuration:1 animations:^{
            self.frame = CGRectMake((screenS.width - KViewWidth) / 2, (screenS.height - KViewWidth) / 2, KViewWidth, KViewWidth);
            self.layer.cornerRadius = 10;
        } completion:^(BOOL finished) {
            NSLog(@"the center si %f %f",self.center.x,self.center.y);
            [self setImageFrom:_bigarray];
        }];
        _cengCount = 1;
    }
    else if(_cengCount == 1)
    {
        [self removeSubView];
        [UIView animateWithDuration:1 animations:^{
            self.frame = CGRectMake(_lastPoint.x, _lastPoint.y, kTAWidth, kTAWidth);
        } completion:^(BOOL finished) {
            
        }];
        _cengCount = 0;
    }
    else
    {
        [self backBTNclick:_selectedPosition];
        _cengCount--;
    }
}


-(void)setImageFrom:(NSArray *)arra{
    
    NSNumber *style = arra[0];
    NumberStyle style1 = (style.integerValue == 4) ? NumberStyle4:NumberStyle8;
    _firstMenuMode = style1;
    for (int i = 1; i < arra.count; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.bounds = CGRectMake(0, 0, KViewWidth / 3, KViewWidth /3);
        NSNumber *num = [arra[i] valueForKey:@"position"];
        btn.tag = i;
        CGPoint point = [[NumberPosition shareNumInstance] getPositionFromType:style1 andNumber:num.integerValue];
        btn.center = point;
        btn.alpha = 0;
        [btn setImage:[UIImage imageNamed:[arra[i] valueForKey:@"pic"]] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:1 animations:^{
            btn.alpha = 1;
        }];
    }
}


-(void) setPicFromIndex:(NSInteger)index andarray:(NSArray *)arra {
    NSNumber *style = arra[0];
    NumberStyle style1 = (style.integerValue == 4) ? NumberStyle4:NumberStyle8;
    
    CGPoint lastCenter =[[NumberPosition shareNumInstance] getPositionFromType:_firstMenuMode andNumber:index];
    
    for (int i = 1; i < arra.count; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.bounds = CGRectMake(0, 0, KViewWidth / 3, KViewWidth /3);
        NSNumber *num = [arra[i] valueForKey:@"position"];
        btn.tag = i;
        btn.center = lastCenter;
        CGPoint point = [[NumberPosition shareNumInstance] getPositionFromType:style1 andNumber:num.integerValue];
        btn.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            btn.center = point;
            btn.alpha = 1;
        }];
        
        [btn setImage:[UIImage imageNamed:[arra[i] valueForKey:@"pic"]] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(functionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIImageView *left_arrow = [[UIImageView alloc]init];
    left_arrow.image = [UIImage imageNamed:@"arrowleft"];

    left_arrow.bounds = CGRectMake(0, 0, KViewWidth / 5, KViewWidth / 5);
    left_arrow.center = lastCenter;
    
    CGPoint arrowP = [[NumberPosition shareNumInstance] getPositionFromType:NumberStyle8 andNumber:5];
    [UIView animateWithDuration:1 animations:^{
        left_arrow.center = arrowP;
    }];
    [self addSubview:left_arrow];
}


-(void)removeSubView{
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}


-(void)btnClick:(UIButton *)button {
    _cengCount++;
    NSInteger index = button.tag;
    _firstIndex = index;
    NSNumber *indexposition = [_bigarray[index] valueForKey:@"position"];
    NSString *string = [_bigarray[index] valueForKey:@"block"];
    if ([string isEqualToString:@"YES"]) {
        NSLog(@"block index %li",index);
        if ([self.delegate respondsToSelector:@selector(FirstMenuClickIndex:)]) {
            [self.delegate FirstMenuClickIndex:index];
        }
    }
    else
    {
    _selectedPosition = indexposition.integerValue;
    [self removeSubView];
    [self setPicFromIndex:(NSInteger) indexposition.integerValue andarray:[_bigarray[index] valueForKey:@"subarra"]];
    }
}


-(void)functionClick:(UIButton *)button {
    
    NSLog(@"first click %li  second Click %li",_firstIndex,button.tag);
    NSNumber *index1 = [NSNumber numberWithInteger:_firstIndex];
    NSNumber *index2 = [NSNumber numberWithInteger:button.tag];
    NSDictionary *dict = @{@"first":index1,@"first":index2};
    if ([self.delegate respondsToSelector:@selector(SecondMenuClickIndex:)]) {
        [self.delegate SecondMenuClickIndex:dict];
    }
}

-(void)backBTNclick:(NSInteger)index {
    for (UIView *view in self.subviews) {
        CGPoint center = [[NumberPosition shareNumInstance] getPositionFromType:NumberStyle4 andNumber:index];
        [UIView animateWithDuration:1 animations:^{
            view.center = center;
            view.alpha = 0;
        }];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeAndAdd) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)removeAndAdd{
    [self removeSubView];
    [self setImageFrom:_bigarray];
}

-(void)showTA {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

-(void)hideTA {
    [self removeFromSuperview];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    //当前的point
    CGPoint currentP = [touch locationInView:self];
    
    //以前的point
    CGPoint preP = [touch previousLocationInView:self];
    
    //x轴偏移的量
    CGFloat offsetX = currentP.x - preP.x;
    
    //Y轴偏移的量
    CGFloat offsetY = currentP.y - preP.y;
    
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    
    _lastPoint = CGPointMake(self.frame.origin.x, self.frame.origin.y);
}

@end
