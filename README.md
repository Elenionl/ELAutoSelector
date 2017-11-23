# ELAutoSelector


Change *target* *action* into **blocks**

If you feel `- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;` is too complex to use, try ELAutoSelector.
## Install

```
pod install ELAutoSelector
```

## Use
  
``` Objective-C
    #import "ELAutoSelectorHelper.h"
    // In implementation
    [myButton addTarget:ELTarget action:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        ...
        // What you want to do
    }, self) forControlEvents:UIControlEventTouchUpInside];
```

## Attention
### ELAction(,) Function
 `ELAction(action, dependency)` 
**Action** is the block to be exectuted when event happened.
**Dependency** is the object to determine **action**'s life.
If **dependency** is nil, **action** will never be released, never will the object captured  strongly by **action**.
If **dependency** is captured strongly by action, this will leads to a memory leak, resulting in **action** and **dependency** is never released.


## Requirements

* iOS 7.0+
* ARC

## Author

@Elenionl, stallanxu@gmail.com

## License

English: ELAutoSelector is available under the Apache 2.0 license, see the LICENSE file for more information.