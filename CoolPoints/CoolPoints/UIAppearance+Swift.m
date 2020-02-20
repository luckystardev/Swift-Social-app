//
//  UIAppearance+Swift.m
//  CoolPoints
//
//  Created by tmaas510 on 3/9/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

#import "UIAppearance+Swift.h"

@implementation UIView (UIVIewAppeance_Swift)

+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass{
    return [self appearanceWhenContainedIn:containerClass, nil];
}

@end
