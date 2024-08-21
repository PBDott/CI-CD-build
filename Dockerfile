# Node.js 14 버전을 기반으로 한 이미지
FROM node:14

# 작업 디렉터리 설정
WORKDIR /app

# 애플리케이션 의존성 설치
COPY package*.json ./
RUN npm install

# 애플리케이션 소스 코드 복사
COPY . .

# 포트 노출
EXPOSE 8079

# 컨테이너 시작 시 실행할 명령어
CMD ["node", "server.js"]
