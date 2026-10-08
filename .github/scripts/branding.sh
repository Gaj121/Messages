#!/usr/bin/env bash
# Sets app name, package id and version (best-effort, Android Gradle projects)
set -e
BRAND="\${BRAND:-MyBrand}"
PKG="\${PKG:-}"
VER="\${VER:-1.0.0}"

for f in app/build.gradle app/build.gradle.kts build.gradle build.gradle.kts; do
  [ -f "$f" ] || continue
  sed -i "s/versionName *[\\"'].*[\\"']/versionName \\"$VER\\"/" "$f" || true
done

find . -name strings.xml | while read -r f; do
  sed -i "s|<string name=\\"app_name\\">.*</string>|<string name=\\"app_name\\">$BRAND</string>|" "$f" || true
done

if [ -n "$PKG" ]; then
  for f in app/build.gradle app/build.gradle.kts; do
    [ -f "$f" ] || continue
    sed -i "s/applicationId *[\\"'].*[\\"']/applicationId \\"$PKG\\"/" "$f" || true
  done
fi
echo "Branding applied: $BRAND $VER $PKG"
