FROM rust:1.75-slim-bookworm AS builder

# Устанавливаем системные зависимости
RUN apt-get update && \
    apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Кэшируем зависимости
RUN cargo fetch

# Собираем релиз
RUN cargo build --release

# Финальный образ
FROM debian:bookworm-slim
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/target/release/rust-app /app/rust-app

EXPOSE 5000
CMD ["./rust-app"]
