#!/bin/sh
set -e


BUILD_CONFIGURATION=$1

PWDPATH=$PWD

CPPATH="${ANSIBLE_BUILD_ROOT:-$HOME}/build-${BUILD_CONFIGURATION}"
PROJECT="${CPPATH}/ansiblemacos"


sh "$PWDPATH/scripts/time-step.sh" source-sync \
    sh "$PWDPATH/buildbox/sync-source.sh" "$PWDPATH" "$PROJECT"

# Clear only this build's products. Older checkouts and runner-owned files may coexist here.
rm -rf "$CPPATH/ansiblemacos.xcarchive" "$CPPATH/Ansible.app" "$CPPATH/Ansible.app.dSYM" "$CPPATH/Ansible.app.DSYM.zip"
cd "$PROJECT"


BUILD_LOG_DIR="${CI_BUILD_LOG_DIR:-$CPPATH}"
mkdir -p "$BUILD_LOG_DIR"
FRAMEWORK_LOG="$BUILD_LOG_DIR/frameworks.log"
if ! sh scripts/time-step.sh frameworks sh "scripts/configure_frameworks.sh" > "$FRAMEWORK_LOG" 2>&1; then
    tail -80 "$FRAMEWORK_LOG"
    exit 1
fi
grep -E '^(framework-stamp:|build-timing:)' "$FRAMEWORK_LOG" || true
if ! cmp -s "configurations/${BUILD_CONFIGURATION}.xcconfig" "Ansible-Mac/Release.xcconfig"; then
    cp "configurations/${BUILD_CONFIGURATION}.xcconfig" "Ansible-Mac/Release.xcconfig"
fi

case "${BUILD_CONFIGURATION}" in
    Alpha) CHANNEL_CONDITION="ALPHA" ;;
    Beta) CHANNEL_CONDITION="BETA" ;;
    Stable) CHANNEL_CONDITION="STABLE" ;;
    AppStore|Appstore) CHANNEL_CONDITION="APP_STORE" ;;
    *) echo "Unknown build configuration: ${BUILD_CONFIGURATION}" >&2; exit 1 ;;
esac

set --
case "${ANSIBLE_COMPILATION_CACHE:-}" in
    YES|NO)
        set -- "COMPILATION_CACHE_ENABLE_CACHING=$ANSIBLE_COMPILATION_CACHE" \
            "COMPILATION_CACHE_ENABLE_DIAGNOSTIC_REMARKS=YES"
        ;;
    "") ;;
    *) echo "ANSIBLE_COMPILATION_CACHE must be YES or NO" >&2; exit 1 ;;
esac

XCODEBUILD_LOG="$BUILD_LOG_DIR/xcodebuild.log"
echo "Archiving, full log: ${XCODEBUILD_LOG}"
if ! sh scripts/time-step.sh archive xcodebuild archive -showBuildTimingSummary -workspace "Ansible-Mac.xcworkspace" \
-scheme Release \
-configuration Release \
-archivePath "$CPPATH/ansiblemacos.xcarchive" \
COMPILER_INDEX_STORE_ENABLE=NO \
"SWIFT_ACTIVE_COMPILATION_CONDITIONS=\$(inherited) ${CHANNEL_CONDITION}" "$@" > "${XCODEBUILD_LOG}" 2>&1; then
    grep -E -A3 '(^|: )(fatal )?error: |^ld: [^w]|^Undefined symbols' "${XCODEBUILD_LOG}" | head -300 || true
    echo "..."
    tail -20 "${XCODEBUILD_LOG}"
    exit 1
fi
echo "Archive succeeded"
sed -n '/^Build Timing Summary/,$p' "$XCODEBUILD_LOG" | tail -60


cd ..

archive="./ansiblemacos.xcarchive"
appname="Ansible.app"

rm -rf ${appname} ${appname}.dSYM ${appname}.DSYM.zip
cp -R "${archive}/Products/Applications/Ansible.app" ${appname}
cp -R "${archive}/dSYMs/Ansible.app.dSYM" ${appname}.dSYM


sh "$PWDPATH/scripts/time-step.sh" dsym-compression \
    ditto -c -k --sequesterRsrc --keepParent ${appname}.dSYM ${appname}.DSYM.zip
