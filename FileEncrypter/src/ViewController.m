//
//  ViewController.m
//  FileEncrypter
//
//  Created by Anshumali Karna on 24/11/22.
//

#include "ViewController.h"
#include "FileEncrypter-Bridging-Header.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSVisualEffectView *visualEffectView = [[NSVisualEffectView alloc] initWithFrame:self.view.bounds];
    visualEffectView.material = NSVisualEffectMaterialTitlebar;
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    visualEffectView.state = NSVisualEffectStateActive;
    [self.view addSubview:visualEffectView positioned:NSWindowBelow relativeTo:nil];
    self.view.window.title = @"File Encrypter";
    [self.view.window center];
    self.view.window.opaque = NO;
    self.view.window.backgroundColor = [NSColor clearColor];
    
    [self.view.window makeFirstResponder:self.view];
    NSTextField *filePathTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 50, 300, 20)];
    filePathTextField.editable = NO;
    filePathTextField.selectable = NO;
    filePathTextField.placeholderString = @"No file selected";

    [self.view addSubview:filePathTextField];
    NSButton *selectFileButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 50, 100, 30)];
    selectFileButton.bezelStyle = NSBezelStyleRegularSquare;
    [selectFileButton setTitle:@"Select File"];
    [self.view.window makeFirstResponder:selectFileButton];
    [selectFileButton setTarget:self];
    [selectFileButton setAction:@selector(selectFileButtonAction:)];
    [self.view addSubview:selectFileButton];
    NSButton *encryptFileButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 10, 100, 30)];
    encryptFileButton.bezelStyle = NSBezelStyleRegularSquare;
    [encryptFileButton setTitle:@"Encrypt File"];
    [encryptFileButton setHidden:YES];
    [encryptFileButton setTarget:self];
    [self.view addSubview:encryptFileButton];
    NSProgressIndicator *loadingIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 300, 20)];
    loadingIndicator.indeterminate = YES;
    [loadingIndicator setHidden:YES];
    [self.view addSubview:loadingIndicator];
    
}
- (void)selectFileButtonAction:(NSString *)action {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.animationBehavior = NSWindowAnimationBehaviorDocumentWindow;
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canChooseFiles = YES;
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSString *filePath = openPanel.URL.path;
            [self.view.subviews[1] setStringValue:filePath];
            [self.view.subviews[3] setAction:@selector(encryptFileButtonAction)];
            [self.view.subviews[3] setHidden:NO];
        }
    }];

}



// Encrypt file using AES
- (void)encryptFileButtonAction {
    
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
