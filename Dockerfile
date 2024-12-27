# Базовый образ с поддержкой CUDA
FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Устанавливаем зависимости для сборки Python
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    libsqlite3-dev \
    wget \
    curl \
    libbz2-dev \
    && apt-get clean

# Скачиваем и компилируем Python 3.12
ENV PYTHON_VERSION=3.12.0
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz

# Устанавливаем pip и обновляем
RUN python3.12 -m ensurepip && \
    python3.12 -m pip install --upgrade pip

# Устанавливаем JupyterLab
RUN python3.12 -m pip install jupyterlab

# Устанавливаем библиотеки для ML/AI
RUN python3.12 -m pip install torch torchvision fastai

# Устанавливаем дополнительные зависимости для работы с Jupyter
RUN python3.12 -m pip install ipywidgets matplotlib pandas numpy scipy scikit-learn seaborn

# Создаем рабочую директорию
WORKDIR /workspace

# Открываем порт для JupyterLab
EXPOSE 8888

# Запускаем JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]