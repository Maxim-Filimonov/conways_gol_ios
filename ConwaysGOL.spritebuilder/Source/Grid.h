//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"
#import "GameEvolver.h"

@class CCLabelTTF;


static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;
@interface Grid : CCSprite <GameEvolver>

@property(nonatomic, strong) NSMutableArray *gridArray;

@property(nonatomic, readonly) float cellWidth;
@property(nonatomic, readonly) float cellHeight;
@property(nonatomic, strong) id<GameEvolver> gameEvolver;

@property(nonatomic, strong) CCLabelTTF *generationLabel;

@property(nonatomic, strong) CCLabelTTF *populationLabel;

- (void)play;

@end
