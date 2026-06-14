#!/usr/bin/env bash
# Helper phát hiện stack qua manifest (tất định, nhanh) — hỗ trợ auto-scan.
# Dùng: ./scripts/detect-stack.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
set -euo pipefail
DIR="${1:-.}"
cd "$DIR"

echo "# Stack detection: $(pwd)"
hit=0
check() { if [[ -e "$1" ]]; then echo "- $1 → $2"; hit=1; fi; }

check package.json        "Node/JS-TS (xem scripts + dependencies)"
check tsconfig.json       "TypeScript"
check pom.xml             "Java/Kotlin — Maven"
check build.gradle        "Java/Kotlin — Gradle"
check build.gradle.kts    "Kotlin — Gradle"
check requirements.txt    "Python — pip"
check pyproject.toml      "Python — poetry/uv/pep621"
check Pipfile             "Python — pipenv"
check go.mod              "Go"
check Cargo.toml          "Rust"
check composer.json       "PHP"
check Gemfile             "Ruby"
check pubspec.yaml        "Dart/Flutter"
check Dockerfile          "Docker (lấy thêm lệnh build/run)"
check docker-compose.yml  "Docker Compose"
check Makefile            "Make (lấy lệnh)"
for f in *.csproj *.sln; do [[ -e "$f" ]] && echo "- $f → .NET" && hit=1; done

echo "# Linter/formatter:"
for f in .editorconfig .eslintrc* .prettierrc* ruff.toml .golangci* checkstyle*.xml .rubocop.yml; do
  [[ -e $f ]] && echo "- $f"
done

if [[ $hit -eq 0 ]]; then
  echo "(Không thấy manifest quen thuộc — agent cần khảo sát thủ công.)"
fi
