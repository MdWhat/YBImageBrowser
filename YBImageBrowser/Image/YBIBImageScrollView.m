//
//  YBIBImageScrollView.m
//  YBImageBrowserDemo
//
//  Created by 波儿菜 on 2019/6/10.
//  Copyright © 2019 波儿菜. All rights reserved.
//

#import "YBIBImageScrollView.h"

@interface YBIBImageScrollView ()
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@end

@implementation YBIBImageScrollView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        self.layer.masksToBounds = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark - public

- (void)setImage:(__kindof UIImage *)image type:(YBIBScrollImageType)type {
    self.imageView.image = image;
    self.imageType = type;
}

- (void)reset {
    self.zoomScale = 1;
    self.imageView.image = nil;
    self.imageView.frame = CGRectZero;
    self.imageType = YBIBScrollImageTypeNone;
}

#pragma mark - getters

- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [YYAnimatedImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end


#import <objc/runtime.h>

@implementation YYAnimatedImageView (Layer)

+ (void)load {
    
    Method displayLayerMethod = class_getInstanceMethod(self, @selector(displayLayer:));
   
    Method displayLayerNewMethod = class_getInstanceMethod(self, @selector(displayLayerNew:));
 
    method_exchangeImplementations(displayLayerMethod, displayLayerNewMethod);
}

- (void)displayLayerNew:(CALayer *)layer {
    
    Ivar imgIvar = class_getInstanceVariable([self class], "_curFrame");
    UIImage *img = object_getIvar(self, imgIvar);
    if (img) {
        layer.contents = (__bridge id)img.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}

@end
