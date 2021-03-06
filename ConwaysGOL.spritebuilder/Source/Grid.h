//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@class CCLabelTTF;


static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;
@interface Grid : CCSprite

@property(nonatomic, strong) NSMutableArray *gridArray;

@property(nonatomic, readonly) float cellWidth;
@property(nonatomic, readonly) float cellHeight;

@property(nonatomic, readonly) int generation;

@property(nonatomic) int population;

- (void)evolveStep;

- (void)updateCreatures;

- (void)countNeighbours;
@end
