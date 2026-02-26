#!/usr/bin/env python3
"""Claude Code 세션 히스토리에서 키워드를 검색하여 관련 컨텍스트를 출력한다."""

import glob
import json
import os
import sys
from datetime import datetime
from pathlib import Path

MAX_SESSIONS = 5
MAX_RESULTS = 3
MAX_SNIPPET_LEN = 300
PROJECTS_DIR = Path.home() / ".claude" / "projects"


def __resolve_project_dir(cwd: str) -> Path | None:
    """cwd에서 프로젝트 세션 디렉토리를 자동 탐지한다.

    Claude Code는 프로젝트 경로의 `/`와 `.`을 모두 `-`로 치환하여
    디렉토리명을 생성한다. 정확한 매치 실패 시 가장 유사한 디렉토리를
    찾는다.
    """
    if not PROJECTS_DIR.exists():
        return None

    # 정확한 매칭: `/`와 `.`을 `-`로 치환
    normalized = cwd.replace("/", "-").replace(".", "-")
    exact = PROJECTS_DIR / normalized
    if exact.is_dir():
        return exact

    # Fallback: cwd를 포함하는 가장 긴 매치 탐색
    candidates = sorted(PROJECTS_DIR.iterdir(), key=lambda d: len(d.name), reverse=True)
    cwd_parts = [p for p in cwd.split("/") if p]

    best_match = None
    best_score = 0

    for candidate in candidates:
        if not candidate.is_dir():
            continue
        name = candidate.name
        score = 0
        pos = 0
        for part in cwd_parts:
            # `.dotfiles` 같은 hidden dir은 dot 제거 후 매칭
            clean_part = part.lstrip(".")
            idx = name.find(clean_part, pos)
            if idx >= 0:
                score += len(clean_part)
                pos = idx + len(clean_part)

        if score > best_score:
            best_score = score
            best_match = candidate

    return best_match


def __collect_session_files(project_dir: Path) -> list[str]:
    """프로젝트 디렉토리에서 최근 세션 파일을 수집한다."""
    files = sorted(
        glob.glob(f"{project_dir}/*.jsonl"),
        key=os.path.getmtime,
        reverse=True,
    )
    return files[:MAX_SESSIONS]


def __extract_texts(entry):
    """JSONL entry에서 텍스트 콘텐츠를 추출한다."""
    msg = entry.get("message", {})
    content = msg.get("content", "")
    role = msg.get("role", "")

    if isinstance(content, list):
        texts = [
            c["text"]
            for c in content
            if isinstance(c, dict) and c.get("type") == "text"
        ]
    elif isinstance(content, str):
        texts = [content]
    else:
        texts = []

    return role, texts


def __search_keywords(files, keywords, *, project_label=""):
    """키워드 매치 결과를 반환한다."""
    kw_lower = [k.lower() for k in keywords]
    results = []

    for f in files:
        mtime = os.path.getmtime(f)
        dt = datetime.fromtimestamp(mtime).strftime("%Y-%m-%d")
        fname = os.path.basename(f)[:8]
        prefix = f"[{project_label}] " if project_label else ""

        with open(f) as fp:
            for line in fp:
                try:
                    entry = json.loads(line)
                    if entry.get("type") not in ("user", "assistant"):
                        continue

                    role, texts = __extract_texts(entry)
                    for text in texts:
                        if text.strip().startswith(("<local-command", "<system")):
                            continue
                        if any(kw in text.lower() for kw in kw_lower):
                            results.append(
                                f"{prefix}[{dt} / {fname}] [{role}]\n{text[:MAX_SNIPPET_LEN].strip()}\n---"
                            )
                            if len(results) >= MAX_RESULTS:
                                return results
                except (json.JSONDecodeError, KeyError):
                    pass

    return results


def __list_recent(files):
    """최근 세션의 첫 user 메시지를 나열한다."""
    lines = []

    for f in files[:3]:
        dt = datetime.fromtimestamp(os.path.getmtime(f)).strftime("%Y-%m-%d %H:%M")
        with open(f) as fp:
            for raw in fp:
                try:
                    entry = json.loads(raw)
                    if entry.get("type") != "user":
                        continue

                    _, texts = __extract_texts(entry)
                    for text in texts:
                        stripped = text.strip()
                        if stripped and not stripped.startswith("<"):
                            lines.append(f"[{dt}] {stripped[:100]}")
                            raise StopIteration
                except StopIteration:
                    break
                except (json.JSONDecodeError, KeyError):
                    pass

    return lines


def __search_all_projects(keywords):
    """모든 프로젝트에서 키워드를 검색한다."""
    if not PROJECTS_DIR.exists():
        print("NO_SESSIONS")
        return

    results = []
    for project in sorted(
        PROJECTS_DIR.iterdir(), key=lambda d: d.stat().st_mtime, reverse=True
    ):
        if not project.is_dir():
            continue
        files = __collect_session_files(project)
        if not files:
            continue
        # 프로젝트 이름에서 사람이 읽기 좋은 라벨 생성
        label = project.name.rsplit("-", 1)[-1] if "-" in project.name else project.name
        found = __search_keywords(files, keywords, project_label=label)
        results.extend(found)
        if len(results) >= MAX_RESULTS:
            break

    if results:
        print("\n".join(results[:MAX_RESULTS]))
    else:
        print("NO_MATCH")


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <cwd> <keyword1> [keyword2] ...")
        print(f"       {sys.argv[0]} --all <keyword1> [keyword2] ...")
        sys.exit(1)

    # --all: 모든 프로젝트에서 검색
    if sys.argv[1] == "--all":
        keywords = sys.argv[2:]
        if not keywords:
            print("Usage: --all requires at least one keyword")
            sys.exit(1)
        __search_all_projects(keywords)
        return

    cwd = sys.argv[1]
    keywords = sys.argv[2:]

    project_dir = __resolve_project_dir(cwd)

    if project_dir is None:
        print("NO_SESSIONS")
        return

    files = __collect_session_files(project_dir)

    if not files:
        print("NO_SESSIONS")
        return

    results = __search_keywords(files, keywords)
    if results:
        print("\n".join(results))
    else:
        print("NO_MATCH")
        print()
        for line in __list_recent(files):
            print(f"  - {line}")


if __name__ == "__main__":
    main()
