#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// Function pointer for the original implementation
static NSString *(*orig_pathForResourceOfTypeInDirectory)(NSBundle *, SEL, NSString *, NSString *, NSString *);

NSString *hooked_pathForResourceOfTypeInDirectory(NSBundle *self, SEL _cmd, NSString *name, NSString *ext, NSString *subpath) {
    // Get Documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *customPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", name, ext]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:customPath]) {
        return customPath;
    }
    // Fallback to original
    return orig_pathForResourceOfTypeInDirectory(self, _cmd, name, ext, subpath);
}

__attribute__((constructor)) static void dylib_entry() {
    Class bundleClass = [NSBundle class];
    SEL selector = @selector(pathForResource:ofType:inDirectory:);
    Method method = class_getInstanceMethod(bundleClass, selector);
    if (method) {
        orig_pathForResourceOfTypeInDirectory = (void *)method_getImplementation(method);
        method_setImplementation(method, (IMP)hooked_pathForResourceOfTypeInDirectory);
    }
}
