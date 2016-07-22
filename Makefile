NAME=PactConsumerSwift

GEM=rbenv exec gem
BUNDLE=rbenv exec bundle
POD=rbenv exec pod
SCAN=rbenv exec scan

XCPRETTY=rbenv exec xcpretty && exit ${PIPESTATUS[0]}

XCODEBUILD=xcodebuild -workspace $(NAME).xcworkspace

DEVICE_IOS="generic/platform=iOS"

.PHONY: build test

clean:
	rm -rf Pods
	$(XCODEBUILD) -scheme $(NAME)  -destination $(DEVICE_IOS)  clean | $(XCPRETTY)

install:
	brew update
	brew install carthage
	carthage build --platform iOS
	$(GEM) install bundler
	$(BUNDLE) install

build:
	$(XCODEBUILD) -scheme $(NAME) -destination $(DEVICE_IOS) clean build | $(XCPRETTY)

test:
	$(SCAN) -s $(NAME)

lint:
	$(POD) lib lint --private --verbose --allow-warnings $(NAME).podspec

lint_spec:
	$(POD) spec lint --private --verbose --allow-warnings $(NAME).podspec

push:
	$(POD) repo add    $(NAME) git@github.com:VEVO/PodSpecs.git
	$(POD) repo push   $(NAME) --allow-warnings --verbose $(NAME).podspec
	$(POD) repo remove $(NAME)
