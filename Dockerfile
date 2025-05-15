FROM arm32v7/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Native ARMv7 Compiler und Abhängigkeiten installieren
RUN sudo apt update && apt install -y \
    git cmake clang make curl wget unzip libcurl4-openssl-dev zlib1g-dev libunwind-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV CC=clang
ENV CXX=clang++

# .NET SDK 9.0 installieren
RUN mkdir -p /opt/dotnet && \
    curl -sSL https://dot.net/v1/dotnet-install.sh -o /opt/dotnet-install.sh && \
    chmod +x /opt/dotnet-install.sh && \
    /opt/dotnet-install.sh --channel 9.0 --install-dir /opt/dotnet

ENV DOTNET_ROOT=/opt/dotnet
ENV PATH=$PATH:/opt/dotnet

# NetCoreDbg und Runtime-Quellen holen
RUN git clone --recursive https://github.com/Samsung/netcoredbg.git /src/netcoredbg
RUN git clone https://github.com/dotnet/runtime.git /src/runtime && \
    cd /src/runtime && git checkout v9.0.4

# Ziel-Framework von NetCoreDbg automatisch auf netstandard2.1 aktualisieren
RUN find /src/netcoredbg -name "*.csproj" -exec sed -i 's/netstandard2.0/netstandard2.1/g' {} +

# Build durchführen mit Clang
# RUN cd /src/netcoredbg && \
#     mkdir build && cd build && \
#     CC=clang CXX=clang++ cmake .. && \
#     make && make install

WORKDIR /src/netcoredbg
CMD ["tail", "-f", "/dev/null"]
