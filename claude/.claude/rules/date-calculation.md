# Date & Time Calculation (CRITICAL)

- 날짜/시간 계산은 절대 암산하지 말 것. 반드시 `date` 명령어 또는 `python3`을 사용
- 요일, 기간, D-day, 윤년, 월말 등 모든 날짜 산술에 적용

## 필수 사용 패턴 (macOS)

```bash
# 현재 날짜/시간
date '+%Y-%m-%d %A %H:%M:%S %Z'

# 특정 날짜의 요일
date -j -f '%Y-%m-%d' '2026-03-15' '+%A'

# N일 후/전
date -j -v+30d '+%Y-%m-%d %A'    # 30일 후
date -j -v-7d '+%Y-%m-%d %A'     # 7일 전
```

## 금지

- 날짜를 암산으로 계산
- 요일을 추측으로 답변
- 영업일 계산을 머리로 시도
