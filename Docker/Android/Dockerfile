FROM ghcr.io/cirruslabs/flutter:3.22.0

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos do projeto para o container
COPY . /app

# Baixa as dependências
# (Apenas será bem-sucedido após a criação do projeto Flutter)
RUN if [ -f pubspec.yaml ]; then flutter pub get; fi

# Expõe a porta para o servidor web de testes
EXPOSE 8080

# Comando padrão
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
