#!/bin/bash

# 사용법: ./create_project.sh 새프로젝트이름

# 템플릿 디렉토리 (수정하지 마세요)
TEMPLATE_DIR=~/Templates/BaseTemplateProject
TEMPLATE_NAME="BaseTemplateProject"

# 입력받기
if [ -z "$1" ]; then
  read -p "📝 새 프로젝트 이름을 입력하세요: " NEW_PROJECT_NAME
else
  NEW_PROJECT_NAME=$1
fi

DEST_DIR="$(pwd)/$NEW_PROJECT_NAME"

# 존재 여부 확인
if [ -d "$DEST_DIR" ]; then
  echo "❗ 이미 같은 이름의 프로젝트가 존재합니다: $DEST_DIR"
  exit 1
fi

# 복사
cp -R "$TEMPLATE_DIR" "$DEST_DIR"

# 디렉토리/파일명 치환
find "$DEST_DIR" -depth -name "*$TEMPLATE_NAME*" | while read path; do
  new_path=$(echo "$path" | sed "s/$TEMPLATE_NAME/$NEW_PROJECT_NAME/g")
  mv "$path" "$new_path"
done

# 파일 내용 치환 (LC_CTYPE으로 바이너리 오류 방지)
find "$DEST_DIR" -type f | while read file; do
  LC_CTYPE=C sed -i '' "s/$TEMPLATE_NAME/$NEW_PROJECT_NAME/g" "$file"
done

echo "✅ 프로젝트 생성 완료: $DEST_DIR"
