# ベースイメージを指定
FROM --platform=linux/amd64 python:3.9

# 作業ディレクトリを設定
WORKDIR /usr/src/app

# Pythonの依存関係ファイルをコピー
COPY requirements.txt ./
# 依存関係をインストール
RUN pip install --no-cache-dir -r requirements.txt

# アプリケーションのソースコードをコピー
COPY . .

# アプリケーションの起動コマンド
CMD ["python", "./your-script.py"]