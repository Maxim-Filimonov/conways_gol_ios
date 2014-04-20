#import "Kiwi.h"
#import "Grid.h"
#import "Creature.h"
#import "CCBAnimationManager.h"

SPEC_BEGIN(GridSpecs)

describe(@"Grid", ^{
    describe(@"-onEnter", ^{
        it(@"allows user interaction", ^{
            Grid *grid = [[Grid alloc] init];

            [grid onEnter];

            [[theValue(grid.userInteractionEnabled) should] beTrue];
        });
        describe(@"grid setup", ^{
            __block Grid *grid;
            beforeEach(^{
                grid = [[Grid alloc] init];
                [grid onEnter];
            });
            it(@"creates rows", ^{
                [[theValue([[grid gridArray] count]) should] equal:theValue(GRID_ROWS)];
            });
            it(@"creates columns for each row", ^{
                for (NSMutableArray *row in [grid gridArray]) {
                    [[theValue([row count]) should] equal:theValue(GRID_COLUMNS)];
                }
            });
            it(@"creates a creature in every cell", ^{
                for (NSMutableArray *row in [grid gridArray]){
                    for (Creature *cell in row) {
                        [[cell should] beKindOfClass:[Creature class]];
                    }
                }
            });
            it(@"places cells in each corner of the grid", ^{
                grid.contentSize = CGSizeMake(300, 400);
                [grid onEnter];

                Creature* upperLeftCell = [[[grid gridArray] firstObject] firstObject];
                Creature* upperRightCell = [[[grid gridArray] firstObject] lastObject];
                Creature* lowerLeftCell = [[[grid gridArray] lastObject] firstObject];
                Creature* lowerRightCell = [[[grid gridArray] lastObject] lastObject];

                int lastCellX = 300 - 300/GRID_COLUMNS;
                int lastCellY = 400 - 400/GRID_ROWS;
                [[theValue(upperRightCell.position.x - upperLeftCell.position.x) should] equal:theValue(lastCellX)];
                [[theValue(lowerRightCell.position.x - lowerLeftCell.position.x) should] equal:theValue(lastCellX)];
                [[theValue(lowerLeftCell.position.y - upperLeftCell.position.y) should] equal:theValue(lastCellY)];
                [[theValue(lowerRightCell.position.y - upperRightCell.position.y) should] equal:theValue(lastCellY)];
            });
            it(@"adds cells as children of the grid", ^{
                NSUInteger gridChildrenCount = [[grid children] count];

                [[theValue(gridChildrenCount) should] equal:theValue(GRID_COLUMNS*GRID_ROWS)];
            });
        });

        describe(@"-touchBegan", ^{
            __block Grid *grid;
            beforeEach(^{
                grid = [[Grid alloc] init];
                grid.contentSize = CGSizeMake(100, 80);
                [grid onEnter];
            });
            it(@"revives creature in touched cell when it is not alive", ^{
               Creature *selectedCell = (Creature*)[grid gridArray][5][2];
               selectedCell.isAlive = FALSE;

               UITouch *touch = [UITouch mock];
               [touch stub:@selector(locationInNode:) andReturn:theValue(ccp(selectedCell.position.x,selectedCell.position.y))];

               [grid touchBegan:touch withEvent:nil];

                [[theValue(selectedCell.isAlive) should] beTrue];
            });
            it(@"kills creature when is is alive", ^{
                Creature *selectedCell = (Creature*)[grid gridArray][0][0];
                selectedCell.isAlive = TRUE;

                UITouch *touch = [UITouch mock];
                [touch stub:@selector(locationInNode:) andReturn:theValue(ccp(selectedCell.position.x,selectedCell.position.y))];

                [grid touchBegan:touch withEvent:nil];

                [[theValue(selectedCell.isAlive) should] beFalse];

            });
        });
    });
    describe(@"-countNeighbours", ^{
        __block Grid *grid;
        beforeEach(^{
            grid = [[Grid alloc] init];
            [grid onEnter];
        });
       it(@"counts alive neighbors from row above", ^{
           for (NSUInteger cols = 0; cols < 3; cols++) {
               Creature *creature = [[Creature alloc] initCreature];
               creature.isAlive = TRUE;
               [grid gridArray][0][cols] = creature;
           }
           Creature *testCreature = [[Creature alloc] initCreature];
           [grid gridArray][1][1] = testCreature;

           [grid countNeighbours];

           [[theValue(testCreature.livingNeighbors) should] equal:theValue(3)];
       });
        it(@"counts alive neighbor from row below", ^{
            for (NSUInteger cols = 0; cols < 3; cols++) {
                Creature *creature = [[Creature alloc] initCreature];
                creature.isAlive = TRUE;
                [grid gridArray][2][cols] = creature;
            }
            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(3)];
        });
        it(@"counts alive neighbors on the same row", ^{
            Creature* aliveCreature = [[Creature alloc] initCreature];
            aliveCreature.isAlive = TRUE;
            [grid gridArray][1][0] = aliveCreature;
            [grid gridArray][1][2] = aliveCreature;

            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(2)];
        });
        it(@"ignores the cell itselfs when counting neighbors", ^{
            Creature* aliveCreature = [[Creature alloc] initCreature];
            aliveCreature.isAlive = TRUE;
            [grid gridArray][1][0] = aliveCreature;
            [grid gridArray][1][2] = aliveCreature;

            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;
            testCreature.isAlive = TRUE;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(2)];
        });
    });
    describe(@"-updateCreatures", ^{
        __block Grid *grid;
        __block Creature *creature;
        beforeEach(^{
            grid = [[Grid alloc] init];
            [grid onEnter];
            creature = [grid gridArray][0][0];
        });
        describe(@"if creature is alive", ^{
            beforeEach(^{
                creature.isAlive = TRUE;
            });
            it(@"kills creature with one neighbor", ^{
                creature.livingNeighbors = 1;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beFalse];
            });
            it(@"leaves creature untouched if it has two neighbors", ^{
                creature.livingNeighbors = 2;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beTrue];
            });
            it(@"leaves creature untouched if it has three neighbors", ^{
                creature.livingNeighbors = 3;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beTrue];
            });
            it(@"kills creature if it has 4 neighbors", ^{
                creature.livingNeighbors = 4;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beFalse];
            });
        });
        describe(@"when creature is dead", ^{
            beforeEach(^{
                creature.isAlive = FALSE;
            });
            it(@"revives creature if it has exactly 3 neighbors", ^{
                creature.livingNeighbors = 3;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beTrue];
            });
            it(@"leaves creature untouched if it has two neighbors", ^{
                creature.livingNeighbors = 2;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beFalse];
            });
        });
    });
    describe(@"-countNeighbours", ^{
        __block Grid *grid;
        beforeEach(^{
            grid = [[Grid alloc] init];
            [grid onEnter];
        });
        it(@"counts alive neighbors from row above", ^{
            for (NSUInteger cols = 0; cols < 3; cols++) {
                Creature *creature = [[Creature alloc] initCreature];
                creature.isAlive = TRUE;
                [grid gridArray][0][cols] = creature;
            }
            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(3)];
        });
        it(@"counts alive neighbor from row below", ^{
            for (NSUInteger cols = 0; cols < 3; cols++) {
                Creature *creature = [[Creature alloc] initCreature];
                creature.isAlive = TRUE;
                [grid gridArray][2][cols] = creature;
            }
            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(3)];
        });
        it(@"counts alive neighbors on the same row", ^{
            Creature* aliveCreature = [[Creature alloc] initCreature];
            aliveCreature.isAlive = TRUE;
            [grid gridArray][1][0] = aliveCreature;
            [grid gridArray][1][2] = aliveCreature;

            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(2)];
        });
        it(@"ignores the cell itselfs when counting neighbors", ^{
            Creature* aliveCreature = [[Creature alloc] initCreature];
            aliveCreature.isAlive = TRUE;
            [grid gridArray][1][0] = aliveCreature;
            [grid gridArray][1][2] = aliveCreature;

            Creature *testCreature = [[Creature alloc] initCreature];
            [grid gridArray][1][1] = testCreature;
            testCreature.isAlive = TRUE;

            [grid countNeighbours];

            [[theValue(testCreature.livingNeighbors) should] equal:theValue(2)];
        });
    });
    describe(@"-updateCreatures", ^{
        __block Grid *grid;
        __block Creature *creature;
        beforeEach(^{
            grid = [[Grid alloc] init];
            [grid onEnter];
            creature = [grid gridArray][0][0];
        });
        describe(@"if creature is alive", ^{
            beforeEach(^{
                creature.isAlive = TRUE;
            });
            it(@"kills creature with one neighbor", ^{
                creature.livingNeighbors = 1;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beFalse];
            });
            it(@"leaves creature untouched if it has two neighbors", ^{
                creature.livingNeighbors = 2;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beTrue];
            });
            it(@"leaves creature untouched if it has three neighbors", ^{
                creature.livingNeighbors = 3;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beTrue];
            });
            it(@"kills creature if it has 4 neighbors", ^{
                creature.livingNeighbors = 4;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beFalse];
            });
        });
        describe(@"when creature is dead", ^{
            beforeEach(^{
                creature.isAlive = FALSE;
            });
            it(@"revives creature if it has exactly 3 neighbors", ^{
                creature.livingNeighbors = 3;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beTrue];
            });
            it(@"leaves creature untouched if it has two neighbors", ^{
                creature.livingNeighbors = 2;

                [grid updateCreatures];

                [[theValue(creature.isAlive) should] beFalse];
            });
        });
    });
});

SPEC_END
