//
//  NLCoreData.m
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
#import "NLCoreData.h"

@implementation NLCoreData

#pragma mark - Lifecycle

+ (NLCoreData *)shared
{
	static dispatch_once_t onceToken;
	__strong static id NLCoreDataSingleton_ = nil;
	
	dispatch_once(&onceToken, ^{
		
		NLCoreDataSingleton_ = [[self alloc] init];
	});
	
	return NLCoreDataSingleton_;
}

- (void)useDatabaseFile:(NSString *)filePath
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
#ifdef DEBUG
		[NSException raise:NLCoreDataExceptions.fileExist format:@"%@", filePath];
#endif
		return;
	}
	
	NSError* error;
	
	if (![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:[self storePath] error:&error]) {
#ifdef DEBUG
		[NSException raise:NLCoreDataExceptions.fileCopy format:@"%@", [error localizedDescription]];
#endif
	}
}

#pragma mark - Properties

- (NSString *)modelName
{
	if (_modelName)
		return _modelName;
	
	_modelName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	
	return _modelName;
}

- (NSString *)storePath
{
	NSArray* paths			= NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString* pathComponent = [[self modelName] stringByAppendingString:@".sqlite"];
	
	return [[paths lastObject] stringByAppendingPathComponent:pathComponent];
}

- (NSURL *)storeURL
{
	NSArray* urls			= [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
	NSString* pathComponent	= [[self modelName] stringByAppendingString:@".sqlite"];
	
	return [[urls lastObject] URLByAppendingPathComponent:pathComponent];
}

- (void)setStoreEncrypted:(BOOL)storeEncrypted
{
	NSString* encryption		= storeEncrypted ? NSFileProtectionComplete : NSFileProtectionNone;
	NSDictionary* attributes	= @{NSFileProtectionKey: encryption};
	NSError* error;
	
	if (![[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self storePath] error:&error]) {
#ifdef DEBUG		
		[NSException raise:NLCoreDataExceptions.encryption format:@"%@", [error localizedDescription]];
#endif
	}
}

- (BOOL)storeExists
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self storePath]];
}

- (BOOL)isStoreEncrypted
{
	NSError* error;
	NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self storePath] error:&error];
	
	if (!attributes) {
#ifdef DEBUG
		[NSException raise:NLCoreDataExceptions.encryption format:@"%@", [error localizedDescription]];
#endif
		return NO;
	}
	
	return [[attributes objectForKey:NSFileProtectionKey] isEqualToString:NSFileProtectionComplete];
}

- (NSPersistentStoreCoordinator *)storeCoordinator
{
	if (_storeCoordinator)
		return _storeCoordinator;
	
	_storeCoordinator		= [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSDictionary* options	= @{NSMigratePersistentStoresAutomaticallyOption: @YES};
	NSError* error			= nil;
	
	if (![_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error]) {
#ifdef DEBUG
		NSLog(@"metaData: %@", [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil URL:[self storeURL] error:nil]);
		NSLog(@"source and dest equivalent? %i", [[[error userInfo] valueForKeyPath:@"sourceModel"] isEqual:[[error userInfo] valueForKeyPath:@"destinationModel"]]);
		NSLog(@"failreason: %@", [[error userInfo] valueForKeyPath:@"reason"]);
		
		[NSException raise:NLCoreDataExceptions.persistentStore format:@"%@", [error localizedDescription]];
#endif
	}
	
	return _storeCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (_managedObjectModel)
		return _managedObjectModel;
	
	NSURL* url			= [[NSBundle mainBundle] URLForResource:[self modelName] withExtension:@"momd"];
	_managedObjectModel	= [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
	
	return _managedObjectModel;
}

@end
