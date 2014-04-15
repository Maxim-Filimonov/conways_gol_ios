//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"


@implementation Grid {
    NSMutableArray *_gridArray;
    int _generation;
    int _totalAlive;
}
// Calls on loading of grid into UI
- (void)onEnter {
    [super onEnter];

    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    [self setupGrid];

    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];

    Creature *creature = [self creatureForTouchPosition:touchLocation];

    creature.isAlive = ! creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)point {
    NSUInteger rowIndex = (NSUInteger) (point.y / self.cellHeight);
    NSUInteger columnIndex = (NSUInteger) (point.x / self.cellWidth);
    NSMutableArray *row = _gridArray[rowIndex];
    return row[columnIndex];
}

- (void)setupGrid {

    float x = 0;
    float y = 0;

    _gridArray = [NSMutableArray array];
    for (NSUInteger rowIndex = 0; rowIndex < GRID_ROWS; rowIndex++) {
        x = 0;
        _gridArray[rowIndex] = [NSMutableArray array];
        for (NSUInteger columnIndex = 0; columnIndex < GRID_COLUMNS; columnIndex++) {

            Creature* creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            _gridArray[rowIndex][columnIndex] = creature;

            x += self.cellWidth;
        }
        y += self.cellHeight;
    }
}

@end
