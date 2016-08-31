//
//  TouchAssistantView.h
//  TouchAssistant
//
//  Created by Peter on 8/31/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  TouchAssistantDelegate
 */
@protocol TDdelegate <NSObject>
/**
 *  第一级菜单点击事件,数组中block值为YES即可拦截
 *
 *  @param index 点击按钮的目录
 */
-(void)FirstMenuClickIndex:(NSInteger)index;

/**
 *  第二级菜单点击事件,字典格式为  @{@"first":index1,@"second":index2} ,index1为第一级目录，index2为第二级目录
 *
 *  @param index 目录字典
 */
-(void)SecondMenuClickIndex:(NSDictionary *)index;
@end


@interface TouchAssistantView : UIView

@property(nonatomic,strong) id<TDdelegate> delegate;

/**
 *  初始化touch assistant
 *
 *  @param arra  初始化工具数组
 *  @param point 起始点坐标
 *
 *  @return 返回实例对象
 */
+(instancetype)TAWithBigArrary:(NSArray *)arra
            andInitialPosition:(CGPoint)point;


/**
 *  显示touch assistant
 */
-(void)showTA;


/**
 *  不显示touch assistant
 */
-(void)hideTA;

@end
