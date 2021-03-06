//
// Created by Maxim Filimonov on 13/04/2014.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"


@implementation Grid {
    NSMutableArray *_gridArray;
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

- (void)evolveStep {
    [self countNeighbours];

    [self updateCreatures];

    _generation += 1;
}

- (void)updateCreatures {
    NSUInteger numAlive = 0;
    for(NSMutableArray *row in _gridArray) {
        for(Creature* creature in row) {
            if (creature.livingNeighbors < 2) {
                creature.isAlive = FALSE;
            }
            else if (creature.livingNeighbors > 3) {
                creature.isAlive = FALSE;
            }
            else if(creature.livingNeighbors == 3){
                numAlive += 1;
                creature.isAlive = TRUE;
            }
        }
    }
    _population = numAlive;
}

- (void)countNeighbours {

   for(NSMutableArray *row in _gridArray) {
       for(Creature* creature in row) {
           creature.livingNeighbors = 0;
           NSUInteger topRowIndex = [_gridArray indexOfObject:row] - 1;
           for (NSUInteger rowNeighborsIndex = topRowIndex; rowNeighborsIndex <= topRowIndex + 2; rowNeighborsIndex++) {
               NSUInteger leftColumnIndex = [row indexOfObject:creature] - 1;

               for (NSUInteger neighborsIndex = leftColumnIndex; neighborsIndex <= leftColumnIndex + 2; neighborsIndex++) {
                   if([self isIndexValidForRow:rowNeighborsIndex andColumn:neighborsIndex])
                   {
                       NSMutableArray *neighborRow = _gridArray[rowNeighborsIndex];
                       Creature* neighbor = neighborRow[neighborsIndex];

                       if(neighbor.isAlive && neighbor != creature) {
                           creature.livingNeighbors += 1;
                       }
                   }
               }
           }
       }
   }
}

- (BOOL)isIndexValidForRow:(NSUInteger)rowIndex andColumn:(NSUInteger)columnIndex {
    BOOL isIndexValid = TRUE;
    if(rowIndex < 0 || columnIndex < 0 || rowIndex >= GRID_ROWS || columnIndex >= GRID_COLUMNS){
        isIndexValid = FALSE;
    }
    return isIndexValid;
}
@end
