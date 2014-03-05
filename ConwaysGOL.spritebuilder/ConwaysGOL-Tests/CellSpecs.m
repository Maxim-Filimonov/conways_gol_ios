#import "Kiwi.h"
#import "Cell.h"

SPEC_BEGIN(CellSpecs)

describe(@"Cell", ^{
    describe(@"-die", ^{
        it(@"dies when requested", ^{
            Cell *cell = [[Cell alloc] init];

            [cell die];

            [[theValue([cell dead]) should] beTrue];
        });
    });
});

SPEC_END



