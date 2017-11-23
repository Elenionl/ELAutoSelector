//
//  ELAutoSelectorHelper.h
//  ELAutoSelectorHelper
//
//  Created by Elenion on 2017/11/22.
//  Copyright © 2017年 elenion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#define ELTarget [ELAutoSelectorHelper shared]

NS_ASSUME_NONNULL_BEGIN

@class ELAutoSelectorHelper;

typedef void(^ELAutoSelectorAction)(id _self, id sender);

@interface ELAutoSelectorHelper : NSObject

@property (class, readonly) ELAutoSelectorHelper *shared;
- (SEL)selectorFor:(ELAutoSelectorAction)action depenedency:(id _Nullable)dependency;

@end

SEL ELAction(ELAutoSelectorAction action, id _Nullable dependency);
SEL ELActionPermanent(ELAutoSelectorAction action);

NS_ASSUME_NONNULL_END
