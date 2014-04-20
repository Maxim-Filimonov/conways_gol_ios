//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"


@interface Creature : CCSprite
@property(nonatomic, assign) BOOL isAlive;

@property(nonatomic) NSUInteger livingNeighbors;

- (id)initCreature;
@end
