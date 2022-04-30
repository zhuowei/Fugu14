set -e

CODESIGN_IDENTITY="4C1ED5BB460E754D8615D5D180BEB42AC96E1C15"

swiftcArgs=(-sdk "`xcrun --sdk iphoneos --show-sdk-path`" -target arm64-apple-ios14.0 -O -framework IOKit)

swiftBuild=(swift build -c release -Xcc "-DIOS_BUILD" -Xcc -target -Xcc arm64-apple-ios14.0 -Xcc -isysroot -Xcc "`xcrun --sdk iphoneos --show-sdk-path`" -Xlinker "$PWD/libkernrw_linking/libkernrw.0.tbd")
for arg in ${swiftcArgs[*]}
do
    swiftBuild+=(-Xswiftc "$arg")
done

echo Building jailbreakd
echo ${swiftBuild[*]}
${swiftBuild[*]}

#echo Stripping jailbreakd
#strip -s keep .build/release/jailbreakd

echo Signing jailbreakd
codesign -s "$CODESIGN_IDENTITY" --entitlements jailbreakd.entitlements .build/release/jailbreakd

cp .build/release/jailbreakd ../Fugu14App/Fugu14App/jailbreakd

CDHash=$(codesign -dvvv .build/release/jailbreakd 2>&1 | grep 'CDHash=' | sed 's/CDHash=//g')
echo CDHash of jailbreakd: $CDHash
