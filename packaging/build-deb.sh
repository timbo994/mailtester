#!/usr/bin/env bash
set -euo pipefail

# Builds a .deb package for mail_tester.
# Installs the app to /opt/mail_tester and adds a menu entry
# under /usr/share/applications/.

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_NAME="mail-tester"
VERSION="$(grep '^version:' "$PROJECT_ROOT/pubspec.yaml" | sed -E 's/version:\s*([0-9.]+).*/\1/')"
ARCH="amd64"
PKG_ROOT="$PROJECT_ROOT/packaging/pkgroot"
BUNDLE_DIR="$PROJECT_ROOT/build/linux/x64/release/bundle"

echo "Building release bundle..."
(cd "$PROJECT_ROOT" && flutter build linux --release)

echo "Assembling package tree..."
rm -rf "$PKG_ROOT"
mkdir -p "$PKG_ROOT/DEBIAN"
mkdir -p "$PKG_ROOT/opt/mail_tester"
mkdir -p "$PKG_ROOT/usr/share/applications"

cp -r "$BUNDLE_DIR"/. "$PKG_ROOT/opt/mail_tester/"
cp "$PROJECT_ROOT/docs/icon.png" "$PKG_ROOT/opt/mail_tester/icon.png"

sed "s/__VERSION__/$VERSION/; s/__ARCH__/$ARCH/" \
  "$PROJECT_ROOT/packaging/debian/control.in" > "$PKG_ROOT/DEBIAN/control"

cp "$PROJECT_ROOT/packaging/debian/mail-tester.desktop" \
  "$PKG_ROOT/usr/share/applications/mail-tester.desktop"

find "$PKG_ROOT" -type d -exec chmod 755 {} +
find "$PKG_ROOT" -type f -exec chmod 644 {} +
chmod 755 "$PKG_ROOT/opt/mail_tester/mail_tester"

OUT_DEB="$PROJECT_ROOT/packaging/${PKG_NAME}_${VERSION}_${ARCH}.deb"
dpkg-deb --build --root-owner-group "$PKG_ROOT" "$OUT_DEB"

echo "Built $OUT_DEB"
