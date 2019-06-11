# Dockerfile - Windows
# https://github.com/openresty/docker-openresty

ARG RESTY_INSTALL_BASE="mcr.microsoft.com/windows/servercore"
ARG RESTY_INSTALL_TAG="ltsc2019"

FROM ${RESTY_INSTALL_BASE}:${RESTY_INSTALL_TAG} AS downloader

ARG RESTY_INSTALL_BASE="mcr.microsoft.com/windows/servercore"
ARG RESTY_INSTALL_TAG="ltsc2019"
ARG RESTY_VERSION="1.15.8.1"

LABEL resty_install_base="${RESTY_INSTALL_BASE}"
LABEL resty_install_tag="${RESTY_INSTALL_TAG}"

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


ARG RESTY_IMAGE_BASE="mcr.microsoft.com/windows/nanoserver"
ARG RESTY_IMAGE_TAG="1903"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

ARG RESTY_IMAGE_BASE="mcr.microsoft.com/windows/nanoserver"
ARG RESTY_IMAGE_TAG="1903"
ARG RESTY_VERSION="1.15.8.1"

LABEL maintainer="Evan Wies <evan@neomantra.net>"
LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"
LABEL resty_version="${RESTY_VERSION}"

WORKDIR C:/openresty
RUN setx /M PATH "%PATH%;C:\Strawberry\perl\bin;C:\openresty"

CMD [ "nginx", "-g", "\"daemon off;\""]

COPY --from=downloader C:/dl/ C:/

# nginx config is not overwritten as paths in the Windows distribution are already fine
