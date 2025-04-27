# Use the official Rust image as a base
FROM rust:1.86-bookworm

# Define arguments for user creation (optional but good practice)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages:
# - git: For version control
# - lldb: Debugger executable needed by CodeLLDB VS Code extension
# - sudo: Allows vscode user to run commands as root if needed (optional)
# - build-essential, pkg-config, libssl-dev: Common dependencies for Rust crates
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        git \
        lldb \
        sudo \
        build-essential \
        pkg-config \
        libssl-dev \
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    # Add user to sudoers (optional, requires sudo package)
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# [Optional] Add other custom setup here if needed

# Switch to the non-root user you created
USER ${USERNAME}

# Set user's default shell to bash (optional, image might default to sh)
# SHELL ["/bin/bash", "-c"]