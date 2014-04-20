//
// Created by Maxim Filimonov on 19/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameEvolver <NSObject>
- (void)evolveStep;
@property (nonatomic) int generation;
@property (nonatomic, readonly) int population;
@end
