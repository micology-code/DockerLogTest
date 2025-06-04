FROM mcr.microsoft.com/dotnet/sdk:9.0 AS serverbuild
WORKDIR /src
COPY ["DockerLogTest/DockerLogTest.csproj", "."]
RUN dotnet restore "./DockerLogTest.csproj"
COPY . .
RUN dotnet publish "DockerLogTest.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 8080
COPY --from=serverbuild /app/publish .
RUN mkdir UploadedFiles

ENTRYPOINT ["dotnet", "DockerLogTest.dll"]