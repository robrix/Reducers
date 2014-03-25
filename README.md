# Reducers

Initially introduced in Clojure, reducers are [a model for processing collections](http://clojure.com/blog/2012/05/08/reducers-a-library-and-model-for-collection-processing.html) which [transforms the procedures](http://clojure.com/blog/2012/05/15/anatomy-of-reducer.html) rather than the collections themselves.

Its advantages include lazy evaluation, few allocations, efficiency, and the potential for convenient parallelization via the closely-related *folders*.

This framework is an implementation of reducers for Cocoa and Cocoa Touch.

## What would I use it for?

Mapping, filtering, and folding Cocoa collections lazily, with low overhead.

## Examples

First, import `Reducers/Reducers.h`:

    #import <Reducers/Reducers.h>

Let’s say we have some `numbers`, but we only want to operate on the even ones:

    id<REDReducible> evenNumbers = REDFilter(numbers, ^bool (NSNumber *each) {
        return each.integerValue % 2;
    });

Now let’s make a text field for each:

    id<REDReducible> views = REDMap(evenNumbers, ^(NSNumber *each) {
        NSTextField *textField = [NSTextField new];
        textField.editable = NO;
        textField.stringValue = each.description;
        return textField;
    });

Reducers are evaluated lazily, so we’ve specified a way of turning numbers into text fields with even numbers, but we haven’t yet got a collection of the text fields. We can produce one by appending onto an array:

    NSArray *viewsArray = [@[] red_append:views];

Finally, we can place these views into the view hierarchy:

    self.view = [NSStackView stackViewWithViews:viewsArray];

Now let’s sum the numbers we produced:

    NSNumber *sum = [evenNumbers red_reduce:@0 usingBlock:^(NSNumber *a, NSNumber *b) {
        return @(a.integerValue + b.integerValue);
    }];

## Notes

Since reducers are evaluated lazily, you need to reduce them to produce a Cocoa collection. `-red_append:`, which is implemented on `NSArray`, `NSSet`, and `NSDictionary` reduces its argument, and is a convenient way to produce a concrete, evaluated collection using a reducer.

API-level documentation is provided in the headers.
