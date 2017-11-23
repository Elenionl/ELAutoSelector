//
//  ELAutoSelectorHelper.m
//  ELAutoSelectorHelper
//
//  Created by Elenion on 2017/11/22.
//  Copyright © 2017年 elenion. All rights reserved.
//

#import "ELAutoSelectorHelper.h"

@interface ELImpSet: NSObject

@property (nonatomic, strong) ELAutoSelectorAction action;
@property (nonatomic, weak) id dependency;

@end

@implementation ELImpSet

+ (instancetype)impSetWith:(ELAutoSelectorAction)action dependency:(id)dependency {
    ELImpSet *set = [[ELImpSet alloc] init];
    set.action = action;
    set.dependency = dependency;
    return set;
}

@end

@interface ELAutoSelectorHelper ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, ELImpSet *> *impDic;

@end

@implementation ELAutoSelectorHelper {
    NSLock *_lock;
    NSTimer *_timer;
}

+ (ELAutoSelectorHelper *)shared {
    static ELAutoSelectorHelper *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ELAutoSelectorHelper alloc] init__el];
    });
    return shared;
}

- (instancetype)init
{
    return [ELAutoSelectorHelper shared];
}

- (instancetype)init__el
{
    self = [super init];
    if (self) {
        _impDic = [NSMutableDictionary new];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(disposeResources) userInfo:nil repeats:true];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (SEL)selectorFor:(ELAutoSelectorAction)action depenedency:(id)dependency {
    if (!action) {
        return @selector(voidAction:);
    }
    ELAutoSelectorAction actionCopy = [action copy];
    ELImpSet *set = [ELImpSet impSetWith:actionCopy dependency:dependency ?: self];
    NSString *selString = [NSString stringWithFormat:@"_el_sel_%@", set.description];
    SEL sel = NSSelectorFromString(selString);
    if ([self respondsToSelector:sel]) {
        class_replaceMethod([self class], sel, imp_implementationWithBlock(actionCopy), "v@:@");
    }
    [_lock lock];
    [_impDic setObject:set forKey:selString];
    [_lock unlock];
    return sel;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selString = NSStringFromSelector(sel);
    ELImpSet *set = ELTarget.impDic[selString];
    if (set) {
        class_addMethod([self class], sel, imp_implementationWithBlock(set.action), "v@:@");
    }
    else {
        
        class_addMethod([self class], sel, ELTarget.voidAction, "v@:@");
    }
    return true;
}

- (void)voidAction:(id)sender {
#ifdef DEBUG
    NSLog(@"Warnning from ELAutoSelector: PlaceHolder IMP Called by %@, place double check.", sender);
#endif
}

- (IMP)voidAction {
    ELAutoSelectorAction voidAction = ^void(id _self, id sender) {
#ifdef DEBUG
        NSLog(@"Warnning from ELAutoSelector: PlaceHolder IMP Called by %@, place double check.", sender);
#endif
    };
    return imp_implementationWithBlock(voidAction);
}

- (void)disposeResources {
    [_lock lock];
    for (NSString *key in _impDic.keyEnumerator) {
        ELImpSet *set = _impDic[key];
        if (!set.dependency) {
            SEL sel = NSSelectorFromString(key);
            IMP imp = [self methodForSelector:sel];
            imp_removeBlock(imp);
            class_replaceMethod([self class], sel, ELTarget.voidAction, "v@:@");
            [_impDic removeObjectForKey:key];
        }
    }
    [_lock unlock];
}

@end

SEL ELAction(ELAutoSelectorAction action, id dependency) {
    return [ELTarget selectorFor:action depenedency:dependency];
}

SEL ELActionPermanent(ELAutoSelectorAction action) {
    return [ELTarget selectorFor:action depenedency:ELTarget];
}
