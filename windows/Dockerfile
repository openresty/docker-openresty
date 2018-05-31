# Dockerfile - Windows
# https://github.com/openresty/docker-openresty

FROM microsoft/windowsservercore as downloader

ARG RESTY_VERSION="1.13.6.2"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:/dl

# Download Perl and OpenResty
RUN Invoke-WebRequest -Uri "https://chocolatey.org/install.ps1" -UseBasicParsing | iex ; \
    choco install strawberryperl -y --no-progress ; \
    mv C:\Strawberry\ C:\dl\ ; \
    Write-Host "Downloading OpenResty.." ; \
    Invoke-WebRequest "https://openresty.org/download/openresty-$($env:RESTY_VERSION)-win64.zip" -OutFile C:\openresty.zip ; \
    Expand-Archive C:\openresty.zip . ; \
    mv .\openresty-*\ .\openresty ; 


FROM microsoft/nanoserver

LABEL maintainer="Evan Wies <evan@neomantra.net>"

WORKDIR C:/openresty
RUN setx /M PATH "%PATH%;C:\Strawberry\perl\bin;C:\openresty"

CMD [ "nginx", "-g", "\"daemon off;\""]

COPY --from=downloader C:/dl/ C:/

# nginx config is not overwritten as paths in the Windows distribution are already fine