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
});

SPEC_END
