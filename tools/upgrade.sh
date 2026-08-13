#!/usr/bin/env sh
set -eu

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
info() { printf '> %s\n' "$*"; }

# Resolve the repo root regardless of where the script is invoked from.
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FORMULA="${REPO_ROOT}/Formula/ocb.rb"

[ -f "$FORMULA" ] || die "Formula not found at ${FORMULA}"

# ---------------------------------------------------------------------------
# Determine target version
# ---------------------------------------------------------------------------

TARGET_VERSION="${1:-}"

# Strip a leading 'v' if provided
TARGET_VERSION="${TARGET_VERSION#v}"

if [ -z "$TARGET_VERSION" ]; then
	info "No version specified — detecting latest OCB release..."

	TARGET_VERSION=$(
		gh api "repos/open-telemetry/opentelemetry-collector-releases/releases" \
			--jq '[.[] | select(.tag_name | startswith("cmd/builder/v")) | select(.prerelease == false)] | sort_by(.created_at) | last | .tag_name' \
		| sed 's|cmd/builder/v||'
	)

	[ -n "$TARGET_VERSION" ] || die "Could not determine latest OCB version"
	info "Latest version: ${TARGET_VERSION}"
fi

# ---------------------------------------------------------------------------
# Read current version from the formula
# ---------------------------------------------------------------------------

CURRENT_VERSION=$(sed -n 's/^  version "\(.*\)"/\1/p' "$FORMULA" | head -1)
[ -n "$CURRENT_VERSION" ] || die "Could not read current version from ${FORMULA}"

info "Current version: ${CURRENT_VERSION}"

if [ "$TARGET_VERSION" = "$CURRENT_VERSION" ]; then
	info "Formula is already at v${TARGET_VERSION}. Nothing to do."
	exit 0
fi

# ---------------------------------------------------------------------------
# Fetch checksums for the new version
# ---------------------------------------------------------------------------

BASE_URL="https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv${TARGET_VERSION}"

fetch_sha() {
	curl -fsSL "${BASE_URL}/ocb_${TARGET_VERSION}_${1}.sha256" || die "Failed to download checksum for ${1} v${TARGET_VERSION}"
}

info "Fetching checksums for v${TARGET_VERSION}"
SHA_DARWIN_ARM64=$(fetch_sha "darwin_arm64")
SHA_DARWIN_AMD64=$(fetch_sha "darwin_amd64")
SHA_LINUX_ARM64=$(fetch_sha  "linux_arm64")
SHA_LINUX_AMD64=$(fetch_sha  "linux_amd64")

for pair in \
	"darwin_arm64:${SHA_DARWIN_ARM64}" \
	"darwin_amd64:${SHA_DARWIN_AMD64}" \
	"linux_arm64:${SHA_LINUX_ARM64}"   \
	"linux_amd64:${SHA_LINUX_AMD64}"
do
	arch="${pair%%:*}"
	sha="${pair#*:}"
	[ -n "$sha" ] || die "Missing checksum for ${arch}"
done

# ---------------------------------------------------------------------------
# Patch the formula in-place
# ---------------------------------------------------------------------------

info "Updating ${FORMULA}"

# Bump version and replace all sha256 values in a single awk pass so the
# formula is never left in a partially-patched state.
awk -v new_ver="${TARGET_VERSION}" \
		-v sha_da="${SHA_DARWIN_ARM64}" \
		-v sha_dx="${SHA_DARWIN_AMD64}" \
		-v sha_la="${SHA_LINUX_ARM64}"  \
		-v sha_lx="${SHA_LINUX_AMD64}"  '
{
	if (/^  version "/) {
		sub(/"[^"]*"/, "\"" new_ver "\"")
	}

	if (/darwin_arm64/) { pending = sha_da }
	else if (/darwin_amd64/) { pending = sha_dx }
	else if (/linux_arm64/)  { pending = sha_la }
	else if (/linux_amd64/)  { pending = sha_lx }

	if (/sha256 "/ && pending != "") {
		sub(/"[^"]*"/, "\"" pending "\"")
		pending = ""
	}

	print
}
' "$FORMULA" > "${FORMULA}.new"

mv "${FORMULA}.new" "$FORMULA"

# ---------------------------------------------------------------------------
# Verify the result looks sane
# ---------------------------------------------------------------------------

NEW_VERSION=$(sed -n 's/^  version "\(.*\)"/\1/p' "$FORMULA" | head -1)
[ "$NEW_VERSION" = "$TARGET_VERSION" ] || die "Version in formula after patch is '${NEW_VERSION}', expected '${TARGET_VERSION}'"

info "Done. Formula bumped from v${CURRENT_VERSION} to v${TARGET_VERSION}."
