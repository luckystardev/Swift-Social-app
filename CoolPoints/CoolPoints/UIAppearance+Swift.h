//
//  UIAppearance+Swift.h
//  CoolPoints
//
//  Created by matti on 3/9/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIVIewAppeance_Swift)
+(instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end
