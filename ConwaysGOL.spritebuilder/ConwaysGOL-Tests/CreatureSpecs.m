#import "Kiwi.h"
#import "Creature.h"
#import "CCSpriteFrame.h"

SPEC_BEGIN(CreatureSpecs)

describe(@"Creature", ^{
    __block Creature* creature;
    beforeEach(^{
        creature = [[Creature alloc] initCreature];
    });
    describe(@"-initCreature", ^{
        it(@"is not alive yet", ^{
            [[theValue(creature.isAlive) should] beFalse];
        });
        it(@"has default image", ^{
            [[creature.spriteFrame.texture shouldNot] beNil];
        });
    });
    describe(@"-setIsAlive", ^{
        it(@"brings creature to live when asked", ^{
            [creature setIsAlive:TRUE];

            [[theValue([creature isAlive]) should] beTrue];
        });
        it(@"makes creature visible when it is alive", ^{
            [creature setIsAlive:TRUE];

            [[theValue([creature visible]) should] beTrue];
        });
        it(@"makes creature dissapear when it is not alive anymore", ^{
            [creature setIsAlive:FALSE];

            [[theValue([creature visible]) should] beFalse];
        });
    });
});

SPEC_END



