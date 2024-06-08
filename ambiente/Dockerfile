# Use a imagem oficial do OpenJDK 17
FROM openjdk:17-jdk-slim

# Crie um diretório de trabalho para a aplicação
WORKDIR /usr/src/app

# Copie o arquivo JAR da aplicação para o diretório de trabalho no contêiner
COPY ./Login_netmed/login-netmed/target/login-netmed.jar /usr/src/app/

# Exponha a porta que a aplicação irá rodar (caso necessário)
EXPOSE 8080

# Comando para executar a aplicação Java
CMD ["java", "-jar", "login-netmed.jar"]

