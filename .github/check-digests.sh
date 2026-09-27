#!/usr/bin/env bash
# Does every URL in the tap name a published asset, with the checksum the tap claims?
#
# Compared against the sha256 digest GitHub publishes for each release asset, so nothing is
# downloaded. GitHub counts a runner fetching an asset as a download, the same as a person, and
# Pikos's install numbers are read from those counts.
set -uo pipefail
cd "$(dirname "$0")/.."

pairs() {
  for f in Casks/*.rb; do
    v=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$f")
    s=$(sed -n 's/^  sha256 "\(.*\)"$/\1/p' "$f")
    u=$(sed -n 's/^  url "\(.*\)"$/\1/p' "$f")
    echo "${u//\#\{version\}/$v} $s"
  done
  awk '/^ *url "/    { sub(/^ *url "/, "");    sub(/".*/, ""); u = $0 }
       /^ *sha256 "/ { sub(/^ *sha256 "/, ""); sub(/".*/, ""); print u, $0 }' Formula/*.rb
}

fail=0; checked=0
while read -r url sha; do
  [ -n "$url" ] || continue
  checked=$((checked + 1))
  if [[ ! "$url" =~ ^https://github\.com/([^/]+/[^/]+)/releases/download/([^/]+)/([^/]+)$ ]]; then
    echo "not a GitHub release asset: $url"; fail=1; continue
  fi
  repo=${BASH_REMATCH[1]}; tag=${BASH_REMATCH[2]}; name=${BASH_REMATCH[3]}
  digest=$(gh api "repos/$repo/releases/tags/$tag" \
    --jq ".assets[] | select(.name == \"$name\") | .digest" 2>/dev/null)
  if [ -z "$digest" ]; then
    echo "no published asset: $url"; fail=1
  elif [ "$digest" != "sha256:$sha" ]; then
    echo "checksum mismatch: $url"; echo "   tap $sha, published ${digest#sha256:}"; fail=1
  else
    echo "ok $tag/$name"
  fi
done < <(pairs)

# A parse that finds nothing would otherwise pass having compared nothing.
[ "$checked" -gt 0 ] || { echo "found no url and sha256 pairs to check"; fail=1; }
exit $fail
