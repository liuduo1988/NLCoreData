//
//  NSManagedObject+NLCoreData.h
//  
//  Created by Jesper Skrufve <jesper@neolo.gy>
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//  

#import <CoreData/CoreData.h>

@interface NSManagedObject (NLCoreData)

#pragma mark - Inserting

/**
 @name Inserting
 
 */
+ (instancetype)insert;
+ (instancetype)insertInContext:(NSManagedObjectContext *)context;

#pragma mark - Deleting

/**
 @name Deleting
 
 */
- (void)delete;

/**
 @name Deleting
 
 */
+ (void)deleteWithRequest:(void (^)(NSFetchRequest* request))block;
+ (void)deleteWithRequest:(void (^)(NSFetchRequest* request))block context:(NSManagedObjectContext *)context;

/**
 @name Deleting
 
 */
+ (void)deleteWithPredicate:(id)predicateOrString, ...;
+ (void)deleteInContext:(NSManagedObjectContext *)context predicate:(id)predicateOrString, ...;

#pragma mark - Counting

/**
 @name Counting
 
 */
+ (NSUInteger)countWithPredicate:(id)predicateOrString, ...;
+ (NSUInteger)countInContext:(NSManagedObjectContext *)context predicate:(id)predicateOrString, ...;

/**
 @name Counting
 
 */
+ (NSUInteger)countWithRequest:(void (^)(NSFetchRequest* request))block;
+ (NSUInteger)countWithRequest:(void (^)(NSFetchRequest* request))block context:(NSManagedObjectContext *)context;

#pragma mark - Fetching

/**
 @name Fetching
 
 */
+ (instancetype)fetchWithObjectID:(NSManagedObjectID *)objectID;
+ (instancetype)fetchWithObjectID:(NSManagedObjectID *)objectID context:(NSManagedObjectContext *)context;

/**
 @name Fetching
 
 */
+ (NSArray *)fetchWithRequest:(void (^)(NSFetchRequest* request))block;
+ (NSArray *)fetchWithRequest:(void (^)(NSFetchRequest* request))block context:(NSManagedObjectContext *)context;

/**
 @name Fetching
 
 */
+ (NSArray *)fetchWithPredicate:(id)predicateOrString, ...;
+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context predicate:(id)predicateOrString, ...;

/**
 @name Fetching
 
 */
+ (instancetype)fetchSingleWithPredicate:(id)predicateOrString, ...;
+ (instancetype)fetchSingleInContext:(NSManagedObjectContext *)context predicate:(id)predicateOrString, ...;

/**
 @name Fetching
 
 */
+ (instancetype)fetchOrInsertSingleWithPredicate:(id)predicateOrString, ...;
+ (instancetype)fetchOrInsertSingleInContext:(NSManagedObjectContext *)context predicate:(id)predicateOrString, ...;

/**
 @name Fetching
 
 */
+ (void)fetchAsynchronouslyWithRequest:(void (^)(NSFetchRequest* request))block completion:(void (^)(NSArray* objects))completion context:(NSManagedObjectContext *)context;

/**
 @name Population
 @param dictionary NSDictionary with data to populate object
 */
- (void)populateWithDictionary:(NSDictionary *)dictionary;

/**
 @name Population
 @param dictionary NSDictionary with data to populate object
 @param matchTypes Check for data type match before setting value
 */
- (void)populateWithDictionary:(NSDictionary *)dictionary matchTypes:(BOOL)matchTypes;

#pragma mark - Miscellaneous

/**
 @name Miscellaneous
 */
- (BOOL)isPersisted;

@end
