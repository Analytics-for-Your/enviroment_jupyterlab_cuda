# Используем базовый образ с поддержкой CUDA
FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Устанавливаем Python (замените на 3.13, если доступен)
RUN apt-get update && \
    apt-get install -y python3.13 python3.13-venv python3.13-dev python3-pip && \
    python3.13 -m pip install --upgrade pip

# Устанавливаем JupyterLab
RUN python3.13 -m pip install jupyterlab

# Устанавливаем библиотеки для ML/AI
RUN python3.13 -m pip install torch torchvision fastai

# Устанавливаем дополнительные зависимости для работы с Jupyter
RUN python3.13 -m pip install ipywidgets matplotlib pandas numpy scipy scikit-learn seaborn

# Создаем рабочую директорию
WORKDIR /workspace

# Открываем порт для JupyterLab
EXPOSE 8888

# Запускаем JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]