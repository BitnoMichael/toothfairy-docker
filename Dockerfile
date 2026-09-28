# Используем официальный образ PyTorch с CUDA 11.8
FROM pytorch/pytorch:2.5.1-cuda11.8-cudnn9-runtime

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    git \
    wget \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Создаём пользователя (HF Jobs требует непривилегированного пользователя)
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

WORKDIR $HOME

# Клонируем репозиторий
RUN git clone https://github.com/LucaLumetti/UNetTransplant.git $HOME/UNetTransplant

# Устанавливаем Python-зависимости
WORKDIR $HOME/UNetTransplant
RUN pip install --no-cache-dir -r requirements.txt

# Точка входа — скрипт main.py. Параметры будут переданы при запуске Job.
ENTRYPOINT ["python", "main.py"]