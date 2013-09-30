#import <XCTest/XCTest.h>

#import "CCFURLResponder.h"

@interface CCFURLResponderTests : XCTestCase

@end

@implementation CCFURLResponderTests


- (void)tearDown {
    [super tearDown];
    sleep(1);
    [CCFURLResponder resetSchemes];
}


- (void)testPatternA {
    NSString *pattern = @"l:(animal)CCFAnimal/s:CCFAnimalName";
    BOOL didRegister = [CCFURLResponder registerSchemeWithPattern:pattern forNotificationName:@"CCFTestNotificationA" error:NULL];
    XCTAssertTrue(didRegister, @"will not register pattern A");
    
    if( didRegister ) {
        NSString *testURLStringA = @"ccfurlresponder://animal/dog";
        NSURL *url = [NSURL URLWithString:testURLStringA];
        NSNotification *note = [CCFURLResponder notificationWithURL:url];
        XCTAssertNotNil(note, @"notification for pattern A could not be created");
        
        if( note ) {
            NSString *actual = note.userInfo[@"CCFAnimal"];
            NSString *expected = @"animal";
            XCTAssertTrue([actual isEqualToString:expected], @"CCFAnimal keyed value is incorrect");
            
            actual = note.userInfo[@"CCFAnimalName"];
            expected = @"dog";
            XCTAssertTrue([actual isEqualToString:expected], @"CCFAnimalName keyed value is incorrect");
        }
    }
}

- (void)testPatternB {
    NSString *pattern = @"s:CCFWidget/i:CCFOrderQuantity/f:CCFWeight";
    BOOL didRegister = [CCFURLResponder registerSchemeWithPattern:pattern forNotificationName:@"CCFWidgetNotification" error:NULL];
    XCTAssertTrue(didRegister, @"will not register pattern B");
    
    NSURL *url = [NSURL URLWithString:@"ccfurlresponder://thneed/10000/3.14159"];
    NSNotification *note = [CCFURLResponder notificationWithURL:url];
    XCTAssertNotNil(note, @"notification for pattern B could not be created");
    
    NSString *actual = note.userInfo[@"CCFWidget"];
    NSString *expected = @"thneed";
    XCTAssertTrue([actual isEqualToString:expected], @"CCFWidget keyed value is incorrect");
    
    NSInteger actualQuantity = [note.userInfo[@"CCFOrderQuantity"] integerValue];
    NSInteger expectedQuantity = 10000;
    XCTAssertEqual(actualQuantity, expectedQuantity, @"incorrect order quantity for pattern B");
    
    float actualWeight = [note.userInfo[@"CCFWeight"] floatValue];
    float expectedWeight = 3.14159;
    XCTAssertEqualWithAccuracy(actualWeight, expectedWeight, 0.001, @"Incorrect item weight for pattern B");
}

- (void)testThatWeCanDistinguishBetweenMultiplePatterns {
    NSString *pattern = @"l:(animal)CCFAnimal/s:CCFAnimalName";
    BOOL didRegister = [CCFURLResponder registerSchemeWithPattern:pattern forNotificationName:@"CCFTestNotificationA" error:NULL];
    XCTAssertTrue(didRegister, @"will not register pattern A");
    
    NSString *patternB = @"s:CCFWidget/i:CCFOrderQuantity/f:CCFWeight";
    BOOL didRegisterB = [CCFURLResponder registerSchemeWithPattern:patternB forNotificationName:@"CCFWidgetNotification" error:NULL];
    XCTAssertTrue(didRegisterB, @"will not register pattern B");
    
    NSURL *url = [NSURL URLWithString:@"ccfurlresponder://thneed/98/2.56"];
    NSNotification *note = [CCFURLResponder notificationWithURL:url];
    XCTAssertNotNil(note, @"notification for pattern B could not be created");
    
    NSString *actual = note.userInfo[@"CCFWidget"];
    NSString *expected = @"thneed";
    XCTAssertTrue([actual isEqualToString:expected], @"CCFWidget keyed value is incorrect");
    
    NSInteger actualQuantity = [note.userInfo[@"CCFOrderQuantity"] integerValue];
    NSInteger expectedQuantity = 98;
    XCTAssertEqual(actualQuantity, expectedQuantity, @"incorrect order quantity for pattern B");
    
    float actualWeight = [note.userInfo[@"CCFWeight"] floatValue];
    float expectedWeight = 2.56;
    XCTAssertEqualWithAccuracy(actualWeight, expectedWeight, 0.01, @"Incorrect item weight for pattern B");
}

@end
