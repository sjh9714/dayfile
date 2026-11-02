#!/usr/bin/env bash
# Sample day for native QA of capture and memory, dated today in KST. Korean by default;
# FIXTURE_LANG=en is the README demo's data.
# Usage: scripts/qa/fixtures.sh "$QA_DIR", then qa_launch. Needs Pillow and target/debug/dayfile.
set -euo pipefail
Q="$1"
[[ ! -e "$Q/Journal" ]] || { echo "$Q already has a journal; run qa_reset first" >&2; exit 1; }
REPO="$(git rev-parse --show-toplevel)"
export TZ=Asia/Seoul DAYFILE_INDEX_DIR="$Q/idx" DAYFILE_CONFIG="$Q/config.json"
DAY=$(date +%F)
mkdir -p "$Q/code/shop-api" "$Q/photos"

if [[ "${FIXTURE_LANG:-ko}" == en ]]; then
  COMMITS=("10:12 Add order endpoint" "14:05 Fix refund rounding" "16:40 Cover refunds with tests")
  EV1="Standup" EV2="Algorithms study (Sam)" YESTERDAY="It rained all evening."
  HOME_T="Home" HOME1="Lives in Busan" HOME2="Lives in Seoul, Mapo"
  WORK_T="Work" WORK="Backend intern at a commerce startup"
  PEOPLE_T="People" PEOPLE="Sam is my algorithms study partner"
else
  COMMITS=("10:12 주문 API 추가" "14:05 환불 금액 반올림 버그 수정" "16:40 환불 테스트 보강")
  EV1="스탠드업" EV2="알고리즘 스터디 (민지)" YESTERDAY="어제는 비가 왔다"
  HOME_T="집" HOME1="부산에 산다" HOME2="서울 마포구에 산다"
  WORK_T="회사" WORK="커머스 스타트업 백엔드 인턴"
  PEOPLE_T="사람" PEOPLE="민지는 알고리즘 스터디 파트너"
fi

(
  cd "$Q/code/shop-api"
  gc() { GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git -c user.name=QA -c user.email=qa@example.com -c commit.gpgsign=false "${@:2}"; }
  git init -q
  for t in "${COMMITS[@]}"; do
    echo "$t" > f.txt
    gc "${DAY}T${t:0:5}:00+09:00" add .
    gc "${DAY}T${t:0:5}:00+09:00" commit -qm "${t:6}"
  done
)

D=${DAY//-/}
printf 'BEGIN:VCALENDAR\nBEGIN:VEVENT\nUID:q1\nSUMMARY:%s\nDTSTART;TZID=Asia/Seoul:%sT093000\nDTEND;TZID=Asia/Seoul:%sT094500\nEND:VEVENT\nBEGIN:VEVENT\nUID:q2\nSUMMARY:%s\nDTSTART;TZID=Asia/Seoul:%sT190000\nDTEND;TZID=Asia/Seoul:%sT210000\nEND:VEVENT\nEND:VCALENDAR\n' "$EV1" "$D" "$D" "$EV2" "$D" "$D" > "$Q/cal.ics"

python3 - "$Q/photos/IMG_0001.jpg" "${DAY//-/:} 18:20:00" <<'EOF'
import sys, struct, io
from PIL import Image
buf = io.BytesIO(); Image.new("RGB", (480, 320), (240, 170, 80)).save(buf, "JPEG"); jpg = buf.getvalue()
tiff = b"II*\0\x08\0\0\0" + bytes([1,0,0x69,0x87,4,0,1,0,0,0,26,0,0,0,0,0,0,0]) + bytes([1,0,0x03,0x90,2,0,20,0,0,0,44,0,0,0,0,0,0,0]) + sys.argv[2].encode() + b"\0"
app1 = b"\xff\xe1" + struct.pack(">H", 2 + 6 + len(tiff)) + b"Exif\0\0" + tiff
open(sys.argv[1], "wb").write(jpg[:2] + app1 + jpg[2:])
EOF

python3 -c "import json,sys; q=sys.argv[1]; json.dump({'capture': {'git': [q+'/code'], 'git_author': 'qa@example.com', 'calendars': [q+'/cal.ics'], 'photos': [q+'/photos']}}, open(q+'/config.json','w'))" "$Q"

J=("$REPO/target/debug/dayfile" --root "$Q/Journal")
"${J[@]}" init >/dev/null
"${J[@]}" add "$YESTERDAY" --at "$(date -v-1d +%F)T21:00:00+09:00" >/dev/null
src=$("${J[@]}" list | awk '{print $2}' | head -1)
old=$("${J[@]}" remember "$HOME_T" "$HOME1" --since 2019-01-01 | awk '{print $1}')
"${J[@]}" remember "$HOME_T" "$HOME2" --since 2024-03-01 --replaces "$old" --source "$src" >/dev/null
"${J[@]}" remember "$WORK_T" "$WORK" --since 2026-07-01 >/dev/null
"${J[@]}" remember "$PEOPLE_T" "$PEOPLE" >/dev/null
