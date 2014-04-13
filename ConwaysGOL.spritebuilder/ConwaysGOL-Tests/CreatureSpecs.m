#import "Kiwi.h"
#import "Creature.h"
#import "CCSpriteFrame.h"

SPEC_BEGIN(CreatureSpecs)

describe(@"Creature", ^{
    describe(@"-initCreature", ^{
        it(@"is not alive yet", ^{
            Creature *creature = [[Creature alloc] initCreature];
            [[theValue(creature.isAlive) should] beFalse];
        });
        it(@"has default image", ^{
            Creature *creature = [[Creature alloc] initCreature];
            [[creature.spriteFrame.texture shouldNot] beNil];
        });
    });
});

SPEC_END



