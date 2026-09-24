# 1. Imagen base: punto de partida con el runtime ya configurado
FROM python:3.11-slim

# 2. Directorio de trabajo: define la carpeta donde se ejecutarán los comandos
WORKDIR /app

# 3. Copiar dependencias e instalarlas (aprovecha la caché de capas de Docker)
COPY src/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copiar el resto del código fuente del proyecto
COPY src/ ./src/

# 5. Puerto que escuchará la aplicación dentro del contenedor (documentativo)
EXPOSE 5000

# 6. Comando por defecto al iniciar el contenedor
CMD ["python", "src/main.py"]