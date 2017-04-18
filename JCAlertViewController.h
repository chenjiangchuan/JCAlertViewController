//
//  JCAlertViewController.h
//
//  Created by chenjiangchuan on 2017/4/14.
//  Copyright © 2017年 www.oriochan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCAlertViewControllerTransitionStyle) {
    /** Fade in the alert view */
    JCAlertViewControllerTransitionStyleFade,
    /** Slide the alert view from the top of the view */
    JCAlertViewControllerTransitionStyleSlideFromTop,
    /** Slide the alert view from the bottom of the view */
    JCAlertViewControllerTransitionStyleSlideFromBottom
};

@interface JCAlertViewController : UIViewController <NSCopying, NSMutableCopying>

/** 点击背景是否退出当前控制器 */
@property(assign, nonatomic) BOOL backgroundTapDismissalGestureEnabled;
/** 弹窗视图 */
@property(strong, nonatomic) UIView *alertViewContentView;
/** 弹窗视图的size大小 */
@property(assign, nonatomic) CGSize alertViewContentViewSize;

+ (instancetype)sharedInstance;
- (void)removeAlertView;

@end
