//
// Created by Maxim Filimonov on 4/03/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cell : NSObject
@property(nonatomic, readonly) BOOL dead;

- (void)die;
@end
