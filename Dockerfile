FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy csproj and restore as distinct layers
COPY *.sln .
COPY DockerLogTest/*.csproj ./DockerLogTest/
RUN dotnet restore

# copy everything else and build app
COPY DockerLogTest/. ./DockerLogTest/
WORKDIR /src/DockerLogTest
RUN dotnet publish -c release -o /app --no-restore


FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
COPY --from=build /app ./

ENTRYPOINT ["dotnet", "DockerLogTest.dll"]