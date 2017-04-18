//
//  JCAlertViewController.m
//
//  Created by chenjiangchuan on 2017/4/14.
//  Copyright © 2017年 www.oriochan.com. All rights reserved.
//

#import "JCAlertViewController.h"

#ifndef IPHONE6Puls_WIDTH
#define IPHONE6Puls_WIDTH 414
#endif

#ifndef IPHONE6Puls_HEIGHT
#define IPHONE6Puls_HEIGHT 736
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif

//////////////////////////////////////////////////////////////////
#pragma mark - 进入控制器时的转场动画效果

@interface JCAlertViewPresentationAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property JCAlertViewControllerTransitionStyle transitionStyle;
@property CGFloat duration;

@end

static CGFloat const kDefaultPresentationAnimationDuration = 0.7f;

@implementation JCAlertViewPresentationAnimationController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.duration = kDefaultPresentationAnimationDuration;
    }
    
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionStyle == JCAlertViewControllerTransitionStyleSlideFromTop || self.transitionStyle == JCAlertViewControllerTransitionStyleSlideFromBottom) {
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        CGRect initialFrame = [transitionContext finalFrameForViewController:toViewController];
        
        initialFrame.origin.y = self.transitionStyle == JCAlertViewControllerTransitionStyleSlideFromTop ? -(initialFrame.size.height + initialFrame.origin.y) : (initialFrame.size.height + initialFrame.origin.y);
        toViewController.view.frame = initialFrame;
        
        [[transitionContext containerView] addSubview:toViewController.view];
        
        // If we're using the slide from top transition, apply a 3D rotation effect to the alert view as it animates in
        if (self.transitionStyle == JCAlertViewControllerTransitionStyleSlideFromTop) {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0f / 600.0f;
            transform = CATransform3DRotate(transform,  M_PI_4 * 1.3f, 1.0f, 0.0f, 0.0f);
            
            toViewController.view.layer.zPosition = 100.0f;
            toViewController.view.layer.transform = transform;
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0f
             usingSpringWithDamping:0.76f
              initialSpringVelocity:0.2f
                            options:0
                         animations:^{
                             toViewController.view.layer.transform = CATransform3DIdentity;
                             toViewController.view.layer.opacity = 1.0f;
                             toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    } else {
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
        [[transitionContext containerView] addSubview:toViewController.view];
        
        toViewController.view.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.2f);
        toViewController.view.layer.opacity = 0.0f;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.layer.transform = CATransform3DIdentity;
                             toViewController.view.layer.opacity = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionStyle) {
        case JCAlertViewControllerTransitionStyleFade:
            return 0.3f;
            break;
            
        case JCAlertViewControllerTransitionStyleSlideFromTop:
        case JCAlertViewControllerTransitionStyleSlideFromBottom:
            return 0.6f;
    }
}

@end

//////////////////////////////////////////////////////////////////
#pragma mark - 退出控制器时的转场动画效果

@interface JCAlertViewDismissalAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property JCAlertViewControllerTransitionStyle transitionStyle;
@property CGFloat duration;

@end

static CGFloat const kDefaultDismissalAnimationDuration = 0.6f;

@implementation JCAlertViewDismissalAnimationController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.duration = kDefaultDismissalAnimationDuration;
    }
    
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionStyle == JCAlertViewControllerTransitionStyleSlideFromTop || self.transitionStyle == JCAlertViewControllerTransitionStyleSlideFromBottom) {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        CGRect finalFrame = [transitionContext finalFrameForViewController:fromViewController];
        finalFrame.origin.y = 1.2f * CGRectGetHeight([transitionContext containerView].frame);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0f
             usingSpringWithDamping:0.8f
              initialSpringVelocity:0.1f
                            options:0
                         animations:^{
                             NSLog(@"finalFrame = %@", NSStringFromCGRect(finalFrame));
                             fromViewController.view.frame = finalFrame;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    } else {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.layer.opacity = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionStyle) {
        case JCAlertViewControllerTransitionStyleFade:
            return 0.3f;
            break;
            
        case JCAlertViewControllerTransitionStyleSlideFromTop:
        case JCAlertViewControllerTransitionStyleSlideFromBottom:
            return 0.6f;
    }}

@end

//////////////////////////////////////////////////////////////////
#pragma mark - 自定义弹窗控制器

@interface JCAlertViewPresentationController : UIPresentationController

@property CGFloat presentedViewControllerHorizontalInset;
@property CGFloat presentedViewControllerVerticalInset;
@property (nonatomic) BOOL backgroundTapDismissalGestureEnabled;
@property UIView *backgroundDimmingView;

@end

@interface JCAlertViewPresentationController ()

- (void)tapGestureRecognized:(UITapGestureRecognizer *)gestureRecognizer;

@end

@implementation JCAlertViewPresentationController

- (void)presentationTransitionWillBegin {
    self.presentedViewController.view.layer.cornerRadius = 6.0f;
    self.presentedViewController.view.layer.masksToBounds = YES;
    
    self.backgroundDimmingView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.backgroundDimmingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.backgroundDimmingView.alpha = 0.0f;
    self.backgroundDimmingView.backgroundColor = [UIColor blackColor];
    [self.containerView addSubview:self.backgroundDimmingView];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundDimmingView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(_backgroundDimmingView)]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundDimmingView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(_backgroundDimmingView)]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.backgroundDimmingView addGestureRecognizer:tapGestureRecognizer];
    
    // Shrink the presenting view controller, and animate in the dark background view
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundDimmingView.alpha = 0.7f;
    }
                                           completion:nil];
}

- (BOOL)shouldPresentInFullscreen {
    return NO;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    
    if (!completed) {
        [self.backgroundDimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundDimmingView.alpha = 0.0f;
        
        self.presentingViewController.view.transform = CGAffineTransformIdentity;
    }
                                           completion:nil];
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    
    [self presentedView].frame = [self frameOfPresentedViewInContainerView];
    self.backgroundDimmingView.frame = self.containerView.bounds;
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    
    if (completed) {
        [self.backgroundDimmingView removeFromSuperview];
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.backgroundTapDismissalGestureEnabled) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end


//////////////////////////////////////////////////////////////////
#pragma mark - JCAlertViewController

@interface JCAlertViewController () <UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate>

@property UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) id<UIViewControllerTransitioningDelegate> transitioningDelegate;
/** 转场动画类型，只支持一种 */
@property(assign, nonatomic, readonly) JCAlertViewControllerTransitionStyle transitionStyle;

- (void)panGestureRecognized:(UIPanGestureRecognizer *)gestureRecognizer;

@end

@implementation JCAlertViewController

#pragma mark - Life Cycle

static JCAlertViewController *_sharedInstance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
        }
    });
    return _sharedInstance;
}

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // 宽高适配
        _alertViewContentViewSize = CGSizeMake((900 * SCREEN_WIDTH  / IPHONE6Puls_WIDTH / 3), (901 * SCREEN_HEIGHT / IPHONE6Puls_HEIGHT / 3));
        _transitionStyle = JCAlertViewControllerTransitionStyleFade;
        _backgroundTapDismissalGestureEnabled = YES;
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    self.panGestureRecognizer.delegate = self;
    self.panGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)loadView {
    self.view = self.alertViewContentView;
}

- (void)viewWillLayoutSubviews {
    CGFloat width = self.alertViewContentViewSize.width;
    CGFloat height = self.alertViewContentViewSize.height;

    CGFloat x = [UIScreen mainScreen].bounds.size.width*0.5 - width*0.5;
    CGFloat y = [UIScreen mainScreen].bounds.size.height*0.5 - height*0.5;

    self.view.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Public Method

- (void)addAlertView:(UIView *)alertView {
    _alertViewContentView = alertView;
}

- (void)removeAlertView {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor darkGrayColor]];
    _alertViewContentView = view;
}

#pragma mark - Lazy Initialze

- (void)panGestureRecognized:(UIPanGestureRecognizer *)gestureRecognizer {
//    self.view.backgroundViewVerticalCenteringConstraint.constant = [gestureRecognizer translationInView:self.view].y;
    
    JCAlertViewPresentationController *presentationController = (JCAlertViewPresentationController* )self.presentationController;
    
    CGFloat windowHeight = CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds);
    presentationController.backgroundDimmingView.alpha = 0.7f - (fabs([gestureRecognizer translationInView:self.view].y) / windowHeight);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat verticalGestureVelocity = [gestureRecognizer velocityInView:self.view].y;
        
        // If the gesture is moving fast enough, animate the alert view offscreen and dismiss the view controller. Otherwise, animate the alert view back to its initial position
        if (fabs(verticalGestureVelocity) > 500.0f) {
            CGFloat backgroundViewYPosition;
            
            if (verticalGestureVelocity > 500.0f) {
                backgroundViewYPosition = CGRectGetHeight(self.view.frame);
            } else {
                backgroundViewYPosition = -CGRectGetHeight(self.view.frame);
            }
            
            CGFloat animationDuration = 500.0f / fabs(verticalGestureVelocity);
            
//            self.view.backgroundViewVerticalCenteringConstraint.constant = backgroundViewYPosition;
            [UIView animateWithDuration:animationDuration
                                  delay:0.0f
                 usingSpringWithDamping:0.8f
                  initialSpringVelocity:0.2f
                                options:0
                             animations:^{
                                 presentationController.backgroundDimmingView.alpha = 0.0f;
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }];
        } else {
//            self.view.backgroundViewVerticalCenteringConstraint.constant = 0.0f;
            [UIView animateWithDuration:0.5f
                                  delay:0.0f
                 usingSpringWithDamping:0.8f
                  initialSpringVelocity:0.4f
                                options:0
                             animations:^{
                                 presentationController.backgroundDimmingView.alpha = 0.7f;
                                 [self.view layoutIfNeeded];
                             }
                             completion:nil];
        }
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    JCAlertViewPresentationController *presentationController = [[JCAlertViewPresentationController alloc] initWithPresentedViewController:presented
                                                                                                                  presentingViewController:presenting];
    presentationController.backgroundTapDismissalGestureEnabled = self.backgroundTapDismissalGestureEnabled;
    return presentationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    JCAlertViewPresentationAnimationController *presentationAnimationController = [[JCAlertViewPresentationAnimationController alloc] init];
    presentationAnimationController.transitionStyle = self.transitionStyle;
    return presentationAnimationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    JCAlertViewDismissalAnimationController *dismissalAnimationController = [[JCAlertViewDismissalAnimationController alloc] init];
    dismissalAnimationController.transitionStyle = self.transitionStyle;
    return dismissalAnimationController;
}

@end
