# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.4
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

USER root

# 替换成ali源
RUN touch /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian stable main contrib non-free" > /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian stable-updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/debian-security stable-security main contrib non-free" >> /etc/apt/sources.list

# 安装 Chrome 所需的依赖库
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libxss1 \
    libasound2 \
    libxtst6 \
    libgbm1 \
    libxshmfence1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /tmp

# 下载 Chrome 和 ChromeDriver
RUN wget https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.35/linux64/chrome-linux64.zip \
    && wget https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.35/linux64/chromedriver-linux64.zip

# 解压 Chrome 和 ChromeDriver
RUN mkdir -p /opt \ 
    && unzip chrome-linux64.zip -d /opt/chrome \
    && unzip chromedriver-linux64.zip -d /opt/chromedriver \
    && mv /opt/chrome/chrome-linux64/chrome /usr/local/bin/chrome \
    && mv /opt/chromedriver/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chrome \
    && chmod +x /usr/local/bin/chromedriver

# 清理临时文件
RUN rm -rf /tmp/*

USER vscode