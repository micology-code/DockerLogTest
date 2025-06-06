ARG NAME="DockerLogTest"

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG NAME
WORKDIR /src

# copy csproj and restore as distinct layers
COPY *.sln .
COPY "$NAME/*.csproj" "./$NAME/"
RUN dotnet restore

# copy everything else and build app
COPY "$NAME/." "./$NAME/"
WORKDIR "/src/$NAME"
RUN dotnet publish -c release -o /app --no-restore


FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
ARG NAME
WORKDIR /app
EXPOSE 8080
COPY --from=build /app ./

ENV RunName="$NAME.dll"
ENTRYPOINT dotnet $RunName