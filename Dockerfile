# Stage 1: Build the application using the full Rust toolchain
FROM rust:1.86-bookworm as builder
# ^ Use a specific Rust version matching your needs/toolchain

WORKDIR /usr/src/app

# Copy manifests first to leverage Docker cache for dependencies
COPY Cargo.toml Cargo.lock ./
# Build dependencies only (no source code yet)
# Create a dummy main.rs to allow dependency build
RUN mkdir src && echo "fn main() {}" > src/main.rs && cargo build --release --locked

# Copy the actual source code
COPY src ./src

# Build the application executable (release mode)
# Removing dummy main.rs and rebuilding the final binary
RUN rm -f target/release/deps/hello_rust* && cargo build --release --locked


# Stage 2: Create the final, minimal runtime image
# Using Debian 'distroless' base image which includes glibc and other common runtime deps
# needed by standard Rust binaries. It's smaller and more secure than full Debian.
FROM debian:bookworm-slim as final
# Alternatives:
# FROM gcr.io/distroless/cc-debian12
# FROM alpine:latest (requires building Rust with musl target - more complex)

ARG APP_USER=app
ARG APP_GROUP=app
# Using numeric UID/GID is often recommended for consistency
ARG UID=1001
ARG GID=1001

# Set working directory
WORKDIR /app

# Create a non-privileged user and group first
# Using --system creates users/groups without login shells, suitable for services
RUN groupadd --system --gid ${GID} ${APP_GROUP} \
    && useradd --system --uid ${UID} --gid ${APP_GROUP} ${APP_USER}


# Copy *only* the compiled executable from the builder stage
COPY --from=builder /usr/src/app/target/release/hello-rust .

# [Optional] Set up a non-root user for security (distroless images often default to non-root)
# USER nonroot:nonroot

# Change ownership of the application directory and executable
# So the non-root user can access/execute it
RUN chown -R ${APP_USER}:${APP_GROUP} /app

# Switch to the non-root user THAT YOU CREATED
USER ${APP_USER}


# Command to run the executable when the container starts
CMD ["./hello-rust"]